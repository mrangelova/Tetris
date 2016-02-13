module Tetris
  module GUI
    class PauseMode < Mode
      def button_down(id)
        case id
          when Gosu::KbR      then change_mode(:play)
          when Gosu::KbEscape then close
        end
      end

      def draw
        font.draw('GAME PAUSED', 150, 110, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
        font.draw('Press R to resume', 150, 150, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
        font.draw('Press Esc to exit', 150, 170, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      end
    end
  end
end