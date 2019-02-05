require 'allure-ruby-adaptor-api'
require 'turnip'
require 'allure_turnip/version'
require 'allure_turnip/formatter'
require 'allure_turnip/adaptor'
require 'allure_turnip/dsl'
require 'allure_turnip/hooks'
require 'allure_turnip/turnip_extension'

module AllureTurnip
  module Config
    class << self
      attr_accessor :output_dir
      attr_accessor :clean_dir
      attr_accessor :logging_level
      attr_accessor :feature_with_filename

      DEFAULT_OUTPUT_DIR = 'gen/allure-results'
      DEFAULT_LOGGING_LEVEL = Logger::DEBUG
      DEFAULT_FEATURE_WITH_FILENAME = false

      def output_dir
        @output_dir || DEFAULT_OUTPUT_DIR
      end

      def clean_dir?
        @clean_dir.nil? ? true : @clean_dir
      end

      def logging_level
        @logging_level || DEFAULT_LOGGING_LEVEL
      end

      def feature_with_filename?
        @feature_with_filename || DEFAULT_FEATURE_WITH_FILENAME
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
