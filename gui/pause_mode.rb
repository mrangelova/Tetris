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
        font.draw('GAME PAUSED', 150, 110, 0)
        font.draw('Press R to resume', 150, 150, 0)
        font.draw('Press Esc to exit', 150, 170, 0)
      end
    end
  end
end