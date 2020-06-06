# Module to write the output of other modules to a CSV

class Write_to_csv
  def self.write_file(filename, export_data)
    File.open("./exports/#{filename}.csv", 'w+') do |file|
      file << export_data.to_s
    end
  end
end