require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

Dir["./lib/*.rb"].each { |file| require file }

list_of_functions = [
  "Combine into a single mailing list",
  "Combine into a single column",
  "Check similarities between 2 mailing lists",
  "Check differences between 2 mailing lists"
]

split_data = Split.split

def select_function(list_of_functions)
  puts "What would you like to do?"
  list_of_functions.each_with_index do |function, index|
    puts "[#{index}] #{function}"
  end
  
  selected_function = gets.chomp.to_i
end

selected_function = ''

while selected_function == ''
  selected_function = select_function(list_of_functions)

  if selected_function < list_of_functions.length
    selected_function = list_of_functions[selected_function]
  else
    selected_function = ''
  end
end

result = ''

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
  puts "Invalid function"
end

# puts result[1]
Write_to_csv.write_file(result[0], result[1])
