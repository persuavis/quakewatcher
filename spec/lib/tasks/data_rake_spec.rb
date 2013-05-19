require 'spec_helper.rb'
require File.expand_path("../../../support/shared_contexts/rake", __FILE__)

describe "data:download" do
  include_context "rake"
  let(:download_file) { "tmp/data.csv"}

  it "should download the data" do
    filename = File.join(Rails.root, download_file)
    FileUtils.rm(filename) if File.exists?(filename)
    subject.invoke
    File.exists?(filename).should be_true
    pending
  end

  it "should raise an error if the file doesn't exist" do
    File.should_receive(:exists?).and_return(false)
    lambda {
      subject.invoke
    }.should raise_error
  end

end

describe "data:import" do
  include_context "rake"
  let(:example_file) { File.join(Rails.root, "tmp/data.csv") }
  let(:download_file) { File.join(Rails.root, "spec/fixtures/data_example_earthquakes.csv") }

  its(:prerequisites) { should include("environment") }

  it "should import the data" do
    FileUtils.cp(example_file, download_file)
    num_lines = File.readlines(example_file).length
    puts "supposed to read #{num_lines} lines"
    subject.invoke

    pending
  end

  it "should raise an error if the file doesn't exist" do
    File.should_receive(:exists?).and_return(false)
    lambda {
      subject.invoke
    }.should raise_error
  end

end

describe "data:update" do
  include_context "rake"

  its(:prerequisites) { should include("download") }
  its(:prerequisites) { should include("import") }

end
