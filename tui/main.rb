require_relative './ascii_game'

module Tetris
  module TUI
    def self.start
      AsciiGame.new.run
    end
  end
end

Tetris::TUI.start