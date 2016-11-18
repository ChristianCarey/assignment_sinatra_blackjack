require_relative 'json_helper.rb'
module BlackJack
# require 'pry-byebug'

  class Game

    attr_accessor :players, :table

    def initialize(args = {})
      @dealer = args.fetch("dealer", Dealer.new)
      @human = args.fetch("human", Human.new)
      @human.bet = args.fetch("bet", 0)
      @human.bankroll = args.fetch("bankroll", 1000)
      @table = Table.new(@dealer, @human)
    end

    def dealer
      @table.dealer
    end

    def human
      @table.human
    end

    def human_hit
      @table.draw_card(human)
      dealer_play if human.total >= 21 
    end

    def dealer_play
      @table.draw_card(dealer) until dealer.total >= 17
    end

    def over?
      human.bust? || dealer.total >= 17 || dealer.blackjack?
    end

    def pay
      human.bankroll += human.bet * 2 if win?
    end

    def win?
      (human.total > dealer.total && !human.bust?) || dealer.bust?
    end

    def loss?
      dealer.blackjack? || dealer.total > human.total || human.bust?
    end


    def to_json
      {
        "dealer" => dealer.hand.map { |card| card.to_json },
        "human" => human.hand.map { |card| card.to_json },
        "bet" => human.bet,
        "bankroll" => human.bankroll
      }.to_json
    end

    def from_json(json)
      return Game.new if json.nil?
      game_state = JSON.parse(json)
      dealer_hand = game_state["dealer"].map { |card| Card.new.from_json(card) }
      human_hand = game_state["human"].map { |card| Card.new.from_json(card) }
      game_state["dealer"] = Dealer.new(dealer_hand)
      game_state["human"] = Human.new(human_hand)
      Game.new(game_state)
    end

    def set_bet(bet)
      human.bet = bet
      human.bankroll -= bet
    end

    def bankroll
      human.bankroll
    end
  end


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

    attr_accessor :dealer, :human

    def initialize(dealer, human)
      @dealer = dealer
      @human = human 
      @deck = create_deck
      initial_deal if @dealer.hand.empty?
    end

    def initial_deal
      #players card are showing, deler shows only one
      draw_card(@dealer)
      draw_card(@dealer)
      draw_card(@human)
      draw_card(@human)
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
      [ @dealer.hand, @human.hand ].flatten
    end
  end

  class Player
    attr_accessor :hand, :bet, :bankroll
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
          rank = card.rank.to_i
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

    def bust?
      total > 21
    end

    def blackjack?
      @hand.length == 2 && ace_count == 1 && total == 21
    end
  end

  class Human < Player
  end

  class Dealer < Player
    
  end

end


