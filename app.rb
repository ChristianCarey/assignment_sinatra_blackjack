require 'sinatra'
require_relative './helpers/blackjack.rb'
require_relative './helpers/json_helper.rb'
require 'pry-byebug'
require 'json'

helpers BlackJack, JSONHelper

enable :sessions

get '/' do
  players = load_players(session["players"]) if session["players"]
  players = BlackJack::Table.new(players).players
  session["players"] = save_players(players)
  erb :blackjack, locals: { players: players }
end

post '/blackjack/hit' do
  players = load_players(session["players"])
  table = BlackJack::Table.new(players)
  table.draw_card(players[1])
  players = table.players
  session["players"] = save_players(players)
  redirect("/")
end

post '/blackjack/stay' do
  players = load_players(session["players"])
  table = BlackJack::Table.new(players)
  players[0].table = table
  players[0].play
  players = table.players
  session["players"] = save_players(players)
  redirect("/")
end