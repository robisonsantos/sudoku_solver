# This is the main controller for sudoku solver app

require 'sinatra'

get '/' do
  erb :index
end

post '/solution' do
  "This is a solution!"
end
