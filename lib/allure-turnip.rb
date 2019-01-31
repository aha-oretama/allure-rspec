require 'allure-ruby-adaptor-api'
require 'allure-turnip/version'
require 'allure-turnip/formatter'
require 'allure-turnip/adaptor'
require 'allure-turnip/dsl'
require 'allure-turnip/hooks'
require 'allure-turnip/turnip_extension'

module AllureTurnip
  module Config
    class << self
      attr_accessor :output_dir
      attr_accessor :clean_dir
      attr_accessor :logging_level
      attr_accessor :with_filename

      DEFAULT_OUTPUT_DIR = 'gen/allure-results'
      DEFAULT_LOGGING_LEVEL = Logger::DEBUG
      DEFAULT_WITH_FILENAME = false

      def output_dir
        @output_dir || DEFAULT_OUTPUT_DIR
      end

      def clean_dir?
        @clean_dir.nil? ? true : @clean_dir
      end

      def logging_level
        @logging_level || DEFAULT_LOGGING_LEVEL
      end

      def with_filename?
        @with_filename || DEFAULT_WITH_FILENAME
      end
    end
  end

  class Context
    attr_accessor :rspec

    def rspec
      @rspec
    end
  end

  class << self
    def context
      @context ||= Context.new
    end
  end

  class << self
    def configure(&block)
      yield Config
      AllureRubyAdaptorApi.configure { |c|
        c.output_dir = Config.output_dir
        c.logging_level = Config.logging_level
      }
    end
  end

end
