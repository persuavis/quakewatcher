# data.rake

$tmp_file = 'tmp/data.csv'

namespace :data do
  desc "Download earthquake data"
  task :download  do |task_name|
    require 'open-uri'
    url = 'http://earthquake.usgs.gov/earthquakes/catalogs/eqs7day-M1.txt'
    puts "#{task_name}: now downloading earthquake data from #{url}"
    open($tmp_file, 'w') do |file|
      file << open(url).read
    end
    #open($tmp_file, 'w') do |file| # for testing
    #  file << open('spec/fixtures/data_example_earthquakes.csv').read
    #end
    raise "ERROR" if !File.exists?($tmp_file)
    puts "data is stored in #{$tmp_file}"
  end

  desc "Import earthquake data"
  task :import => :environment do |task_name|
    require 'csv'
    puts "===>>> #{task_name}: now importing earthquake data from #{$tmp_file}"
    raise "ERROR" if !File.exists?($tmp_file)
    count = 0
    puts "\n==>> starting with #{Earthquake.count} total records"
    headers = nil
    File.readlines($tmp_file).each do |line|
      CSV.parse(line, :headers => headers) do |row|
        if headers.nil?
          headers = row
          next
        end
        new_hash = row.each_with_object({}) do |(k, v), h|
          h[k.downcase] = v
        end
        new_hash["raw"] = line.chomp
        eq = Earthquake.create(new_hash, :without_protection => true)
        count += 1 unless eq.id.nil?
      end
    end
    puts "<<== loaded #{count} new records (#{Earthquake.count} total records)"
  end

  desc "Update earthquake data"
  task :update => [:download, :import] do |task_name|
  end
end
