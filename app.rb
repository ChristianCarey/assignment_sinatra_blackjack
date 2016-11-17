require 'sinatra'
require_relative './helpers/blackjack.rb'
require_relative './helpers/json_helper.rb'
require 'pry-byebug'
require 'json'

helpers BlackJack, JSONHelper

enable :sessions

before do
  players = load_players(session["players"]) if session["players"]
  @game = BlackJack::Game.new(players)
end

get '/' do
  erb :bet
end

get '/deal' do
  players = @game.players
  session["players"] = save_players(players)
  erb :blackjack, locals: { players: players }
end

post '/blackjack/hit' do
  @game.human_hit
  players = @game.players
  session["players"] = save_players(players)
  redirect("/")
end

post '/blackjack/stay' do
  @game.dealer_play
  players = @game.players
  session["players"] = save_players(players)
  redirect("/")
end

get '/replay' do
  session["players"] = nil
  redirect("/deal")
end