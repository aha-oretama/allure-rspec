# Allure Turnip

[![Gem Version](https://badge.fury.io/rb/allure-rspec.svg)](http://badge.fury.io/rb/allure-rspec)

Adaptor to use the Allure framework along with the [Turnip](https://github.com/jnicklas/turnip).

## What's new

See the [releases](https://github.com/aha-oretama/allure_turnip/releases) tab.


## Setup

Add the dependency to your Gemfile. Choose the version carefully:

| Allure Turnip | Turnip |
| ------------- | ------ |
| >= 0.1.x | >= 3.0 |

```ruby
 gem 'allure_turnip'
```

And then include it in your spec_helper.rb:

```ruby
    require 'allure_turnip'

    RSpec.configure do |c|
      c.include AllureRSpec::Adaptor
    end
```

## Advanced options

You can specify the directory where the Allure test results will appear. By default it would be 'gen/allure-results'
within your current directory.  
When you add a `feature_with_filename` option, the suites of the the Allure test results include file's name as a prefix.  
This options is useful if you have some same feature names. Because Allure overwrites the same feature name's result if there are some same feature names.

```ruby
    AllureRSpec.configure do |c|
      c.output_dir = "/whatever/you/like" # default: gen/allure-results
      c.clean_dir = false # clean the output directory first? (default: true)
      c.logging_level = Logger::DEBUG # logging level (default: DEBUG)
      c.feature_with_filename = true # default: false
    end
```

## DSL
In your *step* method, you can call `attach_file` method.
The method attaches the file in the Allure result.

## Usage examples

**feature**
```ruby
Feature: Attach File
  Scenario: This is an attaching file feature
    Given attach file
```

**steps**
```ruby
step 'attach file' do
  attach_file "test-file1", Tempfile.new("test")
end
```