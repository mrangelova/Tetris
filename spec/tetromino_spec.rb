module Tetris
  describe Tetromino do
    let(:playfield) { Playfield.new }
    let(:tetromino) { Tetromino.new(playfield) }

    let(:j_piece) { Piece.new(Matrix[[0, 1, 0],
                                     [0, 1, 0],
                                     [1, 1, 0]]) }

    let(:i_piece) { Piece.new(Matrix[[0, 1, 0, 0],
                                     [0, 1, 0, 0],
                                     [0, 1, 0, 0],
                                     [0, 1, 0, 0]]) }

    let(:i_tetromino) { Tetromino.new(playfield, i_piece) }
    let(:j_tetromino) { Tetromino.new(playfield, j_piece) }

    describe '#new' do
      it 'creates a new tetromino' do
        Tetromino.new(playfield)
      end

      it 'sets default top left position' do
        expect(Tetromino.new(playfield).top_left_position).to eq [0, 4]
      end
    end

    describe '#move_right' do
      it 'moves the tetromino right if it can be moved' do
        expect { tetromino.move_right }.to change { tetromino.top_left_position }.from([0, 4]).to([0, 5])
      end

      it 'does not affect tetromino shape' do
        expect { tetromino.move_right }.not_to change { tetromino.piece }
      end

      it 'does not affect the playfield' do
        expect { tetromino.move_right }.not_to change { tetromino.playfield }
      end

      it 'does nothing if there is a boarder right to the tetromino' do
        4.times { i_tetromino.move_right }

        expect { i_tetromino.move_right }.not_to change { i_tetromino.top_left_position }
        expect { i_tetromino.move_right }.not_to change { i_tetromino.piece }
        expect { i_tetromino.move_right }.not_to change { i_tetromino.playfield }
      end

      it 'does nothing if there is an occupied cell right to the tetromino' do
        i_tetromino.playfield.occupy_cell(0, 6)

        expect { i_tetromino.move_right }.not_to change { i_tetromino.top_left_position }
        expect { i_tetromino.move_right }.not_to change { i_tetromino.piece }
        expect { i_tetromino.move_right }.not_to change { i_tetromino.playfield }
      end
    end

    describe '#move_left' do
      it 'moves the tetromino left if it can be moved' do
        expect { tetromino.move_left }.to change { tetromino.top_left_position }.from([0, 4]).to([0, 3])
      end

      it 'does not affect tetromino shape' do
        expect { tetromino.move_left }.not_to change { tetromino.piece }
      end

      it 'does not affect the playfield' do
        expect { tetromino.move_left }.not_to change { tetromino.playfield }
      end

      it 'does nothing if there is a boarder left to the tetromino' do
        5.times { i_tetromino.move_left }

        expect { i_tetromino.move_left }.not_to change { i_tetromino.top_left_position }
        expect { i_tetromino.move_left }.not_to change { i_tetromino.piece }
        expect { i_tetromino.move_left }.not_to change { i_tetromino.playfield }
      end

      it 'does nothing if there is an occupied cell left to the tetromino' do
        i_tetromino.playfield.occupy_cell(1, 4)

        expect { i_tetromino.move_left }.not_to change { i_tetromino.top_left_position }
        expect { i_tetromino.move_left }.not_to change { i_tetromino.piece }
        expect { i_tetromino.move_left }.not_to change { i_tetromino.playfield }
      end
    end

    describe '#drop' do
      it 'moves the tetromino down if there is no collision' do
        expect { tetromino.drop }.to change { tetromino.top_left_position }.from([0, 4]).to([1, 4])
        expect { tetromino.drop }.to change { tetromino.top_left_position }.from([1, 4]).to([2, 4])
      end

      it 'does not affect tetromino shape' do
        expect { tetromino.drop }.not_to change { tetromino.piece }
      end

      it 'does not affect the playfield' do
        expect { tetromino.drop }.not_to change { tetromino.playfield }
      end

      it 'does nothing if tetromino has reached the bottom' do
        17.times { i_tetromino.drop }

        expect { i_tetromino.drop }.not_to change { i_tetromino.top_left_position }
        expect { i_tetromino.drop }.not_to change { i_tetromino.piece }
        expect { i_tetromino.drop }.not_to change { i_tetromino.playfield }
      end

      it 'does nothing if there is an occupied cell below the tetromino' do
        j_tetromino.playfield.occupy_cell(3, 5)

        expect { j_tetromino.drop }.not_to change { j_tetromino.top_left_position }
        expect { j_tetromino.drop }.not_to change { j_tetromino.piece }
        expect { j_tetromino.drop }.not_to change { j_tetromino.playfield }
      end
    end

    describe '#rotate' do
      it 'rotates the tetromino if it could be rotated' do
        expect { i_tetromino.rotate }.to change { i_tetromino.piece.shape }
          .from(Matrix[[0, 1, 0, 0],
                       [0, 1, 0, 0],
                       [0, 1, 0, 0],
                       [0, 1, 0, 0]])
          .to(Matrix[[0, 0, 0, 0],
                     [1, 1, 1, 1],
                     [0, 0, 0, 0],
                     [0, 0, 0, 0]])

          expect { j_tetromino.rotate }.to change { j_tetromino.piece.shape }
            .from(Matrix[[0, 1, 0],
                         [0, 1, 0],
                         [1, 1, 0]])
            .to(Matrix[[1, 0, 0],
                       [1, 1, 1],
                       [0, 0, 0]])
        end

      it 'does not change the tetromino position' do
        expect { i_tetromino.rotate }.not_to change { i_tetromino.top_left_position }
        expect { j_tetromino.rotate }.not_to change { j_tetromino.top_left_position }
      end

      it 'does nothing if there would be cell collision after rotation' do
        j_tetromino.playfield.occupy_cell(0, 4)

        expect { j_tetromino.rotate }.not_to change { j_tetromino.top_left_position }
        expect { j_tetromino.rotate }.not_to change { j_tetromino.playfield }
        expect { j_tetromino.rotate }.not_to change { j_tetromino.piece }
      end

      it 'does nothing if tetromino would be out of bounds after rotation' do
        3.times { i_tetromino.move_right }

        expect { i_tetromino.rotate }.not_to change { i_tetromino.top_left_position }
        expect { i_tetromino.rotate }.not_to change { i_tetromino.playfield }
        expect { i_tetromino.rotate }.not_to change { i_tetromino.piece }
      end
    end

    describe '#fallen?' do
      it 'returns true if the tetromino has reached the bottommost position' do
        18.times { j_tetromino.drop }

        expect(j_tetromino.fallen?).to be true
      end

      it 'returns true if the tetromino cannot move down due to cell collision' do
        i_tetromino.playfield.occupy_cell(4, 5)

        expect(i_tetromino.fallen?).to be true
      end

      it 'returns false if the tetromino can move down' do
        expect(j_tetromino.fallen?).to be false
      end
    end

    describe '#cells' do
      it 'returns all cells occupied by tetromino' do
        expect(i_tetromino.cells).to contain_exactly [0, 5], [1, 5], [2, 5], [3, 5]
        expect(j_tetromino.cells).to contain_exactly [0, 5], [1, 5], [2, 5], [2, 4]
      end
    end

    describe '#size' do
      it 'returns the number of cells of the tetromino' do
        expect(i_tetromino.size).to eq 4
        expect(j_tetromino.size).to eq 4
      end
    end
  end
end