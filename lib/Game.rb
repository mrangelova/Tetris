class Game
  ROWS_CLEARED_MULTIPLIERS = {0 => 0, 1 => 40, 2 => 100, 3 => 300, 4 => 1200}
  LINES_PER_LEVEL = 10

  attr_reader :playfield, :tetromino, :score, :level

  def initialize()
    @playfield = Playfield.new
    @tetromino = Tetromino.new(@playfield)
    @score = 0
    @level = 0
    @number_of_rows_removed = 0
  end

  def update
    if @tetromino.fallen?
      @score += @tetromino.size
      @tetromino.cells.each { |cell| @playfield.occupy_cell *cell }
      @tetromino = Tetromino.new(@playfield)
    else
      @tetromino.drop
      number_of_rows_removed = @playfield.remove_complete_rows
      @score += ROWS_CLEARED_MULTIPLIERS[number_of_rows] * (@level + 1)
      @number_of_rows_removed += number_of_rows_removed
      @level = @number_of_rows_removed / LINES_PER_LEVEL
    end
  end

  def over?
    @tetromino.cells.any? { |cell| @playfield.cell_occupied? *cell }
  end
end