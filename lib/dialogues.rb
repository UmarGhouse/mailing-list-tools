# Module to handle common dialogues

class Dialogue
  def self.select_function(list_of_functions)
    selected_function = ''

    # Give the user options on a loop
    while selected_function == ''
      puts "What would you like to do?"
      list_of_functions.each_with_index do |function, index|
        puts "[#{index}] #{function}"
      end

      puts "[#{list_of_functions.length}] Quit" # Add a quit option
      
      selected_function = gets.chomp.to_i # Get the value

      # Decide what to do based on what the user selected
      if selected_function < list_of_functions.length
        selected_function = list_of_functions[selected_function] # If valid input, choose the actual function
      elsif selected_function == list_of_functions.length
        puts "Quitting..."
        exit-program # If Quitting - well, quit, I guess.
      else
        selected_function = ''
        puts "INVALID INPUT. Type a number from 0 to #{list_of_functions.length}\n\n" # Tell the user to try again
      end
    end
  
    selected_function # Return the selected option from list_of_functions
  end

  def self.select_file_type
    file_type = ''

    while file_type == ''
      puts "Make sure that all the files you wish to manipulate are in the 'data' folder
      Do you want to check CSV (.csv) or Excel (.xlsx) files? [Type 'csv' or 'xlsx' to choose]"
      
      file_type = gets.chomp.downcase

      unless ['csv', 'xlsx'].include?(file_type)
        puts "INVALID INPUT. Please enter either 'csv' or xlsx'\n\n"
        file_type = ''
      end
    end

    file_type
  end
end