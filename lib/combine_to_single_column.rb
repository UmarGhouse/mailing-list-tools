# Module to combine the split data into a single column for analysis
# with duplicates removed. Example output:
# [
#   'email1',
#   'email2',
#   ...
# ]

class Combine_to_single_column
  def self.combine(split_data)
    final_list = []

    # See ./split.rb for a breakdown of what split_data looks like
    split_data.each do |mailing_list_hash|
      # mailing_list_hash == { mailing_list: [ { company_name: { cc: [], bcc: [] } } ] }
      mailing_list_hash.each do |mailing_list, array_of_companies|
        array_of_companies.each do |company_hash|
          # company_hash == { company_name: { cc: [], bcc: [] } }
          company_hash.each do |company_name, email_hash|
            # email_hash == { cc: [], bcc: [] }

            # Add all emails to the final_list
            if email_hash[:cc] != []
              email_hash[:cc].each { |email| final_list << email }
            end

            if email_hash[:bcc] != []
              email_hash[:bcc].each { |email| final_list << email }
            end
          end
        end
      end
    end

    # Now we remove duplicates
    final_list.uniq!

    export_string = ""

    # Now we combine each item in final_list to a single string
    # so that it can be written to a csv
    final_list.each do |email|
      export_string << "#{email}\n"
    end

    export_string
  end
end
