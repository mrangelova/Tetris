require 'matrix'

module Tetris
  class Piece
    I = Matrix[
      [0, 1, 0, 0],
      [0, 1, 0, 0],
      [0, 1, 0, 0],
      [0, 1, 0, 0]
    ]

    J = Matrix[
      [0, 1, 0],
      [0, 1, 0],
      [1, 1, 0]
    ]

    L = Matrix[
      [0, 1, 0],
      [0, 1, 0],
      [0, 1, 1]
    ]

    O = Matrix[
      [1, 1],
      [1, 1]
    ]

    S = Matrix[
      [0, 1, 1],
      [1, 1, 0],
      [0, 0, 0]
    ]

    T = Matrix[
      [1, 1, 1],
      [0, 1, 0],
      [0, 0, 0]
    ]

    Z = Matrix[
      [1, 1, 0],
      [0, 1, 1],
      [0, 0, 0]
    ]

    SHAPES = [I, J, L, O, S, T, Z]

    attr_reader :shape

    def initialize
      @shape = random_shape
      @size  = @shape.row_count
    end

    def cells
      occupied_cells_positions = []

      @shape.each_with_index do |cell, row_index, column_index|
          occupied_cells_positions << [row_index, column_index] if cell == 1
      end

      occupied_cells_positions
    end

    def rotate
      identity_horizontally_mirrored_matrix = Matrix.build(@size, @size) do |row, column|
        row + column == @size - 1 ? 1 : 0
      end

      @shape.dup.transpose * identity_horizontally_mirrored_matrix
    end

    def rotate!
      @shape = rotate
    end

    private

    def random_shape
      SHAPES.sample
    end
  end
end