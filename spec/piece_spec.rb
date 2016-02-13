module Tetris
  describe Piece do
    let(:j_piece) { Piece.new(Matrix[[0, 1, 0],
                                     [0, 1, 0],
                                     [1, 1, 0]]) }

    let(:i_piece) { Piece.new(Matrix[[0, 1, 0, 0],
                                     [0, 1, 0, 0],
                                     [0, 1, 0, 0],
                                     [0, 1, 0, 0]]) }

    describe '#new' do
      it 'creates a piece' do
        Piece.new
      end

      it 'sets the shape of the piece' do
        expect(j_piece.shape).to eq Matrix[[0, 1, 0],
                                           [0, 1, 0],
                                           [1, 1, 0]]

        expect(i_piece.shape).to eq Matrix[[0, 1, 0, 0],
                                           [0, 1, 0, 0],
                                           [0, 1, 0, 0],
                                           [0, 1, 0, 0]]
      end
    end

    describe '#cells' do
      it 'returns the cells occupied by the piece' do
        expect(j_piece.cells).to contain_exactly [0, 1], [1, 1], [2, 0], [2, 1]
        expect(i_piece.cells).to contain_exactly [0, 1], [1, 1], [2, 1], [3, 1]
      end
    end

    describe '#rotate' do
      it 'returns the piece clockwise rotated' do
        expect(j_piece.rotate).to eq Matrix[[1, 0, 0],
                                            [1, 1, 1],
                                            [0, 0, 0]]

        expect(i_piece.rotate).to eq Matrix[[0, 0, 0, 0],
                                            [1, 1, 1, 1],
                                            [0, 0, 0, 0],
                                            [0, 0, 0, 0]]
      end

      it 'does not change the piece' do
        expect { i_piece.rotate }.not_to change { i_piece.shape }
        expect { j_piece.rotate }.not_to change { j_piece.shape }
      end
    end

    describe '#rotate!' do
      it 'rotates the piece clockwise' do
        j_piece.rotate!

        expect(j_piece.shape).to eq Matrix[[1, 0, 0],
                                           [1, 1, 1],
                                           [0, 0, 0]]
      end
    end
  end
end