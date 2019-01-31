module AllureTurnip
  module Adaptor
    def self.included(base)
      AllureTurnip.context.rspec = base
      base.send :include, AllureTurnip::DSL
      if RSpec::Core::Formatters::Loader.formatters.keys.find_all { |f| f == AllureTurnip::Formatter }.empty?
        RSpec::Core::Formatters.register AllureTurnip::Formatter, *AllureTurnip::Formatter::NOTIFICATIONS
        RSpec.configuration.add_formatter(AllureTurnip::Formatter)
      end
      RSpec::Core::ExampleGroup.send :include, AllureTurnip::Hooks
      RSpec::Core::Example.send :include, AllureTurnip::DSL::Example
    end
  end
end

