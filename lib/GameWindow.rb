class GameWindow < Gosu::Window
  LEVEL_UPDATE_INTERVAL = {
    0 => 60,
    1 => 50,
    2 => 40,
    3 => 35,
    4 => 30,
    5 => 25,
    6 => 20,
    7 => 15,
    8 => 10,
    9 => 5,
  }

  def initialize
    super 550, 480
    self.caption = 'Tetris'
    @game = Game.new
    @grid = Grid.new(@game)
    @font = Gosu::Font.new(self, "Arial", 27)
    @last_time = 0
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
    if @game.over?
      @font.draw('GAME OVER', 150, 50, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw('SCORE', 150, 90, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("#{@game.scoring_system.score}", 150, 110, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
    else
      @font.draw('SCORE', 330, 100, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("#{@game.scoring_system.score}", 330, 120, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw('LEVEL', 330, 150, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @font.draw("#{@game.scoring_system.level}", 330, 170, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      @grid.draw
    end
  end

  def update
    if @game.over?
      @game.scoring_system.submit_highscore
    else
      @game.update if @last_time % LEVEL_UPDATE_INTERVAL[@game.scoring_system.level] == 0
      @last_time += 1
    end
  end

  class Grid
    X_OFFSET  = 100
    Y_OFFSET  = 100
    CELL_SIZE = 18

    CELL_IMAGES = {
      'empty_cells'    => Gosu::Image.new(File.join(File.dirname(__FILE__), '..', 'media', 'default_cell.png')),
      'occupied_cells' => Gosu::Image.new(File.join(File.dirname(__FILE__), '..', 'media', 'occupied_cell.png')),
      'live_cells'     => Gosu::Image.new(File.join(File.dirname(__FILE__), '..', 'media', 'live_cell.png')),
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