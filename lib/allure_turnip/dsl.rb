require 'digest'
require 'mimemagic'

module AllureTurnip
  module DSL
    module Example

      def current_step
        if defined? @@__current_step
          @@__current_step
        else
          nil
        end
      end

      def allure_step(step, &block)
        begin
          locked = __mutex.try_lock
          if locked
            @@__current_step = step
            __with_allure_step(step, &block)
          else
            __with_step(step,&block)
          end
        ensure
          if locked
            @@__current_step = nil
            __mutex.unlock
          end
        end
      end

      def attach_file(title, file, opts = {})
        step = current_step
        AllureRubyAdaptorApi::Builder.add_attachment __suite, __test, opts.merge(:title => title, :file => file, :step => step)
      end

      private

      def __suite
        parent_group = metadata[:example_group][:parent_example_group]
        parent_group = parent_group.has_key?(:parent_example_group) ? parent_group[:parent_example_group] : parent_group
        if AllureTurnip::Config.feature_with_filename?
          "#{File.split(parent_group[:file_path])[1]} -> #{parent_group[:description]}"
        else
          parent_group[:description]
        end
      end

      def __test
        metadata[:example_group][:full_description]
      end

      def __description(data)
        data[:full_description] || data[:description]
      end

      def __mutex
        @@__mutex ||= Mutex.new
      end

      def __with_allure_step(step, &block)
        begin
          AllureRubyAdaptorApi::Builder.start_step(__suite, __test, step)
          __with_step(step, &block)
          AllureRubyAdaptorApi::Builder.stop_step(__suite, __test, step)
        rescue Exception => e
          AllureRubyAdaptorApi::Builder.stop_step(__suite, __test, step, :failed)
          raise e
        end
      end

      def __with_step(step, &block)
        AllureTurnip.context.rspec.hooks.send :run, :before, :step, self
        yield self
        AllureTurnip.context.rspec.hooks.send :run, :after, :step, self
      end
    end
  end
end

