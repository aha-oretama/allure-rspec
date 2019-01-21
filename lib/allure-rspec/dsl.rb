require 'digest'
require 'mimemagic'
module AllureRSpec
  module DSL
    module Example

      def current_step
        if defined? @@__current_step
          @@__current_step
        else
          nil
        end
      end

      def step(step, &block)
        begin
          AllureRubyAdaptorApi::Builder.start_step(suite, test, step)
          __with_step step, &block
          AllureRubyAdaptorApi::Builder.stop_step(suite, test, step)
        rescue Exception => e
          AllureRubyAdaptorApi::Builder.stop_step(suite, test, step, :failed)
          raise e
        end
      end

      def attach_file(title, file, opts = {})
        step = current_step
        AllureRubyAdaptorApi::Builder.add_attachment suite, test, opts.merge(:title => title, :file => file, :step => step)
      end

      private

      def suite
        if AllureRSpec::Config.with_filename?
          "#{File.split(metadata[:example_group][:parent_example_group][:file_path])[1]} -> #{metadata[:example_group][:parent_example_group][:description]}"
        else
          metadata[:example_group][:parent_example_group][:description]
        end
      end

      def test
        metadata[:example_group][:full_description]
      end

      def __description(data)
        data[:full_description] || data[:description]
      end

      def __mutex
        @@__mutex ||= Mutex.new
      end

      def __with_step(step, &block)
        begin
          locked = __mutex.try_lock
          if locked
            @@__current_step = step
            AllureRSpec.context.rspec.hooks.send :run, :before, :step, self
            yield self
          end
        ensure
          if locked
            AllureRSpec.context.rspec.hooks.send :run, :after, :step, self
            @@__current_step = nil
            __mutex.unlock
          end
        end
      end
    end
  end
end

