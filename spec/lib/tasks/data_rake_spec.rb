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
  end

  it "should raise an error if the file doesn't exist" do
    File.should_receive(:exists?).and_return(false)
    lambda {
      subject.invoke
    }.should raise_error
  end
end

describe "data:import" do
  include_context 'rake'
  let(:example_file) { File.join(Rails.root, "tmp/data.csv") }
  let(:download_file) { File.join(Rails.root, "spec/fixtures/data_example_earthquakes.csv") }
  let(:earthquake) { Earthquake.new(
      :src => 'us',
      :eqid => 'b000gym1',
      :version => '7',
      :datetime => "Saturday, May 18, 2013 22:39:46 UTC",
      :lat => 52.6720,
      :lon => 158.9419,
      :magnitude => 4.9,
      :depth => 73.80,
      :nst => 134,
      :region => "near the east coast of the Kamchatka Peninsula, Russia"
  )}

  its(:prerequisites) { should include("environment") }

  it "should import the data" do
    FileUtils.cp(example_file, download_file)
    num_records = File.readlines(example_file).length - 1
    subject.invoke
    Earthquake.count.should == num_records
  end

  it "should store the raw record" do
    FileUtils.cp(example_file, download_file)
    last_row = File.readlines(example_file).last.chomp
    subject.invoke
    Earthquake.last.raw.should == last_row
  end

  it "should not import duplicate records" do
    FileUtils.cp(example_file, download_file)
    num_records = File.readlines(example_file).length - 1
    subject.invoke
    Earthquake.count.should == num_records
    new_hash = Earthquake.first.attributes.dup
    [:id, :created_at, :updated_at].each {|k| new_hash.delete(k.to_s)}
    lambda { Earthquake.create!(new_hash) }.should raise_error
    Earthquake.count.should == num_records
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
