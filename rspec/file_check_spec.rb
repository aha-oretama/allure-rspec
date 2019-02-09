require_relative '../rspec/spec_helper'

describe "Check output files" do

  it "There are as many xml files as feature files without blank file" do
    feature_count = Dir.glob(File.join(__dir__, '../spec/**/*.feature')).select {|file| File.basename(file) != 'blank.feature' }.count
    xml_count = Dir.glob(File.join(__dir__, '../allure/*.xml')).count

    puts "feature_count:#{feature_count}"
    puts "xml_count:#{xml_count}#"

    expect(xml_count).to eq(feature_count)
  end

  it "attach file step create a file" do
    step_count = 0
    Dir.glob(File.join(__dir__, '../spec/**/*.feature')).each do |path|
      File.open(path,"r") do |file|
        file.read.scan(/attach file/) do
          step_count += 1
        end
      end
    end
    file_count = Dir.glob(File.join(__dir__, '../allure/*-attachment')).count

    puts "file_count:#{file_count}#"
    puts "step_count:#{step_count}#"

    expect(file_count).to eq(step_count)
  end
end
