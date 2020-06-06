# Module to check the similarities between 2 excels and display by company.
# Example output
# [
#   {
#     company: [
#       # list of common emails in excels 1 and 2 for this company
#     ]
#   }
# ]

class Check_similarities
  def self.check_similarities(split_data)
    final_list = {}

    first_list_name = split_data[0].keys[0].to_s
    second_list_name = split_data[1].keys[0].to_s

    first_list = split_data[0][split_data[0].keys[0]] # [ { company_name: { cc: [], bcc: [] } } ]
    second_list = split_data[1][split_data[1].keys[0]] # [ { company_name: { cc: [], bcc: [] } } ]

    first_list.each do |company_hash|
      company_hash.each do |company_name, first_email_hash|
        second_list.each do |company_hash_2|
          company_hash_2.each do |company_name_2, second_email_hash|
            if company_name.to_s == company_name_2.to_s
              list_of_similar_emails = []

              total_first_list = (first_email_hash[:cc] + first_email_hash[:bcc]).uniq
              total_second_list = (second_email_hash[:cc] + second_email_hash[:bcc]).uniq

              list_of_similar_emails += total_first_list & total_second_list
    
              final_list[:"#{company_name}"] = list_of_similar_emails.uniq
            end
          end
        end
      end
    end

    second_list.each do |company_hash|
      company_hash.each do |company_name, second_email_hash|
        unless final_list[:"#{company_name}"]
          first_list.each do |company_hash_2|
            company_hash_2.each do |company_name_2, first_email_hash|
              if company_name.to_s == company_name_2.to_s
                list_of_similar_emails = []

                total_first_list = (first_email_hash[:cc] + first_email_hash[:bcc]).uniq
                total_second_list = (second_email_hash[:cc] + second_email_hash[:bcc]).uniq
                
                list_of_similar_emails += total_first_list & total_second_list
      
                final_list[:"#{company_name}"] = list_of_similar_emails.uniq
              end
            end
          end
        end
      end
    end

    export_string = "Company,List of emails in both #{first_list_name} and #{second_list_name}, Number of similar emails\n"

    # Now we combine each item in final_list to a single string
    # so that it can be written to a csv

    final_list.each do |company_name, list_of_similar_emails|
      email_string = list_of_similar_emails.join("; ")

      string = "#{company_name},#{email_string},#{list_of_similar_emails.count}\n"

      export_string << string
    end

    export_string
  end
end
