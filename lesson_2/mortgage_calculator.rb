require 'yaml'
MESSAGES = YAML.load_file('mortgage_messages.yml')

def prompt(message)
  puts "=> #{message}"
end

def valid_number(number)
  (number.to_i.to_s == number && number.to_i > 0) || (number.to_f.to_s == number && number.to_f > 0)
end

prompt(MESSAGES['welcome'])

loop do
  loan = ''
  loop do
    prompt(MESSAGES['loan'])
    loan = gets.chomp
    if valid_number(loan)
      loan = loan.to_i
      break
    else
      prompt(MESSAGES['loan_warning'])
    end
  end

  monthly_rate = ''
  loop do
    prompt(MESSAGES['apr'])
    apr = gets.chomp
    if valid_number(apr)
      monthly_rate = apr.to_f / 12 / 100
      break
    else
      prompt(MESSAGES['apr_warning'])
    end
  end

  duration = ''
  loop do
    prompt(MESSAGES['duration'])
    duration = gets.chomp
    if valid_number(duration)
      prompt(MESSAGES['duration_term'])
      answer = gets.chomp
      if answer.downcase == 'months'
        duration = duration.to_f
        break
      elsif answer.downcase == 'years'
        duration = duration.to_f * 12
        break
      end
    else
      prompt(MESSAGES['duration_warning'])
    end
  end

  result = loan * (monthly_rate / (1 - (1 + monthly_rate)**-duration))
  prompt "Your monthly payment will be $#{result.ceil}."
  prompt(MESSAGES['again'])

  answer = gets.chomp
  break if answer.downcase.start_with?('n')
end

prompt(MESSAGES['exit'])
