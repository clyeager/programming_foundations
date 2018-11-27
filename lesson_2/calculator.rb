# ask the user for two numbers
# ask the user for an operation to perform
# perform the operation on the two numbers
# output the results

def prompt(message)
  puts "=> #{message}"
end

def valid_number?(number)
  number.to_i != 0
end

def operation_to_message(operation)
  case operation
  when '1'
    'Adding'
  when '2'
    'Subtracting'
  when '3'
    'Multiplying'
  when '4'
    'Dividing'
  end
end

prompt("Welcome to the calculator! Enter your name:")

name = ''
loop do
  name = gets.chomp

  if name.empty?
    prompt("Enter a valid name!")
  else
    break
  end
end

prompt("Hi #{name}!")

loop do # main loop
  number_one = ''

  loop do
    prompt("Please enter the first number:")
    number_one = gets.chomp

    if valid_number?(number_one)
      break
    else
      prompt("Hmm...that doesn't look right!")
    end
  end

  number_two = ''
  loop do
    prompt("Please enter the second number:")
    number_two = gets.chomp

    if valid_number?(number_two)
      break
    else
      prompt("Hmm...that doesn't look right!")
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
      prompt("Must choose 1, 2, 3, or 4")
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

  prompt("Do you want another calculation?(Y to calculate again)")
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt("Thank you for using the calculator!")
