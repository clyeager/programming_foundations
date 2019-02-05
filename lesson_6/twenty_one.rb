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
  DECK.dup
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
    prompt "Congratulations player, you won with #{player_cards.join('-')} totalling " \
           "#{player_total}! Dealer cards: #{dealer_cards.join('-')} Total: #{dealer_total}"
  when 'dealer'
    prompt "Sorry player, the dealer won with #{dealer_cards.join('-')}" \
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

def play_again?
  prompt "Keep going?"
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

system 'clear'
prompt "Welcome to Twenty-One!"
prompt "First to win 5 games is the grand chamnpion!"
puts ''

player_wins = 0
dealer_wins = 0

loop do
  new_deck = initialize_deck

  player_cards = deal_cards(new_deck, INITIAL_DEAL)
  player_total = cards_total(player_cards)

  dealer_cards = deal_cards(new_deck, INITIAL_DEAL)
  dealer_total = cards_total(dealer_cards)

  loop do
    break if busted?(cards_total(player_cards))
    show_hand(player_cards, player_total, dealer_cards)
    puts ''
    prompt "Would you like to hit or stay?"
    answer = gets.chomp.downcase
    break if answer == 'stay'
    puts ''
    if answer == 'hit'
      sleep(2)
      player_cards = deal_cards(new_deck, HIT, player_cards)
      player_total = cards_total(player_cards)
    end
  end

  loop do
    if busted?(player_total)
      prompt "Your hand is #{player_cards.join('-')} Total: #{player_total}" \
             " Sorry-Busted!"
      puts ''
      prompt "Dealer's cards were #{dealer_cards.join('-')}!"
      dealer_wins = add_a_win(dealer_wins)
      break
    else
      puts ''
    end

    loop do
      prompt "Dealer's turn: hit or stay?"
      sleep(3)
      puts ''
      dealer_turn = dealer_turn(dealer_total)
      prompt "The dealer has decided to #{dealer_turn}."
      puts ''
      sleep(3)
      break if dealer_turn == 'stay'

      dealer_cards = deal_cards(new_deck, HIT, dealer_cards)
      dealer_total = cards_total(dealer_cards)
    end

    if busted?(dealer_total)
      prompt "Dealer has busted! Dealer cards: #{dealer_cards.join('-')} " \
             "Total: #{dealer_total}; You win!!!"
      player_wins = add_a_win(player_wins)
    else
      # rubocop:disable Metrics/LineLength
      final_results(player_cards, dealer_cards, player_total, dealer_total)
      player_wins = add_a_win(player_wins) if who_won(player_total, dealer_total) == 'player'
      dealer_wins = add_a_win(dealer_wins) if who_won(player_total, dealer_total) == 'dealer'
      # rubocop:enable Metrics/LineLength
    end
    break
  end

  puts ''
  champ = grand_champ(player_wins, dealer_wins)
  if champ
    prompt "Congratulations! #{champ.capitalize} you are the grand champion!"
    player_wins = 0
    dealer_wins = 0
    next if play_again?
    break
  end

  next if play_again?
  break
end

puts ''
prompt "Thank you for playing. Goodbye!"
