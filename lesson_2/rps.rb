VALID_CHOICES = %w(rock paper scissors)

def prompt(message)
  puts "=>#{message}"
end

def player_win?(player, computer)
  (player == 'rock' && computer == 'scissors') ||
  (player == 'paper' && computer == 'rock') ||
  (player == 'scissors' && computer == 'paper')
end

def computer_win?(computer, player)
  (player == 'rock' && computer == 'paper') ||
  (player == 'paper' && computer == 'scissors') ||
  (player == 'scissors' && computer == 'rock')
end

def display_results(player, computer)
  if player_win?(player, computer)
    prompt('You won!')
  elsif computer_win?(computer, player)
    prompt('Computer won!')
  else
    prompt("It's a tie!")
  end
end

loop do

choice = ''

loop do
  prompt("Choose one: #{VALID_CHOICES.join(', ')}")
  choice = gets.chomp

  break if VALID_CHOICES.include?(choice.downcase)

    puts "That is not a valid choice!"

end

computer_choice = VALID_CHOICES.sample

prompt("You chose: #{choice}; Computer chose: #{computer_choice}")

display_results(choice, computer_choice)

prompt('Would you like to play again?')
answer = gets.chomp

break unless answer.downcase.start_with?('y')
end

prompt("Thank you for playing. Goodbye!")