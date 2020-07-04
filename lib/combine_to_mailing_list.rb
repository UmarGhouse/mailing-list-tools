# Module to combine the split data into a single mailing list
# with duplicates removed. Example output:
# {
#   company: {
#     cc: [],
#     bcc: []
#   }
# }

class Combine_to_mailing_list
  def self.combine(split_data)
    final_list = {}

    # See ./split.rb for a breakdown of what split_data looks like
    split_data.each do |mailing_list_hash|
      # mailing_list_hash == { mailing_list: [ { company_name: { cc: [], bcc: [] } } ] }
      mailing_list_hash.each do |mailing_list, array_of_companies|
        array_of_companies.each do |company_hash|
          # company_hash == { company_name: { cc: [], bcc: [] } }
          company_hash.each do |company_name, email_hash|
            # email_hash == { cc: [], bcc: [] }

            # If the final list does NOT yet have a key for this company
            # Create one, with cc and bcc arrays within it
            if !final_list[:"#{company_name}"]
              final_list[:"#{company_name}"] = { cc: [], bcc: [] }  
            end

            # After the key has been created, add the emails to each array
            if email_hash[:bcc] != []
              email_hash[:bcc].each { |email| final_list[:"#{company_name}"][:bcc] << email }
            end
            
            if email_hash[:cc] != []
              email_hash[:cc].each do |email| 
                if !(final_list[:"#{company_name}"][:bcc].include?(email))
                  final_list[:"#{company_name}"][:cc] << email
                end
              end
            end
          end
        end
      end
    end

    # Now we remove duplicates
    final_list.each do |company_name, email_hash|
      email_hash[:cc].uniq!
      email_hash[:bcc].uniq!
    end

    export_string = "Company,To and Cc,BCc\n"

    # Now we combine each item in final_list to a single string
    # so that it can be written to a csv
    final_list.each do |company_name, email_hash|
      cc_string = "#{email_hash[:cc].join("; ")}"

      bcc_string = "#{email_hash[:bcc].join("; ")}"

      string = "#{company_name.to_s},#{cc_string},#{bcc_string}\n"

      export_string << string
    end

    export_string
  end
end
