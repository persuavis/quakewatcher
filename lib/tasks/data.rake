# data.rake

$tmp_file = 'tmp/data.csv'

namespace :data do
  desc "Download earthquake data"
  task :download  do |task_name|
    require 'open-uri'
    url = 'http://earthquake.usgs.gov/earthquakes/catalogs/eqs7day-M1.txt'
    puts "#{task.name}: now downloading earthquake data from #{url}"
    #open($tmp_file, 'w') do |file|
    #  file << open(url).read
    #end
    open($tmp_file, 'w') do |file|
      file << open('spec/fixtures/data_example_earthquakes.csv').read
    end
    raise "ERROR" if !File.exists?($tmp_file)
    puts "data is stored in #{$tmp_file}"
  end

  desc "Import earthquake data"
  task :import => :environment do |task_name|
    puts "#{task_name}: now importing earthquake data from #{$tmp_file}"

    raise "ERROR" if !File.exists?($tmp_file)

    @csv_data = Array.new
  end

  desc "Update earthquake data"
  task :update => [:download, :import] do |task_name|
    puts "#{task.name}: now updating earthquake data"
  end
end
