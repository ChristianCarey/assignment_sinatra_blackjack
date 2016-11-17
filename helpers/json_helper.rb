require_relative 'blackjack.rb'
module JSONHelper

  def load_players(players)
    table_hands = []
    players = JSON.parse(players)
    players.each do |player|
      hand = []
      player = JSON.parse(player)
      player.each do |card|
        puts "card is #{card}"
        p hand
        puts "that was a hand"
        hand << BlackJack::Card.new.from_json(card)
      end
      table_hands << BlackJack::Player.new(hand)
    end
    table_hands
  end

  def save_players(players)
    players.map { |player| player.to_json }.to_json
  end
end

