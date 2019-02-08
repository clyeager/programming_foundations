# ask the user for two numbers
# ask the user for an operation to perform
# perform the operation on the two numbers
# output the results
require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')

def prompt(message)
  puts "=> #{message}"
end

def valid_number?(number)
  number.to_i.to_s == number || number.to_f.is_a?(Float)
end

def operation_to_message(operation)
choice = case operation
         when '1'
           'Adding'
         when '2'
           'Subtracting'
         when '3'
           'Multiplying'
         when '4'
           'Dividing'
         end
choice
end

prompt(MESSAGES['welcome'])

name = ''
loop do
  name = gets.chomp

  if name.empty?
    prompt(MESSAGES['valid_name'])
  else
    break
  end
end

prompt("Hi #{name}!")

loop do
  number_one = ''

  loop do
    prompt(MESSAGES['number_one'])
    number_one = gets.chomp

    if valid_number?(number_one)
      break
    else
      prompt(MESSAGES['number_error'])
    end
  end

  number_two = ''
  loop do
    prompt(MESSAGES['number_two'])
    number_two = gets.chomp

    if valid_number?(number_two)
      break
    else
      prompt(MESSAGES['number_error'])
    end
  end

  operator_prompt = <<-MSG
    Which operation would you like to perform?
    1)add
    2)subtract
    3)multiply
    4)divide
    MSG

  prompt(operator_prompt)

  operation = ''

  loop do
    operation = gets.chomp

    if %w(1 2 3 4).include?(operation)
      break
    else
      prompt(MESSAGES['operation'])
    end
  end

  prompt("#{operation_to_message(operation)}")

  result = case operation
           when '1'
             number_one.to_f + number_two.to_f
           when '2'
             number_one.to_f - number_two.to_f
           when '3'
             number_one.to_f * number_two.to_f
           when '4'
             number_one.to_f / number_two.to_f
           end

  prompt("Your result is #{result}!")

  prompt(MESSAGES['calculate_again'])
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt(MESSAGES['exit']) 
