require 'sinatra'
require_relative './helpers/blackjack.rb'
require_relative './helpers/json_helper.rb'
require 'pry-byebug'
require 'json'

helpers BlackJack, JSONHelper

enable :sessions

before do
  game = session["game"]
  @game = BlackJack::Game.new.from_json(game)
end

get '/' do
  erb :bet
end

get '/deal' do
  bet = params[:bet].to_i
  redirect('/') if bet > @game.bankroll
  @game.set_bet(bet)
  session["game"] = @game.to_json
  erb :blackjack
end

post '/blackjack/hit' do
  @game.human_hit
  session["game"] = @game.to_json
  redirect("/blackjack")
end

post '/blackjack/stay' do
  @game.dealer_play
  session["game"] = @game.to_json
  redirect("/game_over")
end

get '/blackjack' do
  redirect("/game_over") if @game.over?
  erb :blackjack
end

get '/replay' do
  session["game"] = nil
  redirect("/")
end

get '/game_over' do
  @game.pay
  erb :game_over
end