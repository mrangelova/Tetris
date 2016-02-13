module Tetris
  module GUI
    class LeaderBoardMode < Mode
      def draw
        font.draw('HIGHSCORES', 150, 110, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
        font.draw('Press N to start new game', 150, 430, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
        font.draw('Press Esc to exit', 150, 450, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)

        highscores.length.times do |score|
          font.draw("#{score + 1}.   #{highscores[score]}", 150, 130 + (score + 1) * 20 , 0,
                    scale_x = 1, scale_y = 1, color = 0xff_ffffff)
        end
      end

      def button_down(id)
        case id
          when Gosu::KbEscape then close
          when Gosu::KbN      then start_new_game
        end
      end

      private

      def start_new_game
        @game_window.game = Game.new
        change_mode(:play)
      end

      def highscores
        [YAML.load(File.open(HIGHSCORES_PATH, "r"))].flatten!
      end
    end
  end
end