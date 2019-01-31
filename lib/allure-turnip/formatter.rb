require 'rspec/core' unless defined?(RSpec::Core)
require 'rspec/core/formatters/base_formatter' unless defined?(RSpec::Core::Formatters::BaseFormatter)
require 'fileutils'

module AllureTurnip

  class Formatter < RSpec::Core::Formatters::BaseFormatter

    NOTIFICATIONS = [:example_group_started, :example_group_finished,
                     :example_failed, :example_passed, :example_pending, :start, :stop]
    ALLOWED_LABELS = [:feature, :story, :severity, :language, :framework, :issue, :testId, :host, :thread]

    def example_failed(notification)
      return unless turnip?(notification)

      ex = notification.example.execution_result.exception
      status = ex.is_a?(RSpec::Expectations::ExpectationNotMetError) ? :failed : :broken
      formatter = RSpec.configuration.backtrace_formatter
      formatter.exclusion_patterns.push /lib\/allure-turnip/
      backtrace = formatter.format_backtrace(ex.backtrace, notification.example.metadata)
      ex.set_backtrace(backtrace)
      stop_test(notification.example, :exception => ex, :status => status)
    end

    def example_group_finished(notification)
      return unless turnip?(notification)

      if notification.group.examples.empty? # Feature has no examples
        AllureRubyAdaptorApi::Builder.stop_suite(suite(notification.group))
      end
    end

    def example_group_started(notification)
      return unless turnip?(notification)

      if notification.group.examples.empty? # Feature has no examples
        AllureRubyAdaptorApi::Builder.start_suite(suite(notification.group), labels(notification))
      else # Scenario has examples
        suite = suite(notification.group)
        test = test(notification.group)
        AllureRubyAdaptorApi::Builder.start_test(suite, test, labels(notification))
      end
    end

    def example_passed(notification)
      return unless turnip?(notification)

      stop_test(notification.example)
    end

    def example_pending(notification)
      return unless turnip?(notification)

      stop_test(notification.example)
    end

    def start(example_count)
      dir = Pathname.new(AllureTurnip::Config.output_dir)
      if AllureTurnip::Config.clean_dir?
        puts "Cleaning output directory '#{dir}'..."
        FileUtils.rm_rf(dir)
      end
      FileUtils.mkdir_p(dir)
    end

    def stop(notify)
      AllureRubyAdaptorApi::Builder.build!
    end

    private

    def turnip?(notification)
      metadata(notification)[:turnip]
    end

    def stop_test(example, opts = {})
      res = example.execution_result
      AllureRubyAdaptorApi::Builder.stop_test(
          suite(example.example_group),
          test(example.example_group),
          {
              :status => res.status,
              :finished_at => res.finished_at,
              :started_at => res.started_at
          }.merge(opts)
      )
    end

    def suite(group)
      if AllureTurnip::Config.feature_with_filename?
        "#{File.split(group.parent_groups.last.metadata[:file_path])[1]} -> #{group.parent_groups.last.description}"
      else
        group.parent_groups.last.description
      end
    end

    def test(group)
      group.metadata[:full_description]
    end

    def metadata(example_or_group)
      group?(example_or_group) ?
          example_or_group.group.metadata :
          example_or_group.example.metadata
    end

    def group?(example_or_group)
      (example_or_group.respond_to? :group)
    end

    def labels(example_or_group)
      labels = ALLOWED_LABELS.map { |label| [label, metadata(example_or_group)[label]] }.
          find_all { |value| !value[1].nil? }.
          inject({}) { |res, value| res.merge(value[0] => value[1]) }
      detect_feature_story(labels, example_or_group)
      labels
    end

    def method_or_key(metadata, key)
      metadata.respond_to?(key) ? metadata.send(key) : metadata[key]
    end

    def detect_feature_story(labels, example_or_group)
      metadata = metadata(example_or_group)
      is_group = group?(example_or_group)
      parent = (method_or_key(metadata, :parent_example_group))
      if labels[:feature] === true
        description = (!is_group && parent) ? method_or_key(parent, :description) : method_or_key(metadata, :description)
        labels[:feature] = description
        if labels[:story] === true
          if parent
            grandparent = parent && method_or_key(parent, :parent_example_group)
            labels[:feature] = (!is_group && grandparent) ? method_or_key(grandparent, :description) :
                method_or_key(parent, :description)
          end
          labels[:story] = description
        end
      end
      labels
    end

  end
end
