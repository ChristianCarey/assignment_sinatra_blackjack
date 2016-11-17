module BlackJack
# require 'pry-byebug'

  Card = Struct.new(:rank, :suit) do 

    def to_json
      [rank, suit].to_json
    end

    def from_json(json)
      rank, suit = JSON.parse(json)
      Card.new(rank, suit)
    end
  end

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
      ranks = ["A", 2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K"]
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
    attr_accessor :hand, :table
      def initialize(hand = [])
      @hand = hand
    end

    def to_json
      @hand.map do |card|
        card.to_json
      end.to_json
    end

    def total
      total = 0
      total = @hand.inject(0) do |total, card|
        rank = 0
        if card.rank == "A"
          rank = 11
        elsif ["J", "Q", "K"].include?(card.rank)
          rank = 10
        else
          rank = card.rank
        end            
        total += rank
      end

      total = calculate_aces(total)
    end

    def calculate_aces(total, aces = ace_count)
      return total if aces == 0
      return total if total <= 21
      calculate_aces(total - 10, aces - 1)
    end

    def ace_count
      count = 0
      @hand.each do |card|
        count +=1 if card.rank == "A"
      end
      count
    end

    def play
      @table.draw_card(self) until total >= 17
    end
  end

  class HumanPlayer < Player
  end

  class Dealer < Player
    
  end

end


