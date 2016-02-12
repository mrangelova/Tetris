require_relative './ascii_grid'
require_relative './get_key'

module Tetris
  module TUI
    class AsciiGame
      SLEEP_LOOP = 0.02

      def initialize()
        @game = Game.new
        @ascii_grid = AsciiGrid.new(@game)
        system 'cls'
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
      end

      def run
        loop do
          execute_user_command

          if @game.should_update?
            @game.update
            render_game
          end

          if @game.over?
            puts "\n\n GAME OVER"
            break
          end

          sleep SLEEP_LOOP
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
        end
      end
    end
  end
end