require 'gosu'

require_relative '../lib/tetris'
require_relative './configs'
require_relative './mode.rb'
require_relative './game_over_mode.rb'
require_relative './leader_board_mode.rb'
require_relative './play_mode.rb'
require_relative './pause_mode.rb'
require_relative './main_menu_mode.rb'
require_relative './game_window'

module Tetris
  module GUI
    def self.start
      GameWindow.new.show
    end
  end
end

Tetris::GUI.start