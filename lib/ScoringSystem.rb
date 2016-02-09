class ScoringSystem
  ROWS_CLEARED_MULTIPLIERS = {0 => 0, 1 => 40, 2 => 100, 3 => 300, 4 => 1200}
  LINES_PER_LEVEL = 10

  attr_reader :score, :level

  def initialize
    @score     = 0
    @level     = 0
    @number_of_rows_removed = 0
  end

  def increase_score(points)
    @score += points
  end

  def increase_number_of_rows_removed(number_of_rows)
    @number_of_rows_removed += number_of_rows

    increase_score(ROWS_CLEARED_MULTIPLIERS[number_of_rows] * (@level + 1))
    update_level
  end

  private

  def update_level
    @level = @number_of_rows_removed / LINES_PER_LEVEL
  end
end