module Tetris
  module GUI
    class Mode
      attr_accessor :game_window

      def initialize(game_window)
        @game_window = game_window
      end

      def update
      end

      def draw
        raise NotImplementedError, "#{self.class} has not implemented method draw"
      end

      def close
        @game_window.close
      end

      private

      def game
        @game_window.game
      end

      def font
        @game_window.font
      end

      def change_mode(mode)
        @game_window.change_mode(mode)
      end
    end
  end
end