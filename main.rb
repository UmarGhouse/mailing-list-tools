require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

Dir["./lib/*.rb"].each { |file| require file }

list_of_functions = [
  "Combine into a single mailing list"
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
else
  puts "Invalid function"
end

Write_to_csv.write_file(result[0], result[1])
