module Tetris
  class Game
    attr_reader :playfield, :tetromino, :scoring_system, :next_tetromino

    def initialize()
      @playfield = Playfield.new
      @tetromino = Tetromino.new(@playfield)
      @next_tetromino = Tetromino.new(@playfield)
      @scoring_system = ScoringSystem.new
    end

    def update
      if @tetromino.fallen?
        @scoring_system.increase_score @tetromino.size
        @tetromino.cells.each { |cell| @playfield.occupy_cell *cell }
        @tetromino = @next_tetromino
        @next_tetromino = Tetromino.new(@playfield)
      else
        @tetromino.drop
        @scoring_system.increase_number_of_rows_removed(@playfield.remove_complete_rows)
      end
    end

    def over?
      @tetromino.cells.any? { |cell| @playfield.cell_occupied? *cell }
    end
  end
end