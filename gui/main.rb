require_relative './game_window'

module Tetris
  module GUI
    def self.start
      GameWindow.new.show
    end
  end
end

Tetris::GUI.start