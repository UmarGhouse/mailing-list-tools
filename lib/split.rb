# Module to split all of the emails on each row into individual emails
# Should return an array of all emails by excel and by company. Ex.:
# [
#   {
#     excel_name: [
#       {
#         company: {
#           cc: [],
#           bcc: []
#         }
#       }
#     ]
#   }
# ]

class Split
  def self.split
    # -------- Question to get type of file -------- #
    file_type = Dialogue.select_file_type
    
    # -------- Get list of files -------- #
    # Array to hold all the file paths for each excel sheet
    array_of_files = []
    
    Dir.glob("./data/*.#{file_type}").each do |f|
      array_of_files << f
    end
    
    output = []
    
    array_of_files.each do |file_path|
      output_key = file_path.split('/')[-1].downcase.gsub(' ', '_').split('.')[0]
    
      file_hash = { "#{output_key}": [] }
    
      # Open each file
      workbook = Roo::Spreadsheet.open(file_path)
    
      # We assume that the first sheet will have all the data that we need
      sheet = workbook.sheet(0)
    
      # An empty array to hold all the rows
      all_rows = []
    
      sheet.each do |row|
        all_rows << row
      end
    
      # Removing header row
      all_rows.shift
    
      all_rows.each do |row|
        company_hash = { "#{row[0]}": { cc: [], bcc: [] } }
    
        if row[1]
          company_hash[:"#{row[0]}"][:cc] = row[1].split("; ").each {|email| email.downcase}
        end
    
        if row[2]
          company_hash[:"#{row[0]}"][:bcc] = row[2].split("; ").each {|email| email.downcase}
        end
    
        file_hash[:"#{output_key}"] << company_hash
      end
    
      output << file_hash
    end
    
    output
  end
end

