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
  hints = params[:hints].values.map {|row| row.map(&:to_i)}

  resolver = Sudoku::Resolver.new

  begin
    @solution = resolver.resolve(hints)
    @solution = @solution.zip(hints).map {|solution, hint| solution.zip(hint)}
    erb :solution
  rescue
    status 404
    body "No solution found"
  end

end
