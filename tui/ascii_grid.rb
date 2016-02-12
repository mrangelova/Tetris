require_relative '../lib/tetris'

module Tetris
  module TUI
    class AsciiGrid
      TOP_BOARDER = '╔══════════╗'
      BOTTOM_BOARDER = '╚══════════╝'

      def initialize(game)
        @game = game
        @grid = empty_grid
      end

      def render
        update_grid

        @grid.map { |row| row.join.insert(0, '║').insert(-1, '║') }
          .join("\n")
          .insert(0, "\n")
          .insert(0, TOP_BOARDER)
          .insert(-1, "\n")
          .insert(-1, BOTTOM_BOARDER)
      end

      private

      def update_grid
        @grid.map!.with_index do |row, row_index|
          row.map!.with_index do |_, column_index|
            symbol_for_cell(row_index, column_index)
          end
        end
      end

      def empty_grid
        Array.new(@game.playfield.number_of_rows) do
          Array.new(@game.playfield.number_of_columns) {}
        end
      end

      def live_cell?(row_index, column_index)
        @game.tetromino.cells.include? [row_index, column_index]
      end

      def empty_cell?(row_index, column_index)
        @game.playfield.cell_empty? row_index, column_index
      end

      def occupied_cell?(row_index, column_index)
        @game.playfield.cell_occupied? row_index, column_index
      end

      def symbol_for_cell(row_index, column_index)
        return 'O' if live_cell? row_index, column_index
        return ' ' if empty_cell? row_index, column_index
        return 'X' if occupied_cell? row_index, column_index
      end
    end
  end
end