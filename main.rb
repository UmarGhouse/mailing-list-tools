['rubygems', 'bundler/setup'].each { |config| require config }
Bundler.require(:default)

Dir["./lib/*.rb"].each { |file| require file } # Require all the modules in the lib folder

# List of all the functions this tool is capable of
list_of_functions = [
  "Combine into a single mailing list",
  "Combine into a single column",
  "Check similarities between 2 mailing lists",
  "Check differences between 2 mailing lists"
]

split_data = Split.split # Split the data

selected_function = Dialogue.select_function(list_of_functions) # Ask user what function they want to use

# Store the result of the module
result = []

# Case statement to run the relevant module
case selected_function
when "Combine into a single mailing list"
  result = ['combined_mailing_list', Combine_to_mailing_list.combine(split_data)]
when "Combine into a single column"
  result = ['combined_to_column', Combine_to_single_column.combine(split_data)]
when "Check similarities between 2 mailing lists"
  result = ['emails_in_both_lists', Check_similarities.check_similarities(split_data)]
when "Check differences between 2 mailing lists"
  result = ['difference_between_lists', Check_differences.check_difference(split_data)]
else
  puts "INVALID FUNCTION"
end

# Write the output to a CSV file
Write_to_csv.write_file(result[0], result[1])
