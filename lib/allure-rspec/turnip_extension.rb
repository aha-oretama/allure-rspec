module Turnip
  module Execute

    alias original_step step

    def step(step_or_description, *extra_args)
      ::RSpec.current_example.step(step_or_description) do
        original_step(step_or_description, *extra_args)
      end
    end
  end
end