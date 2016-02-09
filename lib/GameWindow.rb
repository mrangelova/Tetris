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

  end

  def draw

  end

  def update

  end
end