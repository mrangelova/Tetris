module Tetris
  describe ScoringSystem do
    let(:scoring_system) { ScoringSystem.new }

    describe '#new' do
      it 'creates a new scoring system' do
        ScoringSystem.new
      end

      it 'sets score and level to 0' do
        expect(scoring_system.score).to be_zero
        expect(scoring_system.level).to be_zero
      end
    end

    describe '#increase_score' do
      it 'increments the score' do
        expect { scoring_system.increase_score(42) }.to change { scoring_system.score }.by(42)
      end
    end

    describe '#increase_number_of_rows_removed' do
      it 'increments the number of rows removed and updates level accordingly' do
        expect { 10.times { scoring_system.increase_number_of_rows_removed(4) } }
          .to change { scoring_system.level }.by(4)
      end
    end
  end
end