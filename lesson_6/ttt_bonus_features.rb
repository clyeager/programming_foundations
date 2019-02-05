STARTING_PLAYER = ['player', 'computer', 'choose']
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                [[1, 5, 9], [3, 5, 7]]

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'

def prompt(msg)
  puts "=> #{msg}"
end

def display_board(brd)
  system 'clear'
  puts "You're an #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(array, delimiter=', ', joining_word='or')
  case array.size
  when 0 then ''
  when 1 then array[0]
  when 2 then array[0].to_s + ' ' + joining_word + ' ' + array[1].to_s
  else array[-1] = "#{joining_word} #{array.last}"
       array.join(delimiter)
  end
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square: #{joinor(empty_squares(brd))}"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end

  brd[square] = PLAYER_MARKER
end

def computer_places_piece!(brd)
  square = empty_squares(brd).sample
  offense = detect_offensive_move(brd)
  threat = detect_threat_square(brd)

  if threat.empty? && offense.empty?
    if brd[5] == INITIAL_MARKER
      brd[5] = COMPUTER_MARKER
    else
      brd[square] = COMPUTER_MARKER
    end
  elsif offense.empty?
    brd[threat[0]] = COMPUTER_MARKER
  else
    brd[offense[0]] = COMPUTER_MARKER
  end
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(line[0], line[1], line[2]).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(line[0], line[1], line[2]).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def detect_threat_square(brd)
  threat_line = []
  WINNING_LINES.each do |line|
    if brd.values_at(line[0], line[1], line[2]).count(PLAYER_MARKER) == 2 && brd.values_at(line[0], line[1], line[2]).count(INITIAL_MARKER) == 1
      threat_line << line
    end
  end
  threat_square = threat_line.flatten.select do |n|
    brd[n] != PLAYER_MARKER
  end
  threat_square
end

def detect_offensive_move(brd)
  offensive_line = []
  WINNING_LINES.each do |line|
    if brd.values_at(line[0], line[1], line[2]).count(COMPUTER_MARKER) == 2 && brd.values_at(line[0], line[1], line[2]).count(INITIAL_MARKER) == 1
      offensive_line << line
    end
  end
  offensive_move = offensive_line.flatten.select do |n|
    brd[n] != COMPUTER_MARKER
  end
  offensive_move
end

def who_starts
  start = STARTING_PLAYER.sample
  return 'player' if start == 'player'
  return 'computer' if start == 'computer'
  prompt "Please choose who will go first('player' or 'computer'):"
end

def place_piece!(brd, current_player)
  player_places_piece!(brd) if current_player == 'player'
  computer_places_piece!(brd) if current_player == 'computer'
end

def alternate_player(current_player)
  return 'computer' if current_player == 'player'
  return 'player' if current_player == 'computer'
end

total_player_score = 0
total_computer_score = 0
starting_choice = ''

prompt 'Welcome to Tic Tac Toe!'
prompt 'The first player to win 5 games is the Grand Champion, ' \
       'however you may quit after any round.'

loop do
  starting_choice = who_starts
  break if starting_choice == 'player' || starting_choice == 'computer'
  loop do
    starting_choice = gets.chomp.downcase
    break if starting_choice == 'player' || starting_choice == 'computer'
    prompt 'Please make a valid choice!'
  end
  break
end

loop do
  prompt "#{starting_choice.capitalize} will go first"
  prompt "Please press 'enter' to begin"
  break if gets.chomp.empty?
end

current_player = starting_choice

loop do
  board = initialize_board

  loop do
    display_board(board)

    place_piece!(board, current_player)

    break if someone_won?(board) || board_full?(board)

    current_player = alternate_player(current_player)
  end

  display_board(board)

  if someone_won?(board)
    round_winner = detect_winner(board)
    prompt "#{round_winner} won!"
  else
    prompt "It's a tie!"
  end

  total_player_score += 1 if round_winner == 'Player'
  total_computer_score += 1 if round_winner == 'Computer'

  if total_player_score == 5
    system 'clear'
    prompt "Congratulations Player, you are the Grand Champion by winning 5 games!"
    total_player_score = 0
  elsif total_computer_score == 5
    system 'clear'
    prompt "Sorry Player, the computer has won 5 games!"
    total_computer_score = 0
  end

  prompt "Keep playing? (y or n)"
  answer = gets.chomp
  break if answer.downcase.start_with?('n')
end

prompt "Thanks for playing Tic Tac Toe! Goodbye"
