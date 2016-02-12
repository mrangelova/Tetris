require_relative './ascii_grid'
require_relative './get_key'

module Tetris
  module TUI
    class AsciiGame
      SLEEP_LOOP = 0.02

      LEVELS = {
        0 => 0.8,
        1 => 0.7167,
        2 => 0.6333,
        3 => 0.55,
        4 => 0.4667,
        5 => 0.3833,
        6 => 0.3,
        7 => 0.2166,
        8 => 0.1333,
        9 => 0.1,
      }

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

      def falling_speed
        LEVELS[@game.scoring_system.level]
      end

      def run
        last_update = Time.now

        loop do
          execute_user_command

          if Time.now - last_update > falling_speed
            @game.update
            last_update = Time.now
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