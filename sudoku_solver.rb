# This is the main controller for sudoku solver app

require 'sinatra'
require_relative 'lib/sudoku_resolver'

get '/' do
  @sample =
  [
    [0,2,0,0,0,0,0,0,0],
    [0,0,0,6,0,0,0,0,3],
    [0,7,4,0,8,0,0,0,0],
    [0,0,0,0,0,3,0,0,2],
    [0,8,0,0,4,0,0,1,0],
    [6,0,0,5,0,0,0,0,0],
    [0,0,0,0,1,0,7,8,0],
    [5,0,0,0,0,9,0,0,0],
    [0,0,0,0,0,0,0,4,0]
  ]

  erb :index
end

post '/solution' do
  @solution =
  [
    [1,2,6,4,3,7,9,5,8],
    [8,9,5,6,2,1,4,7,3],
    [3,7,4,9,8,5,1,2,6],
    [4,5,7,1,9,3,8,6,2],
    [9,8,3,2,4,6,5,1,7],
    [6,1,2,5,7,8,3,9,4],
    [2,6,9,3,1,4,7,8,5],
    [5,4,8,7,6,9,2,3,1],
    [7,3,1,8,5,2,6,4,9]
  ]

  #resolver = Sudoku::Resolver.new
  #resolver.resolve(hints)

  erb :solution
end
