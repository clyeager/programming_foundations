HIGH_SCORE = 21
DEALER_HAULT = 17
CARDS = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
DECK = {
  hearts: CARDS.dup, diamonds: CARDS.dup,
  spades: CARDS.dup, clubs: CARDS.dup
}
INITIAL_DEAL = 2
HIT = 1

def prompt(string)
  puts "==> #{string}"
end

def score(card)
  case card
  when :ace   then 11
  when :king  then 10
  when :queen then 10
  when :jack  then 10
  else card
  end
end

def show_hand(player_cards, player_total, dealer_cards)
  prompt "Your hand is: #{player_cards.join('-')} Total: #{player_total}" \
         " Dealer card is: #{dealer_cards[0]}"
end

def initialize_deck
  Marshal.load(Marshal.dump(DECK))
end

def remove_from_deck(deck, suit, card)
  deck[suit].keep_if { |v| v != card }
end

def deal_cards(deck, number_of_cards, cards=[])
  number_of_cards.times do
    suit = deck.keys.sample
    card = deck[suit].sample
    remove_from_deck(deck, suit, card)
    cards << card
  end
  cards
end

def busted?(total)
  total > HIGH_SCORE
end

def cards_total(cards)
  total = 0
  cards.each do |card|
    total += score(card)
  end
  cards.count(:ace).times do
    if total > 21
      total -= 10
    end
  end
  total
end

def dealer_turn(dealer_total)
  return 'hit' if dealer_total < DEALER_HAULT
  'stay'
end

def who_won(player_total, dealer_total)
  if player_total > dealer_total
    'player'
  elsif dealer_total > player_total
    'dealer'
  else
    'tie'
  end
end

# rubocop:disable Metrics/LineLength
def final_results(player_cards, dealer_cards, player_total, dealer_total)
  winner = who_won(player_total, dealer_total)
  case winner
  when 'player'
    prompt "Congratulations player, you won with #{player_cards.join('-')}" \
    " totalling #{player_total}! Dealer cards: #{dealer_cards.join('-')} Total: #{dealer_total}"
  when 'dealer'
    prompt "Sorry player, the dealer won with #{dealer_cards.join('-')}," \
           " totalling #{dealer_total}!"
  when 'tie'
    prompt "It's a tie! Dealer has #{dealer_cards.join('-')}, and player has " \
           "#{player_cards.join('-')}, both totalling #{dealer_total}!"
  end
end
# rubocop:enable Metrics/LineLength

def add_a_win(winner)
  winner + 1
end

def grand_champ(player_wins, dealer_wins)
  if player_wins == 5
    return 'player'
  elsif dealer_wins == 5
    return 'dealer'
  end
  nil
end

def display_champ(champ)
  puts ''
  puts "*** Congratulations! #{champ.capitalize} you are " \
         "the grand champion with 5 wins! ***"
  sleep(2)
end

def play_again?
  answer = nil
  loop do
    prompt "Keep going?"
    answer = gets.chomp.downcase
    break if answer.start_with?('y', 'n')
  end
  answer.downcase.start_with?('y')
end

def space
  puts ''
end

# start
system 'clear'
prompt "Welcome to Twenty-One!"
prompt "First to win 5 games is the grand champion!"
puts '*' * 47

# start with no wins and no champion
player_wins = 0
dealer_wins = 0
champ = nil

loop do
  # reset the wins variables if there is a champion
  if champ
    player_wins = 0
    dealer_wins = 0
    champ = nil
  end
  # initialize a new deck, deal each player two cards, calculate initial total
  new_deck = initialize_deck

  player_cards = deal_cards(new_deck, INITIAL_DEAL)
  player_total = cards_total(player_cards)

  dealer_cards = deal_cards(new_deck, INITIAL_DEAL)
  dealer_total = cards_total(dealer_cards)

  # player_turn
  loop do
    break if busted?(player_total)
    space
    show_hand(player_cards, player_total, dealer_cards)
    space
    prompt "Would you like to hit or stay?"
    answer = gets.chomp.downcase
    break if answer.start_with?('s')
    space
    if answer.start_with?('h')
      sleep(1)
      player_cards = deal_cards(new_deck, HIT, player_cards)
      player_total = cards_total(player_cards)
    else
      prompt 'Please enter a valid option!'
    end
  end

  # handle conditions of player_turn
  if busted?(player_total)
    prompt "Your hand is #{player_cards.join('-')} Total: #{player_total}" \
           " Sorry-Busted!"
    space
    prompt "Dealer's cards were #{dealer_cards.join('-')}!"
    dealer_wins = add_a_win(dealer_wins)
    # check for a champion
    champ = grand_champ(player_wins, dealer_wins)
    display_champ(champ) if champ
    space
    next if play_again?
    break
  else
    space
  end

  # dealer_turn
  loop do
    break if busted?(dealer_total)
    prompt "Dealer's turn: hit or stay?"
    sleep(3)
    space
    dealer_turn = dealer_turn(dealer_total)
    prompt "The dealer has decided to #{dealer_turn}."
    sleep(3)
    break if dealer_turn == 'stay'
    space
    dealer_cards = deal_cards(new_deck, HIT, dealer_cards)
    dealer_total = cards_total(dealer_cards)
  end

  # handle conditions of dealer_turn
  if busted?(dealer_total)
    prompt "Dealer has busted! Dealer cards: #{dealer_cards.join('-')} " \
           "Total: #{dealer_total}; You win!!!"
    player_wins = add_a_win(player_wins)
    # check for champion
    champ = grand_champ(player_wins, dealer_wins)
    display_champ(champ) if champ
    space
    next if play_again?
    break
  else
    space
  end
  # handle condition neither party has busted
  # rubocop:disable Metrics/LineLength
  final_results(player_cards, dealer_cards, player_total, dealer_total)
  player_wins = add_a_win(player_wins) if who_won(player_total, dealer_total) == 'player'
  dealer_wins = add_a_win(dealer_wins) if who_won(player_total, dealer_total) == 'dealer'
  # rubocop:enable Metrics/LineLength
  # check for champion
  champ = grand_champ(player_wins, dealer_wins)
  display_champ(champ) if champ
  space
  next if play_again?
  break
end

space
prompt "Thank you for playing. Goodbye!"
