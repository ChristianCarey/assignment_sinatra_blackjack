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
  @game.set_bet(params[:bet].to_i)
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
  @game.winner?
  session["game"] = @game.to_json
  redirect("/blackjack")
end

get '/blackjack' do
  redirect("/gameover") if game.over?
  erb :blackjack
end

get '/replay' do
  session["players"] = nil
  redirect("/deal")
end

get '/gameover' do
  erb :gameover
end