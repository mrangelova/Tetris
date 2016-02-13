module Tetris
  module GUI
    SAVE_GAME_PATH  = File.join(File.dirname(__FILE__), 'saved_game.yml')
    HIGHSCORES_PATH = File.join(File.dirname(__FILE__), 'highscores.yml')

    class GameWindow < Gosu::Window
      MODES = {
        play:         "PlayMode.new(self)",
        pause:        "PauseMode.new(self)",
        leader_board: "LeaderBoardMode.new(self)",
        game_over:    "GameOverMode.new(self)",
        main_menu:    "MainMenuMode.new(self)",
      }

      attr_reader :font, :current_mode
      attr_accessor :game

      def initialize
        super 600, 540
        self.caption = 'Tetris'
        @font = Gosu::Font.new(self, 'Arial', 27)
        @game = Game.new
        @current_mode = eval(MODES[:main_menu])
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
        @current_mode = eval(MODES[mode])
      end
    end
  end
end