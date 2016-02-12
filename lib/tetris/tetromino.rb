module Tetris
  class Tetromino
    class Rotation
      def initialize(tetromino)
        @tetromino = tetromino
      end

      def rotate
        @tetromino.piece.rotate! if rotation_allowed?
      end

      def rotation_allowed?
        in_bounds_after_rotation? and not collision_after_rotation?
      end

      def collision_after_rotation?
        cells_after_rotation.any? do |position|
          @tetromino.playfield.cell_occupied? *position
        end
      end

      def in_bounds_after_rotation?
        cells_after_rotation.all? do |position|
          position[0].between?(0, @tetromino.playfield.number_of_rows - 1) and
          position[1].between?(0, @tetromino.playfield.number_of_columns - 1)
        end
      end

      def cells_after_rotation
        occupied_cells_positions = []

        @tetromino.piece.rotate.each_with_index do |cell, row_index, column_index|
          occupied_cells_positions << [row_index, column_index] if cell == 1
        end

        occupied_cells_positions.map! do |cell|
          [cell[0] + @tetromino.top_left_position[0], cell[1] + @tetromino.top_left_position[1]]
        end

        occupied_cells_positions
      end
    end

    class Movement
      def initialize(tetromino)
        @tetromino = tetromino
      end

      def move_right
        move(0, 1)
      end

      def move_left
        move(0, -1)
      end

      def drop
        move(1, 0)
      end

      def drop_allowed?
        movement_allowed?(1, 0)
      end

      private

      def move(number_of_rows, number_of_columns)
        if movement_allowed?(number_of_rows, number_of_columns)
          @tetromino.top_left_position[0] += number_of_rows
          @tetromino.top_left_position[1] += number_of_columns
        end
      end

      def movement_allowed?(number_of_rows, number_of_columns)
        in_bounds_after_movement?(number_of_rows, number_of_columns) and
          not collision_after_movement?(number_of_rows, number_of_columns)
      end

      def collision_after_movement?(number_of_rows, number_of_columns)
        cells_after_movement(number_of_rows, number_of_columns).any? do |position|
          @tetromino.playfield.cell_occupied? *position
        end
      end

      def in_bounds_after_movement?(number_of_rows, number_of_columns)
        cells_after_movement(number_of_rows, number_of_columns).all? do |position|
          position[0].between?(0, @tetromino.playfield.number_of_rows - 1) and
          position[1].between?(0, @tetromino.playfield.number_of_columns - 1)
        end
      end

      def cells_after_movement(number_of_rows, number_of_columns)
        @tetromino.cells.map do |position|
          [position[0] + number_of_rows, position[1] + number_of_columns]
        end
      end
    end

    INITIAL_TOP_LEFT_POSITION = [0, 4]

    attr_reader :playfield, :piece, :top_left_position

    def initialize(playfield, piece = nil)
      @playfield = playfield
      @top_left_position = INITIAL_TOP_LEFT_POSITION.dup
      @piece = piece || Piece.new
    end

    def move_right
      Movement.new(self).move_right
    end

    def move_left
      Movement.new(self).move_left
    end

    def drop
      Movement.new(self).drop
    end

    def rotate
      Rotation.new(self).rotate
    end

    def fallen?
      not Movement.new(self).drop_allowed?
    end

    def drop_to_bottom
      drop until fallen?
    end

    def cells
      @piece.cells.map do |cell|
        [cell[0] + @top_left_position[0], cell[1] + @top_left_position[1]]
      end
    end

    def size
      cells.size
    end
  end
end