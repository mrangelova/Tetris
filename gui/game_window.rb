module Tetris
  module GUI
    SAVE_GAME_PATH  = File.join(File.dirname(__FILE__), 'saved_game.yml')
    HIGHSCORES_PATH = File.join(File.dirname(__FILE__), 'highscores.yml')

    class GameWindow < Gosu::Window
      MODES = {
        play:         PlayMode,
        pause:        PauseMode,
        leader_board: LeaderBoardMode,
        game_over:    GameOverMode,
        main_menu:    MainMenuMode,
      }

      attr_reader :font, :current_mode
      attr_accessor :game

      def initialize
        super 600, 560
        self.caption = 'Tetris'
        @font = Gosu::Font.new(self, 'Arial', 27)
        @game = Game.new
        @current_mode = MODES[:main_menu].new self
      end

      def needs_cursor?
        true
      end

      def button_down(id)
        @current_mode.button_down(id)
      end

      def draw
        @current_mode.draw
      end

      def update
        @current_mode.update
      end

      def change_mode(mode)
        @current_mode = MODES[mode].new self
      end
    end
  end
end