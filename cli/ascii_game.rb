require_relative './ascii_grid'
require_relative './get_key'

module Tetris
  module CLI
    SAVE_GAME_PATH  = File.join(File.dirname(__FILE__), 'saved_game.yml')

    class AsciiGame
      def initialize()
        @game = Game.new
        @ascii_grid = AsciiGrid.new(@game)
        @user_playing = true
      end

      def run
        loop do
          execute_user_command

          if @game.should_update?
            @game.update
            render_game
          end

          if @game.over? or not @user_playing
            puts "\n\n GAME OVER"
            break
          end
        end
      end

      private

      def execute_user_command
        command = GetKey.getkey
        command = command.chr if command

        case command
          when 'i', 'I' then @game.tetromino.rotate
          when 'j', 'J' then @game.tetromino.move_left
          when 'l', 'L' then @game.tetromino.move_right
          when 'k', 'K' then @game.tetromino.drop
          when 'm', 'M' then @game.tetromino.drop_to_bottom
          when 'q', 'Q' then @user_playing = false
          when 's', 'S' then save_game
          when 'w', 'W' then load_game
        end
      end

      def save_game
        file = File.new(File.join(SAVE_GAME_PATH), "w")
        file << @game.to_yaml
        file.close
      end

      def load_game
        @game = YAML.load(File.open(SAVE_GAME_PATH)) if File.exist?(SAVE_GAME_PATH)
        @ascii_grid = AsciiGrid.new(@game)
      end

      def render_game
        system 'cls'
        puts @ascii_grid.render
        puts "\n LEVEL: #{@game.scoring_system.level}"
        puts "\n SCORE: #{@game.scoring_system.score}"
        puts "\n CONTROLLERS:\n"
        puts ' J - MOVE LEFT'
        puts ' L - MOVE RIGHT'
        puts ' K - DROP'
        puts ' I - ROTATE'
        puts ' M - DROP TO BOTTOM'
        puts ' Q - QUIT'
        puts ' S - SAVE GAME'
        puts ' W - LOAD GAME' if File.exist?(SAVE_GAME_PATH)
      end
    end
  end
end