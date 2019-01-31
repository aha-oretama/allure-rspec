module Turnip
  module Execute

    alias original_step step

    def step(step_or_description, *extra_args)
      # can use attach_file method in step.
      def self.attach_file(title, file, opts = {})
        ::RSpec.current_example.attach_file(title, file, opts)
      end

      ::RSpec.current_example.allure_step(step_or_description) do
        original_step(step_or_description, *extra_args)
      end
    end
  end
end