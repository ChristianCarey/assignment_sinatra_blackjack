module BlackJack
# require 'pry-byebug'

  Card = Struct.new(:rank, :suit)

  class Table
    #holds game state: deck, hands

    attr_accessor :players

    def initialize(players = nil)
      @players = players || [Dealer.new, HumanPlayer.new]
      @deck = create_deck
      initial_deal if @players[0].hand.empty?
    end

    def initial_deal
      #players card are showing, deler shows only one
      draw_card(@players[0])
      draw_card(@players[0])
      draw_card(@players[1])
      draw_card(@players[1])
    end

    def draw_card(player)
      #subtracts from deck and adds to hands on table
      # binding.pry
      card = @deck.shuffle.pop
      player.hand << card
    end

    def create_deck
      #subtract cards in hands from deck
      deck = []
      ranks = %w{A 2 3 4 5 6 7 8 9 10 J Q K}
      suits = %w{Spades Hearts Diamonds Clubs}
      suits.each do |suit|
        ranks.size.times do |i|
          card = Card.new( ranks[i], suit)
          deck << card unless cards_on_table.include?(card)
          i += 1
        end
      end
      @deck = deck
    end

    def cards_on_table
      cards = []
      @players.each do |player|
        cards << player.hand
      end
      cards.flatten
    end
  end

  class Player
    attr_accessor :hand
    def initialize(hand = [])
      @hand = hand
    end

    def hit
      
    end

  end

  class HumanPlayer < Player
  end

  class Dealer < Player
  end

end