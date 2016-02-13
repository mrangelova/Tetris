require_relative './ascii_game'

module Tetris
  module CLI
    def self.start
      AsciiGame.new.run
    end
  end
end

Tetris::CLI.start