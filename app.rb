require 'sinatra'
require_relative './helpers/blackjack.rb'
require 'pry-byebug'
require 'json'

helpers BlackJack

enable :sessions

get '/' do
  players = load_players(session["players"]) if session["players"]
  players = BlackJack::Table.new(players).players
  erb :blackjack, locals: { players: players }
  session["players"] = players.map { |player| player.to_json }.to_json
end

post '/blackjack/hit' do
  players = JSON.parse(session["players"])
  table = BlackJack::Table.new(players)
  table.draw_card(players[1])
  session["players"] = players.to_json
  redirect("/")
end

post '/blackjack/stay' do
  players = JSON.parse(session["players"])

end