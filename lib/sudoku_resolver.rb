require_relative "dlx.rb"
require_relative "exact_cover_matrix.rb"
require "terminal-table"

module Sudoku
  class Resolver
    def initialize
      binary_matrix = ExactCoverMatrix.new
      @dlx = DLX.new binary_matrix
    end

    ## Hints is a 9x9 matrix populated with numbers from 0-9
    ## Positions with 0 means free positions that need to be filled
    def resolve(hints)
      @dlx.run get_exclusions(hints)
      solution = @dlx.solution

      raise "Solution not found" if solution.empty?

      decrypted_solution = decrypt_solution(solution.first)

      sudoku_matrix = sudoku_matrix(decrypted_solution)
      print_solution sudoku_matrix
    end

    ## Return a list of lines that should
    ## be excluded from the sparse matrix
    ## based on the filled hint filled positions
    private def get_exclusions(hints)
      positions = (0...9).to_a
      positions.product(positions)
               .select {|row,col| hints[row][col] != 0 }
               .map { |row, col| [row, col, hints[row][col]] }
               .flat_map do |row, col, hint|
         (1..9).select {|value| value != hint }
               .map {|value| ExactCoverMatrix.fromSudokuPositionAndValue(row, col, value)}

      end
    end

    def decrypt_solution(solution)
      solution_rows = []
      solution.each do |row|
        node_ref = row
        loop do
          solution_rows << node_ref.id
          node_ref = node_ref.right
          break if node_ref == row
        end
      end

      solution_rows.uniq.map {|sol_row| ExactCoverMatrix.toSudokuPositionAndValue(sol_row)}
    end

    def sudoku_matrix(solution_list)
      sudoku_matrix = []
      solution_list.each {|row, col, value| sudoku_matrix[row] ||= []; sudoku_matrix[row][col] = value }
      sudoku_matrix
    end

    def print_solution(sudoku_matrix)
      sudoku = Terminal::Table.new :rows => sudoku_matrix
      puts sudoku
    end
  end
end

## Main
=begin
hints = [
[0,0,0,2,6,0,7,0,1],
[6,8,0,0,7,0,0,9,0],
[1,9,0,0,0,4,5,0,0],
[8,2,0,1,0,0,0,4,0],
[0,0,4,6,0,2,9,0,0],
[0,5,0,0,0,3,0,2,8],
[0,0,9,3,0,0,0,7,4],
[0,4,0,0,5,0,0,3,6],
[7,0,3,0,1,8,0,0,0]
]
=end
=begin
hints = [
[0,0,0,6,0,0,4,0,0],
[7,0,0,0,0,3,6,0,0],
[0,0,0,0,9,1,0,8,0],
[0,0,0,0,0,0,0,0,0],
[0,5,0,1,8,0,0,0,3],
[0,0,0,3,0,6,0,4,5],
[0,4,0,2,0,0,0,6,0],
[9,0,3,0,0,0,0,0,0],
[0,2,0,0,0,0,1,0,0]
]
=end

hints = [
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

resolver = Sudoku::Resolver.new
resolver.resolve(hints)
