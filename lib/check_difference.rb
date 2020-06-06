# Module to check the differences between 2 excels. Example output
# {
#   items_in_excel_1_only: [],
#   items_in_excel_2_only: []
# }

class Check_differences
  def self.check_difference(split_data)
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
              difference = { "#{first_list_name}": [], "#{second_list_name}": [] }

              total_first_list = (first_email_hash[:cc] + first_email_hash[:bcc]).uniq
              total_second_list = (second_email_hash[:cc] + second_email_hash[:bcc]).uniq

              difference[:"#{first_list_name}"] += total_first_list - total_second_list
              difference[:"#{second_list_name}"] += total_second_list - total_first_list

              difference[:"#{first_list_name}"] = difference[:"#{first_list_name}"].uniq
              difference[:"#{second_list_name}"] = difference[:"#{second_list_name}"].uniq
    
              final_list[:"#{company_name}"] = difference
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
                difference = { "#{first_list_name}": [], "#{second_list_name}": [] }

                total_second_list = (second_email_hash[:cc] + second_email_hash[:bcc]).uniq
                total_first_list = (first_email_hash[:cc] + first_email_hash[:bcc]).uniq

                difference[:"#{first_list_name}"] += total_first_list - total_second_list
                difference[:"#{second_list_name}"] += total_second_list - total_first_list

                difference[:"#{first_list_name}"] = difference[:"#{first_list_name}"].uniq
                difference[:"#{second_list_name}"] = difference[:"#{second_list_name}"].uniq
      
                final_list[:"#{company_name}"] = difference
              end
            end
          end
        end
      end
    end

    export_string = "Company,List of emails in #{first_list_name} but not #{second_list_name},List of emails in #{second_list_name} but not #{first_list_name}\n"

    # Now we combine each item in final_list to a single string
    # so that it can be written to a csv
    final_list.each do |company_name, hash_of_differences|
      in_first_only = hash_of_differences[:"#{first_list_name}"].join("; ")
      in_second_only = hash_of_differences[:"#{second_list_name}"].join("; ")

      string = "#{company_name},#{in_first_only},#{in_second_only}\n"

      export_string << string
    end

    export_string
  end
end
