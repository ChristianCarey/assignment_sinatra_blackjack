module JSONHelper

  def load_players(players)
    players = JSON.parse(players)
    players.each do |player|
      player.each do |card|
        Card.new.from_json(card)
      end
    end
  end
end