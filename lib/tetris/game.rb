module Tetris
  class Game
    LEVEL_UPDATE_INTERVAL = {
      0 => 0.9,
      1 => 0.8,
      2 => 0.7,
      3 => 0.6,
      4 => 0.5,
      5 => 0.4,
      6 => 0.3,
      7 => 0.2,
      8 => 0.1,
      9 => 0.05,
    }

    attr_reader :playfield, :tetromino, :scoring_system, :next_tetromino

    def initialize()
      @playfield = Playfield.new
      @tetromino = Tetromino.new(@playfield)
      @next_tetromino = Tetromino.new(@playfield)
      @scoring_system = ScoringSystem.new
      @last_update = Time.now
    end

    def over?
      @tetromino.cells.any? { |cell| @playfield.cell_occupied? *cell }
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

      @last_update = Time.now
    end

    def should_update?
      Time.now - @last_update > LEVEL_UPDATE_INTERVAL[@scoring_system.level]
    end
  end
end