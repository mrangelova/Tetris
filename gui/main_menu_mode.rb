module Tetris
  module GUI
    class MainMenuMode < Mode
      def button_down(id)
        case id
          when Gosu::KbN      then change_mode(:play)
          when Gosu::KbEscape then close
          when Gosu::KbV      then change_mode(:leader_board)
          when Gosu::KbL      then load_game
        end
      end

      def draw
        font.draw('Press N to start new game', 150, 150, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
        font.draw('Press Esc to exit', 150, 170, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
        font.draw('Press V to view highscores', 150, 210, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
        if File.exist?(File.join(SAVE_GAME_PATH))
          font.draw('Press L to load last game', 150, 190, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
        end
      end

      private

      def load_game
        if File.exist?(File.join(SAVE_GAME_PATH))
          @game_window.game = YAML.load(File.open(SAVE_GAME_PATH))
          change_mode(:play)
        end
      end
    end
  end
end