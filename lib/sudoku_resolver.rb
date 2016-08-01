require_relative "dlx"
require_relative "exact_cover_matrix"

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

      sudoku_matrix(decrypted_solution)
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
  end
end
