module Tetris
  describe Playfield do
    let(:playfield) { Playfield.new }

    describe '#new' do
      it 'creates a playfield' do
        Playfield.new
      end

      it 'sets the dimensions of the playfield' do
        playfield = Playfield.new(40, 50)

        expect(playfield.number_of_rows).to eq 40
        expect(playfield.number_of_columns).to eq 50
      end

      it 'sets default values for dimensions' do
        expect(playfield.number_of_rows).to eq 20
        expect(playfield.number_of_columns).to eq 10
      end

      it 'populates the playfield with empty cells' do
        expect(playfield.occupied_cells).to be_empty
      end
    end

    describe '#occupy_cell' do
      it 'marks a cell from the playfield as occupied' do
        playfield.occupy_cell(3, 4)

        expect(playfield.occupied_cells).to include [3, 4]
      end
    end

    describe '#cell_empty?' do
      it 'returns true for empty cells' do
        expect(playfield.cell_empty?(0, 0)).to be true
      end

      it 'returns false for occupied cells' do
        playfield.occupy_cell(3, 4)

        expect(playfield.cell_empty?(3, 4)).to be false
      end
    end

    describe '#cell_occupied?' do
      it 'returns true for occupied cells' do
        playfield.occupy_cell(3, 4)

        expect(playfield.cell_occupied?(3, 4)).to be true
      end

      it 'returns false for empty cells' do
        expect(playfield.cell_occupied?(0, 0)).to be false
      end
    end

    describe '#occupied_cells' do
      it 'it returns all occupied cells' do
        playfield.occupy_cell(3, 4)
        playfield.occupy_cell(5, 6)
        playfield.occupy_cell(3, 9)

        expect(playfield.occupied_cells).to contain_exactly [3, 4], [5, 6], [3, 9]
      end
    end

    describe '#empty_cells' do
      it 'it returns all empty cells' do
        all_cells = 0.upto(19).to_a.product(0.upto(9).to_a)

        expect(playfield.empty_cells).to contain_exactly *all_cells
      end
      it 'does not return any occupied_cells' do
        playfield.occupy_cell(2, 5)

        expect(playfield.empty_cells).not_to include [2, 5]
      end
    end

    describe '#remove_complete_rows' do
      it 'removes complete rows' do
        10.times do |column|
          playfield.occupy_cell(19, column - 1)
          playfield.occupy_cell(18, column - 1)
        end

        playfield.remove_complete_rows

        expect(playfield.occupied_cells).to be_empty
      end

      it 'adds an empty row when removing a complete one' do
        10.times do |column|
          playfield.occupy_cell(19, column - 1)
        end

        playfield.occupy_cell(0, 3)
        playfield.remove_complete_rows

        expect(playfield.occupied_cells).to contain_exactly [1, 3]
      end

      it 'returns the number or rows removed' do
        10.times do |column|
          playfield.occupy_cell(16, column - 1)
          playfield.occupy_cell(17, column - 1)
          playfield.occupy_cell(18, column - 1)
        end

        expect(playfield.remove_complete_rows).to eq 3
      end
    end
  end
end