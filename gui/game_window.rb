require_relative '../lib/tetris'
require_relative './configs'
require 'gosu'

module Tetris
  module GUI
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
        super 550, 480
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

      class MainMenuMode < Mode
        def button_down(id)
          case id
            when Gosu::KbN      then change_mode(:play)
            when Gosu::KbEscape then close
            when Gosu::KbV      then change_mode(:leader_board)
            when Gosu::KbL      then load_game
          end
        end

        def draw
          font.draw('Press N to start new game', 150, 150, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
          font.draw('Press Esc to exit', 150, 170, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
          font.draw('Press V to view highscores', 150, 210, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
          if File.exist?(File.join(File.dirname(__FILE__), 'saved_game.txt'))
            font.draw('Press L to load last game', 150, 190, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
          end
        end

        private

        def load_game
          @game_window.game = YAML.load(File.open(File.join(File.dirname(__FILE__), 'saved_game.txt')))
          change_mode(:play)
        end
      end

      class PauseMode < Mode
        def button_down(id)
          case id
            when Gosu::KbR      then change_mode(:play)
            when Gosu::KbEscape then close
          end
        end

        def draw
          font.draw('GAME PAUSED', 150, 110, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
          font.draw('Press R to resume', 150, 150, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
          font.draw('Press Esc to exit', 150, 170, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
        end
      end

      class LeaderBoardMode < Mode
        def draw
          font.draw('HIGHSCORES', 150, 110, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
          font.draw('Press N to start new game', 150, 430, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
          font.draw('Press Esc to exit', 150, 450, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)

          highscores.length.times do |score|
            font.draw("#{score + 1}.   #{highscores[score]}", 150, 130 + (score + 1) * 20 , 0,
                      scale_x = 1, scale_y = 1, color = 0xff_ffffff)
          end
        end

        def button_down(id)
          case id
            when Gosu::KbEscape then close
            when Gosu::KbN      then start_new_game
          end
        end

        private

        def start_new_game
          @game_window.game = Game.new
          change_mode(:play)
        end

        def highscores
          [YAML.load(File.open(ScoringSystem::HIGHSCORES_PATH, "r"))].flatten!
        end
      end

      class GameOverMode < Mode
        def draw
          font.draw('GAME OVER', 150, 50, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
          font.draw('SCORE:', 150, 90, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
          font.draw("#{game.scoring_system.score}", 260, 90, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
          font.draw('Press N to start new game', 150, 150, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
          font.draw('Press V to view highscores', 150, 180, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
          font.draw('Press Esc to exit', 150, 210, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
        end

        def button_down(id)
          case id
            when Gosu::KbEscape then close
            when Gosu::KbN      then start_new_game
            when Gosu::KbV      then change_mode(:leader_board)
          end
        end

        private

        def start_new_game
          @game_window.game = Game.new
          change_mode(:play)
        end
      end

      class PlayMode < Mode
        class Grid
          X_OFFSET  = 100
          Y_OFFSET  = 100
          CELL_SIZE = 18

          CELL_IMAGES = {
            'empty_cells'    => Gosu::Image.new(Configs::DEFAULT_CELL_IMAGE_PATH),
            'occupied_cells' => Gosu::Image.new(Configs::OCCUPIED_CELL_IMAGE_PATH),
            'live_cells'     => Gosu::Image.new(Configs::LIVE_CELL_IMAGE_PATH),
          }

          def initialize(game)
            @game = game
          end

          def draw
            CELL_IMAGES.each do |cell_type, cell_image|
              eval(cell_type).each do |cell|
                cell_image.draw(X_OFFSET + cell[1] * CELL_SIZE, Y_OFFSET + cell[0] * CELL_SIZE, 0)
              end
            end
          end

          private

          def empty_cells
            @game.playfield.empty_cells
          end

          def occupied_cells
            @game.playfield.occupied_cells
          end

          def live_cells
            @game.tetromino.cells
          end
        end

        class NextTetrominoPreview
          X_OFFSET = 270
          Y_OFFSET = 250
          CELL_SIZE = 18
          CELL_IMAGE = Gosu::Image.new(Configs::LIVE_CELL_IMAGE_PATH)

          def initialize(game)
            @game = game
          end

          def draw
            @game.next_tetromino.cells.each do |cell|
              CELL_IMAGE.draw(X_OFFSET + cell[1] * CELL_SIZE, Y_OFFSET + cell[0] * CELL_SIZE, 0)
            end
          end
        end

        SOUNDS = {
          play:     Gosu::Song.new(Configs::GAME_MUSIC_PATH),
          end_game: Gosu::Sample.new(Configs::GAME_OVER_SOUND_PATH),
        }

        def initialize(game_window)
          super(game_window)
          @grid = Grid.new(game)
          @next_tetromino_preview = NextTetrominoPreview.new(game)
        end

        def draw
          font.draw('SCORE', 330, 100, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
          font.draw("#{game.scoring_system.score}",
                     330, 120, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
          font.draw('LEVEL', 330, 150, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
          font.draw("#{game.scoring_system.level}",
                     330, 170, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
          font.draw('NEXT PIECE:', 330, 210, 0, scale_x = 1, scale_y = 1, color = 0xff_ffffff)
          @grid.draw
          @next_tetromino_preview.draw
          SOUNDS[:play].play
        end

        def update
          end_game if game.over?

          game.update if game.should_update?
        end

        def button_down(id)
          case id
            when Gosu::KbDown   then game.tetromino.drop
            when Gosu::KbRight  then game.tetromino.move_right
            when Gosu::KbLeft   then game.tetromino.move_left
            when Gosu::KbUp     then game.tetromino.rotate
            when Gosu::KbSpace  then game.tetromino.drop_to_bottom
            when Gosu::KbEscape then close
            when Gosu::KbP      then change_mode(:pause)
            when Gosu::KbS      then save_game
          end
        end

        private

        def save_game
          file = File.new(File.join(File.dirname(__FILE__), 'saved_game.txt'), "w")
          file << game.to_yaml
          file.close
        end

        def end_game
          SOUNDS[:play].stop
          SOUNDS[:end_game].play
          game.scoring_system.submit_highscore
          change_mode(:game_over)
        end
      end
    end
  end
end