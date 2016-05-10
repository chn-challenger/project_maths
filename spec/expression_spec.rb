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

  describe '#responds to forwarded methods from Enumerable' do
    it 'responds to #size' do
      expect(exp).to respond_to(:size)
    end

    it 'responds to #each' do
      expect(exp).to respond_to(:each)
    end

    it 'responds to #[]' do
      expect(exp).to respond_to(:[])
    end

    it 'gives number of steps as size' do
      expect(exp.size).to eq 2
    end
  end

  describe '#expand_to_ms' do
    it 'returns an equivalent m-form-sum expression' do
      ms_klass = double(:ms_klass)
      allow(ms_klass).to receive(:new).and_return('ms_exp')
      allow(step_1).to receive(:expand_into_ms).with('ms_exp')
      allow(step_2).to receive(:expand_into_ms).with('ms_exp')
      expect(exp.expand_to_ms(ms_klass)).to eq 'ms_exp'
    end
  end
end

describe Step do
  describe '#initialize/new' do
    let(:exp){double(:exp)}
    let(:step){described_class.new(:some_ops,exp)}

    it 'with an operation that can be read as an attribute' do
      expect(step.ops).to eq :some_ops
    end

    it 'with a value that can be read as an attribute' do
      expect(step.val).to eq exp
    end

    it 'with a direction (with default) that can be read as an attribute' do
      expect(step.dir).to eq :rgt
    end
  end

  describe '#expand_into_ms' do
    let(:exp){double(:exp)}
    let(:add_step){described_class.new(:add,exp)}
    let(:sbt_step){described_class.new(:sbt,exp)}
    let(:mtp_step){described_class.new(:mtp,exp)}
    let(:ms_exp){double(:ms_exp)}
    let(:klass){double(:klass)}

    it 'returns the an expanded m-form-sum exp when ops is add' do
      allow(exp).to receive(:expand_add_into_ms).with(ms_exp,described_class)
        .and_return('expanded_ms_exp')
      expect(add_step.expand_into_ms(ms_exp)).to eq 'expanded_ms_exp'
    end

    it 'returns the an expanded m-form-sum exp when ops is sbt' do
      allow(exp).to receive(:expand_sbt_into_ms).with(ms_exp,described_class)
        .and_return('expanded_ms_exp')
      expect(sbt_step.expand_into_ms(ms_exp)).to eq 'expanded_ms_exp'
    end

    it 'returns the an expanded m-form-sum exp when ops is mtp' do
      allow(exp).to receive(:expand_mtp_into_ms).with(ms_exp,described_class)
        .and_return('expanded_ms_exp')
      expect(mtp_step.expand_into_ms(ms_exp)).to eq 'expanded_ms_exp'
    end
  end
end

describe NumExp do
  let(:number){double(:number)}
  let(:num_exp){described_class.new(number)}

  describe '#initializes/new' do
    it 'initializes with a numerical value that can be read as an attribute' do
      expect(num_exp.value).to eq number
    end
  end

  describe '#expand_add_into_ms' do
    it 'expands an add step into a m-form-sum exp' do
      ms_exp = double(:ms_exp)
      step_klass = double(:step_klass)
      allow(step_klass).to receive(:new).with(:add,num_exp).and_return('new step')
      steps = []
      allow(ms_exp).to receive(:steps).and_return(steps)
      num_exp.expand_add_into_ms(ms_exp,step_klass)
      expect(ms_exp.steps).to eq ['new step']
    end
  end

  describe '#expand_mtp_into_ms' do
    
  end

end


#
# describe StringExp do
#   let(:str_exp){described_class.new('x')}
#
#   describe '#initializes/new' do
#     it 'initializes with a string value that can be read as an attribute' do
#       expect(str_exp.value).to eq 'x'
#     end
#   end
# end
#
# describe StringStep do
#   let(:str_exp){double(:str_exp)}
#   let(:str_step){described_class.new(:add,str_exp)}
#
#   describe '#initialize/new' do
#     it 'with an operation that can be read as an attribute' do
#       expect(str_step.ops).to eq :add
#     end
#
#     it 'with a value that can be read as an attribute' do
#       expect(str_step.val).to eq str_exp
#     end
#
#     it 'with a direction (with default) that can be read as an attribute' do
#       expect(str_step.dir).to eq :rgt
#     end
#   end
# end
