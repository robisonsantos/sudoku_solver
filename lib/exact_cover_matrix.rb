## https://en.wikipedia.org/wiki/Exact_cover#Sudoku
## http://www.stolaf.edu/people/hansonr/sudoku/exactcovermatrix.htm

module Sudoku
  class ExactCoverMatrix

    SUDOKU_SIZE = 9
    LINES = SUDOKU_SIZE ** 3 ## All possibilities for all squares
    COLUMNS = SUDOKU_SIZE ** 2 * 4 ## Each constraint

    def initialize
      @row_column = row_colum_constraint
      @row_number = row_number_constraint
      @column_number = column_number_constraint
      @box_number = box_number_constraint
    end

    def column_size
      COLUMNS
    end

    def row_size
      LINES
    end

    ## ExactCoverMatrix is a view for the the whole matrix
    ## To retrieve a position, we need to map the column parameter
    ## to the correct partial matrix.
    def [](row,col)
      case col
        when 0...81
          @row_column[row][col]
        when 81...162
          @row_number[row][col - 81]
        when 162...243
          @column_number[row][col - 162]
        when 243...324
          @box_number[row][col - 243]
        else
          nil
      end
    end

    # Given a row number, return the position and value
    # on the sudoku board
    # Return is zero based for position and the value is a number [1..SUDOKU_SIZE]
    def ExactCoverMatrix.toSudokuPositionAndValue(row)
      [row / (SUDOKU_SIZE * SUDOKU_SIZE), (row / SUDOKU_SIZE) % SUDOKU_SIZE, (row % SUDOKU_SIZE) + 1]
    end

    # Given a tripple (row, column, value) return the corresponding line
    # from the sparse matrix.
    def ExactCoverMatrix.fromSudokuPositionAndValue(row, column, value)
      row * SUDOKU_SIZE ** 2 + column * SUDOKU_SIZE + value - 1
    end

    private def row_colum_constraint
      row_column = []
      (0...LINES).map { |x| x / SUDOKU_SIZE }
                 .each_with_index do |j,i|
                      row_column[i] ||= []
                      row_column[i][j] = 1
                 end
      row_column
    end

    private def row_number_constraint
      row_number = []
      (0...LINES).map { |x| (x % SUDOKU_SIZE) + SUDOKU_SIZE * ( x / SUDOKU_SIZE ** 2) }
                 .each_with_index do |j,i|
                      row_number[i] ||= []
                      row_number[i][j] = 1
                 end
      row_number
    end

    private def column_number_constraint
      column_number = []
      (0...LINES).map { |x| x % SUDOKU_SIZE ** 2 }
                 .each_with_index do |j,i|
                      column_number[i] ||= []
                      column_number[i][j] = 1
                 end
      column_number
    end

    private def box_number_constraint
      box_number = []
      (0...LINES).map { |x| (x % SUDOKU_SIZE) + (SUDOKU_SIZE * ((x / 27) % 3 + (3 * (x / 243)))) }
                 .each_with_index do |j,i|
                      box_number[i] ||= []
                      box_number[i][j] = 1
                 end
      box_number
    end
  end
end
