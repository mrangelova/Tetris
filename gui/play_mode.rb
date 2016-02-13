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
        font.draw('SCORE', 330, 100, 0)
        font.draw("#{game.scoring_system.score}", 330, 120, 0)
        font.draw('LEVEL', 330, 150, 0)
        font.draw("#{game.scoring_system.level}", 330, 170, 0)
        font.draw('NEXT PIECE:', 330, 210, 0)
        font.draw('CONTROLS:', 330, 320, 0)
        font.draw(':LEFT: MOVE LEFT', 330, 350, 0)
        font.draw(':RIGHT: MOVE RIGHT', 330, 370, 0)
        font.draw(':DOWN: SOFT DROP', 330, 390, 0)
        font.draw(':SPACE: HARD DROP', 330, 410, 0)
        font.draw(':UP: ROTATE', 330, 430, 0)
        font.draw(':P: PAUSE GAME', 330, 450, 0)
        font.draw(':S: SAVE GAME', 330, 470, 0)
        font.draw(':ESC: QUIT GAME', 330, 490, 0)
        font.draw(':A: VOLUME UP', 330, 510, 0)
        font.draw(':Z: VOLUME DOWN', 330, 530, 0)
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
          when Gosu::KbA      then increase_song_volume
          when Gosu::KbZ      then decrease_song_volume
        end
      end

      private

      def increase_song_volume
        SOUNDS[:play].volume += 0.1
      end

      def decrease_song_volume
        SOUNDS[:play].volume -= 0.1
      end

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