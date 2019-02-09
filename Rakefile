
begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec, []) do |t|
    t.fail_on_error = false
    t.pattern = 'spec/**{,/*/**}/*.feature'
  end

  RSpec::Core::RakeTask.new(:rspec => :spec) do |t|
    t.pattern = 'rspec/**{,/*/**}/*_spec.rb'
  end

  task :default => :rspec
rescue LoadError
  # no rspec available
end