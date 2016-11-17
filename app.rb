require 'sinatra'
require_relative './helpers/blackjack.rb'
require 'pry-byebug'

helpers BlackJack

enable :sessions

get '/' do
  players = BlackJack::Table.new.players
  erb :blackjack, locals: { players: players }
  session["players"] = players.to_JSON
end

post '/blackjack/hit' do
  players = JSON.parse(sessions["players"])
  table = BlackJack::Table.new(players)
  table.draw_card(players[1])
  redirect("/", local{players: players})
end

post '/blackjack/stay' do
  players = JSON.parse(sessions["players"])

end