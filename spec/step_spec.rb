require './models/step'

describe Step do
  describe '#initialize/new' do
    context 'check instance variable assignment' do
      shared_context 'addition step' do
        before(:all) do
          @step = described_class.new(:add,5,:rgt)
        end
      end

      include_context 'addition step'

      it 'has operation of addition' do
        expect(@step.ops).to eq :add
      end

      it 'has value for the step' do
        expect(@step.val).to eq 5
      end

      it 'has an orientation of left or right' do
        expect(@step.dir).to eq :rgt
      end
    end
  end

  describe '#==' do
    it 'asserts equal when all instance variables are the same' do
      step_1 = Step.new(:add,5,:lft)
      step_2 = Step.new(:add,5,:lft)
      expect(step_1 == step_2).to eq true
    end

    it 'asserts not equal when compared step is not a step' do
      step_1 = Step.new(:add,5,:lft)
      step_2 = 'a string'
      expect(step_1 == step_2).to eq false
    end

    it 'asserts not equal when operations are not the same' do
      step_1 = Step.new(:add,5,:lft)
      step_2 = Step.new(:mtp,5,:lft)
      expect(step_1 == step_2).to eq false
    end

    it 'asserts not equal when values are not the same' do
      step_1 = Step.new(:add,6,:lft)
      step_2 = Step.new(:add,5,:lft)
      expect(step_1 == step_2).to eq false
    end

    it 'asserts not equal when directions are not the same' do
      step_1 = Step.new(:add,5,:lft)
      step_2 = Step.new(:add,5,:rgt)
      expect(step_1 == step_2).to eq false
    end
  end

  describe 'copy' do
    context 'setup a step and its copy for tests' do
      shared_context 'step and copy' do
        before(:all) do
          @step = described_class.new(:add,5,:rgt)
          @copy = @step.copy
        end
      end

      include_context 'step and copy'

      it 'is equal to its copy' do
        expect(@step == @copy).to eq true
      end

      it 'have different object ids' do
        expect(@step.object_id == @copy.object_id).to eq false
      end
    end
  end

  describe '#is_elementary?' do
    it 'returns true for numerical valued step' do
      step = Step.new(:add,3)
      expect(step.is_elementary?).to be true
    end

    it 'returns true for string valued step' do
      step = Step.new(:add,'x')
      expect(step.is_elementary?).to be true
    end

    it 'returns false for expression valued step' do
      step = Step.new(:add,Expression.new())
      expect(step.is_elementary?).to be false
    end
  end

  describe '#is_m_form?' do
    it 'returns true for m_form expression valued step' do
      step = Step.new(:div,Expression.new([Step.new(nil,2),Step.new(:mtp,'x')]))
      expect(step.is_m_form?).to be true
    end

    it 'returns false for an elementary step' do
      step = Step.new(:div,6)
      expect(step.is_m_form?).to be false
    end

    it 'returns false for a sum expression valued step' do
      step = Step.new(:div,Expression.new([Step.new(nil,3),Step.new(:add,5)]))
      expect(step.is_m_form?).to be false
    end
  end

  describe '#is_rational?' do
    it 'returns true for rational valued step' do
      step = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:div,7)]))
      expect(step.is_rational?).to be true
    end
  end

  describe '#is_m_form_sum?' do
    it 'returns true for an elementary step expression valued step' do
      step = Step.new(:div,Expression.new([Step.new(:add,'x')]))
      expect(step.is_m_form_sum?).to be true
    end

    it 'returns true for an m-form-sum expression valued step' do
      step = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:add,7)]))
      expect(step.is_m_form_sum?).to be true
    end

    it 'returns false for an elementary step' do
      step = Step.new(nil,1)
      expect(step.is_m_form_sum?).to be false
    end
  end

  describe '#is_rational_sum?' do
    it 'returns true for an rational-sum expression valued step' do
      r_step_1 = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:div,7)]))
      r_step_2 = Step.new(:sbt,Expression.new([Step.new(nil,'x'),Step.new(:div,7)]))
      r_sum_step = Step.new(:div,Expression.new([r_step_1,r_step_2]))
      expect(r_sum_step.is_rational_sum?).to be true
    end

    it 'returns false for an elementary step' do
      step = Step.new(nil,1)
      expect(step.is_rational_sum?).to be false
    end
  end

  describe '#reverse_step' do
    it 'returns reverse of a right addition step' do
      step = Step.new(:add,5)
      reverse_step = Step.new(:sbt,5)
      expect(step.reverse_step).to eq reverse_step
    end

    it 'returns reverse of a left addition step' do
      step = Step.new(:add,5,:lft)
      reverse_step = Step.new(:sbt,5)
      expect(step.reverse_step).to eq reverse_step
    end

    it 'returns reverse of a right multiplication step' do
      step = Step.new(:mtp,5)
      reverse_step = Step.new(:div,5)
      expect(step.reverse_step).to eq reverse_step
    end

    it 'returns reverse of a left multiplication step' do
      step = Step.new(:mtp,5,:lft)
      reverse_step = Step.new(:div,5)
      expect(step.reverse_step).to eq reverse_step
    end

    it 'returns reverse of a right subtraction step' do
      step = Step.new(:sbt,5)
      reverse_step = Step.new(:add,5)
      expect(step.reverse_step).to eq reverse_step
    end

    it 'returns reverse of a left subtraction step' do
      step = Step.new(:sbt,5,:lft)
      expect(step.reverse_step).to eq step
    end

    it 'returns reverse of a right division step' do
      step = Step.new(:div,5)
      reverse_step = Step.new(:mtp,5)
      expect(step.reverse_step).to eq reverse_step
    end

    it 'returns reverse of a left division step' do
      step = Step.new(:div,5,:lft)
      expect(step.reverse_step).to eq step
    end

  end


  describe '#em_mtp_em' do
    context 'subcase of e x e' do
      let(:step_1){step_factory.build([nil,5])}
      let(:step_2){step_factory.build([:sbt,'x'])}
      let(:expected_step){step_factory.build([:sbt,[[nil,5],[:mtp,'x']]])}
      let(:result_step){step_1.em_mtp_em(step_2)}

      it 'e x e into m step' do
        expect(result_step).to eq expected_step
      end

      it 'e x e into a new object m step' do
        expect(step_1.object_id).not_to eq result_step.object_id
        expect(step_2.object_id).not_to eq result_step.object_id
      end

      it 'e x e without changing the two initial steps' do
        step_1_copy = step_1.copy
        step_2_copy = step_2.copy
        expect(step_1).to eq step_1_copy
        expect(step_2).to eq step_2_copy
      end
    end

    context 'subcase of e x m' do
      let(:step_1){step_factory.build([nil,5])}
      let(:step_2){step_factory.build([:sbt,[[nil,'x'],[:mtp,'y']]])}
      let(:expected_step){step_factory.build([:sbt,[[nil,5],[:mtp,'x'],[:mtp,'y']]])}
      let(:result_step){step_1.em_mtp_em(step_2)}

      it 'e x m into m step' do
        expect(result_step).to eq expected_step
      end

      it 'e x m into a new object m step' do
        expect(step_1.object_id).not_to eq result_step.object_id
        expect(step_2.object_id).not_to eq result_step.object_id
      end

      it 'e x m without changing the two initial steps' do
        step_1_copy = step_1.copy
        step_2_copy = step_2.copy
        expect(step_1).to eq step_1_copy
        expect(step_2).to eq step_2_copy
      end
    end

    context 'subcase of m x e' do
      let(:step_1){step_factory.build([:sbt,[[nil,'x'],[:mtp,'y']]])}
      let(:step_2){step_factory.build([:sbt,5])}
      let(:expected_step){step_factory.build([:add,[[nil,'x'],[:mtp,'y'],[:mtp,5]]])}
      let(:result_step){step_1.em_mtp_em(step_2)}

      it 'm x e into m step' do
        expect(result_step).to eq expected_step
      end

      it 'm x e into a new object m step' do
        expect(step_1.object_id).not_to eq result_step.object_id
        expect(step_2.object_id).not_to eq result_step.object_id
      end

      it 'm x e without changing the two initial steps' do
        step_1_copy = step_1.copy
        step_2_copy = step_2.copy
        expect(step_1).to eq step_1_copy
        expect(step_2).to eq step_2_copy
      end
    end

    context 'subcase of m x m' do
      let(:step_1){step_factory.build([:sbt,[[nil,5],[:mtp,'y']]])}
      let(:step_2){step_factory.build([:add,[[nil,6],[:mtp,'x']]])}
      let(:expected_step){step_factory.build([:sbt,[[nil,5],[:mtp,'y'],[:mtp,6],[:mtp,'x']]])}
      let(:result_step){step_1.em_mtp_em(step_2)}

      it 'm x e into m step' do
        expect(result_step).to eq expected_step
      end

      it 'm x e into a new object m step' do
        expect(step_1.object_id).not_to eq result_step.object_id
        expect(step_2.object_id).not_to eq result_step.object_id
      end

      it 'm x e without changing the two initial steps' do
        step_1_copy = step_1.copy
        step_2_copy = step_2.copy
        expect(step_1).to eq step_1_copy
        expect(step_2).to eq step_2_copy
      end
    end
  end

  describe '#mtp_prepare_value_as_ms' do
    it 'prepares an elementary step for multiplication by change it to ms' do
      step = step_factory.build([:mtp,7])
      expected_step = step_factory.build([:mtp,[[nil,7]]])
      expect(step.mtp_prepare_value_as_ms).to eq expected_step
    end

    it 'prepares an elementary step for mtp by mutating it' do
      step = step_factory.build([:mtp,7])
      expected_step = step_factory.build([:mtp,[[nil,7]]])
      step.mtp_prepare_value_as_ms
      expect(step).to eq expected_step
    end

    it 'parepares an expression step by expanding the exp' do
      step = step_factory.build([:mtp,[[nil,6],[:add,'x']]])
      expected_step = step_factory.build([:mtp,[[nil,6],[:add,'x']]])
      step.mtp_prepare_value_as_ms
      expect(step).to eq expected_step
    end
  end

  describe '#r_mtp_r' do
    it 'multiply two strictly rational steps together eg 1' do
      r_1 = rational_factory.build([[2,'x'],[[nil,[3,'y']],[:add,[4,'z']]]])
      r_step_1 = step_factory.build([:add,r_1])
      r_2 = rational_factory.build([[5,'a'],[[nil,[6]],[:sbt,[7]]]])
      r_step_2 = step_factory.build([:sbt,r_2])
      r_result = rational_factory.build([[2,'x',5,'a'],[[nil,[3,'y',6]],
        [:add,[4,'z',6]],[:sbt,[3,'y',7]],[:sbt,[4,'z',7]]]])
      r_step_result = step_factory.build([:sbt,r_result])
      expect(r_step_1.r_mtp_r(r_step_2)).to eq r_step_result
    end

    it 'multiply two strictly rational steps together eg 2' do
      r_1 = rational_factory.build([[2,'x','w'],[[nil,[3,'y']],
        [:add,[4,'z','p']]]])
      r_step_1 = step_factory.build([:sbt,r_1])
      r_2 = rational_factory.build([['a'],[[nil,[6]],[:sbt,[7]],[:add,['b']]]])
      r_step_2 = step_factory.build([:sbt,r_2])
      r_result = rational_factory.build([[2,'x','w','a'],[ [nil,[3,'y',6]],
        [:add,[4,'z','p',6]],[:sbt,[3,'y',7]],[:sbt,[4,'z','p',7]],
        [:add,[3,'y','b']],[:add,[4,'z','p','b']]]])
      r_step_result = step_factory.build([:add,r_result])
      expect(r_step_1.r_mtp_r(r_step_2)).to eq r_step_result
    end
  end


end
