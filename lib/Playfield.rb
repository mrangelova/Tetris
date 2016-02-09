class Playfield
  class Cell
    def initialize
      @status = :empty
    end

    def empty
      @status = :empty
    end

    def occupy
      @status = :occupied
    end

    def empty?
      @status == :empty
    end

    def occupied?
      not empty?
    end
  end

  DEFAULT_NUMBER_OF_ROWS = 20
  DEFAULT_NUMBER_OF_COLUMNS = 10

  attr_reader :number_of_rows, :number_of_columns, :cells

  def initialize(number_of_rows = nil, number_of_columns = nil)
    @number_of_rows = number_of_rows || DEFAULT_NUMBER_OF_ROWS
    @number_of_columns = number_of_columns || DEFAULT_NUMBER_OF_COLUMNS

    @cells = Array.new(@number_of_rows) { Array.new(@number_of_columns) { Cell.new } }
  end

  def occupy_cell(row, column)
    @cells[row][column].occupy
  end

  def cell_empty?(row, column)
    @cells[row][column].empty?
  end

  def cell_occupied?(row, column)
    @cells[row][column].occupied?
  end

  def occupied_cells
    occupied_cells = []

    each_cell_with_index { |cell, row, column| occupied_cells << [row, column] if cell.occupied? }

    occupied_cells
  end

  def empty_cells
    empty_cells = []

    each_cell_with_index { |cell, row, column| empty_cells << [row, column] if cell.empty? }

    empty_cells
  end

  def remove_complete_rows
    @cells.reject! { |row| row.all?(&:occupied?) }

    number_of_empty_rows_to_add = DEFAULT_NUMBER_OF_ROWS - @cells.size

    number_of_empty_rows_to_add.times do
      @cells.unshift(Array.new(DEFAULT_NUMBER_OF_COLUMNS) { Cell.new })
    end

    number_of_empty_rows_to_add
  end

  private

  def each_cell_with_index(&block)
    @cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, column_index|
        yield cell, row_index, column_index
      end
    end
  end
end