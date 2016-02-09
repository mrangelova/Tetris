class GameWindow < Gosu::Window
  def initialize
    super 550, 480
    self.caption = 'Tetris'
    @game = Game.new
    @grid = Grid.new(@game)
  end

  def needs_cursor?
    true
  end

  def button_down(id)
    case id
      when Gosu::KbDown   then @game.tetromino.drop
      when Gosu::KbRight  then @game.tetromino.move_right
      when Gosu::KbLeft   then @game.tetromino.move_left
      when Gosu::KbUp     then @game.tetromino.rotate
      when Gosu::KbSpace  then @game.tetromino.drop_to_bottom
      when Gosu::KbEscape then close
    end
  end

  def draw
    @grid.draw
  end

  def update

  end

  class Grid
    X_OFFSET  = 100
    Y_OFFSET  = 100
    CELL_SIZE = 18

    CELL_IMAGES = {
      'empty_cells'    => Gosu::Image.new(File.join(File.dirname(__FILE__), 'default_cell.png')),
      'occupied_cells' => Gosu::Image.new(File.join(File.dirname(__FILE__), 'occupied_cell.png')),
      'live_cells'     => Gosu::Image.new(File.join(File.dirname(__FILE__), 'red_cell.png')),
    }

    def initialize(game)
      @game = game
    end

    def draw
      CELL_IMAGES.each do |cell_type, cell_image|
        eval(cell_type).each do |cell|
          cell_image.draw(X_OFFSET + cell[1] * CELL_SIZE, Y_OFFSET + cell[0] * CELL_SIZE, 0)
        end
      end
    end

    private

    def empty_cells
      @game.playfield.empty_cells
    end

    def occupied_cells
      @game.playfield.occupied_cells
    end

    def live_cells
      @game.tetromino.cells
    end
  end
end