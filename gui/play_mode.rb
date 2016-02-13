module Tetris
  module GUI
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

      def submit_highscore
        scores = [game.scoring_system.score]

        scores << YAML.load(File.open(HIGHSCORES_PATH, "r")) if File.exist?(HIGHSCORES_PATH)

        file = File.new(HIGHSCORES_PATH, "w")
        file << scores.flatten.sort.reverse[0..9].to_yaml
        file.close
      end

      def save_game
        file = File.new(File.join(SAVE_GAME_PATH), "w")
        file << game.to_yaml
        file.close
      end

      def end_game
        SOUNDS[:play].stop
        SOUNDS[:end_game].play

        submit_highscore

        change_mode(:game_over)
      end
    end
  end
end