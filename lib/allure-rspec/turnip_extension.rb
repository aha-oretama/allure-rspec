module Turnip
  module Execute
    alias original_step step

    def step(step_or_description, *extra_args)
      suite = ::RSpec.current_example.example_group.parent_groups.last.description
      test = ::RSpec.current_example.example_group.description
      begin
        AllureRubyAdaptorApi::Builder.start_step(suite, test, step_or_description)
        original_step(step_or_description, *extra_args)
        AllureRubyAdaptorApi::Builder.stop_step(suite, test, step_or_description)
      rescue Exception => e
        AllureRubyAdaptorApi::Builder.stop_step(suite, test, step_or_description, :failed)
        raise e
      end
    end
  end
end