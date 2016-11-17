require 'sinatra'
require 'sinatra/reloader'
require_relative './helpers/blackjack.rb'

helpers BlackJack

get '/' do
  table = BlackJack::Table.new.players
  erb :blackjack, locals: { table: table }
end