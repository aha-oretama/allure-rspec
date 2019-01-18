require 'rspec'
require 'allure-rspec'
require 'nokogiri'
require 'turnip'

Dir.glob("spec/steps/**/*steps.rb") { |f| load f, true }

RSpec.configure do |c|
  c.include AllureRSpec::Adaptor
  c.before(:suite) do
    puts 'Before Suite Spec helper'
  end

  c.before(:all) do
    puts 'Before all Spec helper'
  end
end

AllureRSpec.configure do |c|
  c.output_dir = "allure"
end

