module BlackJack

  Card = Struct.new(:rank, :suit)

  class Table
    #holds game state: deck, hands

    attr_accessor :cards_on_table

    def initialize(cards_on_table)
      @cards_on_table = cards_on_table
      @deck = create_deck
    end

    def initial_deal
      #players card are showing, deler shows only one

    end

    def draw_card
      #subtracts from deck and adds to hands on table
    end

    def create_deck
      #subtract cards in hands from deck
      cards_on_table = @cards_on_table.values.map { |
        hand| hand}.flatten
      deck = []
      ranks = %w{A 2 3 4 5 6 7 8 9 10 J Q K}
      suits = %w{Spades Hearts Diamonds Clubs}
      suits.each do |suit|
        ranks.size.times do |i|
          card = Card.new( ranks[i], suit, i+1 )
          deck << card unless cards_on_table.include?(card)
        end
      end
    end

  end

  class Player
    def hit
    end
  end


end