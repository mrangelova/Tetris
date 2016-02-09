class GameWindow < Gosu::Window
  def initialize
    super 550, 480
    self.caption = 'Tetris'
    @game = Game.new
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

  end

  def update

  end
end