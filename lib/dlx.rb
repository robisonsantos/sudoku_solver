## https://en.wikipedia.org/wiki/Exact_cover#Sudoku
## http://www.stolaf.edu/people/hansonr/sudoku/exactcovermatrix.htm
require_relative 'sparse_matrix.rb'

module Sudoku
  class DLX
    attr_reader :solution

    def initialize(binary_matrix)
      @binary_matrix = binary_matrix
      @solution = []
    end

    def run(exclusions)
      @root = SparseMatrix.new(@binary_matrix, exclusions).root
      search(0, [], @solution)
    end

    private
    def search(k, solution, acc)
      if @root.right == @root
          acc << solution.dup
          return
      end

      col = choose_col

      cover_column col

      row_ref = col
      # walk on the column row by row
      while (row_ref = row_ref.down) != col
        solution.push row_ref

        node_ref = row_ref
        # Walk on the row node by node
        while (node_ref = node_ref.right) != row_ref
          cover_column node_ref.cheader
        end

        search(k+1, solution, acc)
        solution.pop

        while (node_ref = node_ref.left) != row_ref
          uncover_column node_ref.cheader
        end

      end
      uncover_column col
    end

    # Pick the column with smaller size, i.e. the smaller number of ones
    def choose_col
      ##@root.right
      min_size = 999999999999999
      chosen_col = @root.left
      column_ref = @root
      while (column_ref = column_ref.right) != @root
        if column_ref.size < min_size
          chosen_col = column_ref
          min_size = column_ref.size
        end
      end
      chosen_col
    end

    def cover_column(column)
      column.right.left = column.left
      column.left.right = column.right

      row_ref = column
      while (row_ref = row_ref.down) != column
        node_ref = row_ref
        while (node_ref = node_ref.right) != row_ref
          node_ref.down.up = node_ref.up
          node_ref.up.down = node_ref.down
          node_ref.cheader.size -= 1
        end
      end
    end

    def uncover_column(column)
      row_ref = column
      while (row_ref = row_ref.up) != column
        node_ref = row_ref
        while (node_ref = node_ref.left) != row_ref
          node_ref.cheader.size += 1
          node_ref.down.up = node_ref
          node_ref.up.down = node_ref
        end
      end
      column.left.right = column
      column.right.left = column
    end

  end
end
