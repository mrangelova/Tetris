module Tetris
  describe Game do
    let(:playfield) { Playfield.new }
    let(:i_piece) { Piece.new(Matrix[[0, 1, 0, 0],
                                     [0, 1, 0, 0],
                                     [0, 1, 0, 0],
                                     [0, 1, 0, 0]]) }

    let(:i_tetromino) { Tetromino.new(playfield, i_piece) }
    let(:game) { Game.new(i_tetromino) }

    describe '#new' do
      it 'creates a new game' do
        Game.new
      end
    end

    describe '#over?' do
      it 'returns true if a new tetromino could not be created due to cell collision' do
        game.tetromino.drop_to_bottom

        game.playfield.occupy_cell(0, 4)
        game.playfield.occupy_cell(0, 5)
        game.playfield.occupy_cell(0, 6)

        game.update

        expect(game.over?).to be true
      end

      it 'returns false if a new tetromino could be created' do
        game.tetromino.drop_to_bottom
        game.update

        expect(game.over?).to be false
      end
    end

    describe '#update' do
      context 'when the active tetromino has fallen' do
        it 'increments the score by tetromino size' do
          game.tetromino.drop_to_bottom

          expect { game.update }.to change { game.scoring_system.score }.by 4
        end

        it 'marks fallen tetromino cells as occupied in playfield' do
          game.tetromino.drop_to_bottom
          game.update

          expect(game.playfield.occupied_cells).to contain_exactly [16, 5], [17, 5], [18, 5], [19, 5]
        end

        it 'removes complete rows if any' do
          initially_occupied_cells = [[19, 0], [19, 1], [19, 2], [19, 3], [19, 4],
                                     [19, 6], [19, 7], [19,8], [19, 9]]
          initially_occupied_cells.each { |cell| game.playfield.occupy_cell *cell }

          game.tetromino.drop_to_bottom

          game.update

          expect(game.playfield.occupied_cells).not_to include *initially_occupied_cells
        end

        it 'creates a new tetromino' do
          game.tetromino.drop_to_bottom

          expect { game.update }.to change { game.tetromino }
        end

        it 'updates next tetromino' do
          game.tetromino.drop_to_bottom

          expect { game.update }.to change { game.next_tetromino }
        end
      end

      context 'when the tetromino has not fallen' do
        it 'moves the tetromino down by one cell' do
          expect { game.update }.to change { game.tetromino.top_left_position }
            .from([0, 4]).to([1, 4])
        end
      end
    end
  end
end