VALID_CHOICES = %w(rock paper scissors spock lizard)
WHICH_CHOICE = { r: 'rock',
                 p: 'paper',
                 s: 'scissors',
                 sp: 'spock',
                 l: 'lizard' }

def prompt(message)
  puts "=>#{message}"
end

winning_moves = { scissors: ['paper', 'lizard'],
                  paper: ['rock', 'spock'],
                  rock: ['lizard', 'scissors'],
                  lizard: ['spock', 'paper'],
                  spock: ['scissors', 'rock'] }

def add_to_computer_score?(hash, computer, player)
  hash[computer.to_sym].include?(player)
end

def grand_winner?(score)
  score == 5
end

prompt("Welcome to Rock, Paper, Scissors: Spock/Lizard Edition!")
prompt("The first player to win 5 games is the grand winner!")

loop do
  choice = ''
  player_score = 0
  computer_score = 0

  loop do
    loop do
      prompt("Choose a move (you may abbreviate ex. 's' for scissors, 'sp' for spock):" \
             "#{VALID_CHOICES.join(', ')}")
      choice = gets.chomp
      if WHICH_CHOICE.values.include?(choice)
        break
      else
        choice = choice.to_sym
        choice = WHICH_CHOICE[choice]
      end
      break if VALID_CHOICES.include?(choice)
      puts "That is not a valid choice!"
    end

    computer_choice = VALID_CHOICES.sample

    prompt("You chose: #{choice}; Computer chose: #{computer_choice}")

    if computer_choice == choice
      computer_score += 1
      player_score += 1
      puts "It's a tie! The score is now: Computer #{computer_score} to Player #{player_score}"
    elsif add_to_computer_score?(winning_moves, computer_choice, choice) == true
      computer_score += 1
      puts "Sorry! You did not win this round, the overall score is now:" \
      " Computer: #{computer_score} to Player: #{player_score}!"
    else
      player_score += 1
      puts "Awesome, you won this round! The score is now: Computer:" \
      " #{computer_score} to Player: #{player_score}!"
    end

    if grand_winner?(player_score)
      puts "Congratulations, you are the grand winner!"
      break
    elsif grand_winner?(computer_score)
      puts "Sorry, the computer is the grand winner!"
      break
    end
  end

  prompt('Would you like to play again?')
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt("Thank you for playing. Goodbye")
