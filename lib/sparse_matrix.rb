module Sudoku
  class Node
    attr_accessor :right, :left, :up, :down
    attr_reader :cheader, :id

    def initialize(cheader, id)
      @id = id
      @cheader = cheader
    end
  end

  class Root
    attr_accessor :right, :left, :size
    attr_reader :id, :cheader

    def initialize
      @id = "Header"
      @cheader = self
      @size = 0
    end
   end

  class Header < Root
    attr_accessor :up, :down, :size
    attr_reader :id, :cheader

    def initialize(id)
      @id = id
      @cheader = self
      @size = 0
    end
  end

  class SparseMatrix
    attr_reader :root

    def initialize(binary_matrix, exclusions=[])
      @matrix_column_size = binary_matrix.column_size
      @matrix_row_size = binary_matrix.row_size
      @root = build_sparse_matrix(binary_matrix, exclusions)
    end

    private
    def build_sparse_matrix(binary_matrix, exclusions)
      root = Root.new

      headers = (0...@matrix_column_size).map {|id| Header.new id }

      link_left_with_root  root, headers
      link_right_with_root root, headers

      matrix = (0...@matrix_row_size).reject {|row| exclusions.member? row }
                            .map do |row|

         (0...@matrix_column_size)
                .select { |col| binary_matrix[row, col] == 1 }
                .map {|col| Node.new(headers[col], row) }

      end
      .reject {|row_elements| row_elements.empty? }
      .each {|row_elements| link_left row_elements }
      .each {|row_elements| link_right row_elements }

      matrix.flatten.group_by { |node| node.cheader }.each_value do |nodes|
        nodes.first.cheader.size = nodes.size
        link_up_with_root nodes.first.cheader, nodes
        link_down_with_root nodes.first.cheader, nodes
      end

      root
    end

    def link_left_with_root(root, elements)
      nodes = (root != nil) ? [root, elements].flatten : elements
     link_left nodes
    end

    def link_right_with_root(root, elements)
      nodes = (root != nil) ? [root, elements].flatten : elements
      link_right nodes
    end

    def link_up_with_root(root, elements)
      nodes = (root != nil) ? [root, elements].flatten : elements
      link_up nodes
    end

    def link_down_with_root(root, elements)
      nodes = (root != nil) ? [root, elements].flatten : elements
      link_down nodes
    end

    def link_left(nodes)
      nodes.rotate.zip(nodes).each {|a,b| a.left = b}
    end

    def link_right(nodes)
      nodes.zip(nodes.rotate).each {|a,b| a.right = b}
    end

    def link_up(nodes)
      nodes.rotate.zip(nodes).each {|a,b| a.up = b}
    end

    def link_down(nodes)
      nodes.zip(nodes.rotate).each {|a,b| a.down = b}
    end
  end
end
