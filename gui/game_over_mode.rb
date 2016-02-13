module Tetris
  module GUI
    class GameOverMode < Mode
      def draw
        font.draw('GAME OVER', 150, 50, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
        font.draw('SCORE:', 150, 90, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
        font.draw("#{game.scoring_system.score}", 260, 90, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
        font.draw('Press N to start new game', 150, 150, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
        font.draw('Press V to view highscores', 150, 180, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
        font.draw('Press Esc to exit', 150, 210, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
      end

      def button_down(id)
        case id
          when Gosu::KbEscape then close
          when Gosu::KbN      then start_new_game
          when Gosu::KbV      then change_mode(:leader_board)
        end
      end

      private

      def start_new_game
        @game_window.game = Game.new
        change_mode(:play)
      end
    end
  end
end