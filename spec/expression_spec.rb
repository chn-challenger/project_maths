require './models/expression'

describe Expression do
  let(:step_1){double(:step_1)}
  let(:step_2){double(:step_2)}
  let(:exp){described_class.new([step_1,step_2])}
  let(:exp_copy){exp.copy}

  describe '#new/initialize' do
    it 'initialize with an array of steps which can be read as attribute' do
      expect(exp.steps).to eq [step_1,step_2]
    end
  end

  describe '#==' do
    it 'returns true when all steps are orderedly equal(==)' do
      exp_2 = described_class.new([step_1,step_2])
      expect(exp).to eq exp_2
    end

    it 'returns false when steps are equal but not the same order' do
      exp_2 = described_class.new([step_2,step_1])
      expect(exp).not_to eq exp_2
    end

    it 'returns false when steps are different' do
      step_3 = double(:step_3)
      exp_2 = described_class.new([step_3])
      expect(exp).not_to eq exp_2
    end
  end

  describe '#copy' do
    context 'makes a deep copy by making a copy of each step' do
      before(:each) do
        allow(step_1).to receive(:copy).and_return('copy_of_step_1')
        allow(step_2).to receive(:copy).and_return('copy_of_step_2')
      end

      it 'the copy and original are different objects' do
        expect(exp_copy.object_id).not_to eq exp.object_id
      end

      it 'steps in the copied expression are copies' do
        expect(exp_copy.steps).to eq ['copy_of_step_1','copy_of_step_2']
      end
    end
  end

end
