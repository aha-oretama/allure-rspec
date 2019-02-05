require 'rspec'
require 'allure-turnip'
require 'nokogiri'
require 'turnip'

Dir.glob("spec/steps/**/*steps.rb") { |f| load f, true }

RSpec.configure do |c|
  c.include AllureTurnip::Adaptor
  c.before(:suite) do
    puts 'Before Suite Spec helper'
  end

  c.before(:all) do
    puts 'Before all Spec helper'
  end
end

AllureTurnip.configure do |c|
  c.output_dir = "allure"
  c.feature_with_filename = true
end

