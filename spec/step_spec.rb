require './generators/step'

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

  describe '#elementary_to_m_form' do
    it 'converts an elementary into m-form' do
      e_step = Step.new(:add,5)
      m_step = Step.new(:add,Expression.new([Step.new(nil,5)]))
      expect(e_step.elementary_to_m_form).to eq m_step
    end
  end

  describe '#at_most_m_form_to_m_form_sum' do
    it 'converts an elementary into m-form-sum' do
      e_step = Step.new(:div,5)
      m_form_sum_step = Step.new(:div,Expression.new([Step.new(nil,5)]))
      expect(e_step.at_most_m_form_to_m_form_sum).to eq m_form_sum_step
    end

    it 'converts an m-form into m-form-sum' do
      m_form = Expression.new([Step.new(nil,3),Step.new(:mtp,'x')])
      m_form_step = Step.new(:div,m_form)
      m_form_sum = Expression.new([Step.new(nil,m_form)])
      expected_step = Step.new(:div,m_form_sum)
      expect(m_form_step.at_most_m_form_to_m_form_sum).to eq expected_step
    end
  end


  describe '#result_sign' do
    it 'combines nil and nil ops to add' do
      step_1 = Step.new(nil,0)
      step_2 = Step.new(nil,0)
      expect(step_1.result_sign(step_2)).to eq :add
    end

    it 'combines nil and add ops to add' do
      step_1 = Step.new(nil,0)
      step_2 = Step.new(:add,0)
      expect(step_1.result_sign(step_2)).to eq :add
    end

    it 'combines nil and sbt ops to sbt' do
      step_1 = Step.new(nil,0)
      step_2 = Step.new(:sbt,0)
      expect(step_1.result_sign(step_2)).to eq :sbt
    end

    it 'combines add and nil ops to add' do
      step_1 = Step.new(:add,0)
      step_2 = Step.new(nil,0)
      expect(step_1.result_sign(step_2)).to eq :add
    end

    it 'combines add and add ops to add' do
      step_1 = Step.new(:add,0)
      step_2 = Step.new(:add,0)
      expect(step_1.result_sign(step_2)).to eq :add
    end

    it 'combines add and sbt ops to sbt' do
      step_1 = Step.new(:add,0)
      step_2 = Step.new(:sbt,0)
      expect(step_1.result_sign(step_2)).to eq :sbt
    end

    it 'combines sbt and nil ops to add' do
      step_1 = Step.new(:sbt,0)
      step_2 = Step.new(nil,0)
      expect(step_1.result_sign(step_2)).to eq :sbt
    end

    it 'combines sbt and add ops to add' do
      step_1 = Step.new(:sbt,0)
      step_2 = Step.new(:add,0)
      expect(step_1.result_sign(step_2)).to eq :sbt
    end

    it 'combines sbt and sbt ops to sbt' do
      step_1 = Step.new(:sbt,0)
      step_2 = Step.new(:sbt,0)
      expect(step_1.result_sign(step_2)).to eq :add
    end
  end





  describe '#elementary_or_m_step_to_m_step' do
    it 'returns equivalent m-step given an elementary step' do
      step = Step.new(:div,11)
      expected_step = Step.new(:div,Expression.new([Step.new(nil,11)]))
      expect(step.e_or_m_step_to_m_step).to eq expected_step
    end

    it 'returns self given an m-step' do
      step = Step.new(:sbt,Expression.new([Step.new(nil,'x'),Step.new(:mtp,5)]))
      expected_step = Step.new(:sbt,Expression.new([Step.new(nil,'x'),
        Step.new(:mtp,5)]))
      expect(step.e_or_m_step_to_m_step).to eq expected_step
    end
  end

  describe '#at_most_m_step_mtp_at_most_m_step' do
    it 'nil e x + e into an m_step' do
      step_1 = Step.new(nil,5)
      step_2 = Step.new(:add,'x')
      expected_step = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      expect(step_1.at_most_m_step_mtp_at_most_m_step(step_2)).to eq expected_step
    end

    it '+ e x - e into an m_step' do
      step_1 = Step.new(:add,5)
      step_2 = Step.new(:sbt,'x')
      expected_step = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      expect(step_1.at_most_m_step_mtp_at_most_m_step(step_2)).to eq expected_step
    end

    it '- e x nil e into an m_step' do
      step_1 = Step.new(:sbt,5)
      step_2 = Step.new(nil,'x')
      expected_step = Step.new(:sbt,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      expect(step_1.at_most_m_step_mtp_at_most_m_step(step_2)).to eq expected_step
    end

    it 'nil m x + m into a new m_step' do
      m_form_1 = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      m_form_2 = Expression.new([Step.new(nil,3),Step.new(:mtp,'y')])
      m_step_1 = Step.new(nil,m_form_1)
      m_step_2 = Step.new(:add,m_form_2)
      expected_m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),
        Step.new(:mtp,3),Step.new(:mtp,'y')])
      expected_step = Step.new(nil,expected_m_form)
      expect(m_step_1.at_most_m_step_mtp_at_most_m_step(m_step_2)).to eq expected_step
    end

    it '+ m x - m into a new m_step' do
      m_form_1 = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      m_form_2 = Expression.new([Step.new(nil,3),Step.new(:mtp,'y')])
      m_step_1 = Step.new(:add,m_form_1)
      m_step_2 = Step.new(:sbt,m_form_2)
      expected_m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),
        Step.new(:mtp,3),Step.new(:mtp,'y')])
      expected_step = Step.new(:add,expected_m_form)
      expect(m_step_1.at_most_m_step_mtp_at_most_m_step(m_step_2)).to eq expected_step
    end

    it 'nil m x + e into new m_step' do
      m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      m_step = Step.new(nil,m_form)
      e_step = Step.new(:add,'d')
      expected_m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),
        Step.new(:mtp,'d')])
      expected_step = Step.new(nil,expected_m_form)
      expect(m_step.at_most_m_step_mtp_at_most_m_step(e_step)).to eq expected_step
    end

    it '- m x nil e into new m_step' do
      m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      m_step = Step.new(:sbt,m_form)
      e_step = Step.new(nil,'d')
      expected_m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),
        Step.new(:mtp,'d')])
      expected_step = Step.new(:sbt,expected_m_form)
      expect(m_step.at_most_m_step_mtp_at_most_m_step(e_step)).to eq expected_step
    end

    it 'nil e x - m into new m_step' do
      e_step = Step.new(nil,'d')
      m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      m_step = Step.new(:sbt,m_form)
      expected_m_form = Expression.new([Step.new(nil,'d'),Step.new(:mtp,2),
        Step.new(:mtp,'x')])
      expected_step = Step.new(nil,expected_m_form)
      expect(e_step.at_most_m_step_mtp_at_most_m_step(m_step)).to eq expected_step
    end

    it '- e x - m into new m_step' do
      e_step = Step.new(:sbt,'d')
      m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      m_step = Step.new(:sbt,m_form)
      expected_m_form = Expression.new([Step.new(nil,'d'),Step.new(:mtp,2),
        Step.new(:mtp,'x')])
      expected_step = Step.new(:sbt,expected_m_form)
      expect(e_step.at_most_m_step_mtp_at_most_m_step(m_step)).to eq expected_step
    end

    it '+ e x nil e into an m_step' do
      step_1 = Step.new(:add,5)
      step_2 = Step.new(:nil,'x')
      expected_step = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      expect(step_1.at_most_m_step_mtp_at_most_m_step(step_2)).to eq expected_step
    end

    it '+ m x - m into a new m_step' do
      m_form_1 = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      m_form_2 = Expression.new([Step.new(nil,3),Step.new(:mtp,'y')])
      m_step_1 = Step.new(:add,m_form_1)
      m_step_2 = Step.new(:sbt,m_form_2)
      expected_m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),
        Step.new(:mtp,3),Step.new(:mtp,'y')])
      expected_step = Step.new(:add,expected_m_form)
      expect(m_step_1.at_most_m_step_mtp_at_most_m_step(m_step_2)).to eq expected_step
    end

    it '- m x - e into new m_step' do
      m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      m_step = Step.new(:sbt,m_form)
      e_step = Step.new(:sbt,'d')
      expected_m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),
        Step.new(:mtp,'d')])
      expected_step = Step.new(:sbt,expected_m_form)
      expect(m_step.at_most_m_step_mtp_at_most_m_step(e_step)).to eq expected_step
    end

    it 'nil e x - m into new m_step' do
      e_step = Step.new(nil,'d')
      m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      m_step = Step.new(:sbt,m_form)
      expected_m_form = Expression.new([Step.new(nil,'d'),Step.new(:mtp,2),
        Step.new(:mtp,'x')])
      expected_step = Step.new(nil,expected_m_form)
      expect(e_step.at_most_m_step_mtp_at_most_m_step(m_step)).to eq expected_step
    end
  end

  describe '#at_most_m_sum_mtp_at_most_m_sum' do
    it 'm x (e + e) to m_form_sum expression' do
      m_form = Expression.new([Step.new(nil,3),Step.new(:mtp,'x')])
      m_form_step = Step.new(:div,m_form)
      m_form_sum = Expression.new([Step.new(nil,'a'),Step.new(:sbt,'b')])
      m_form_sum_step = Step.new(:sbt,m_form_sum)
      expected_m_form_exp = Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,3),Step.new(:mtp,'x'),Step.new(:mtp,'a')])),
        Step.new(:sbt,Expression.new([Step.new(nil,3),Step.new(:mtp,'x'),Step.new(:mtp,'b')]))
        ])
      expect(m_form_step.at_most_m_sum_mtp_at_most_m_sum(m_form_sum_step)).to eq expected_m_form_exp
    end
  end

  describe '#to_rational' do
    it 'converts an elementary to rational' do
      e_step = Step.new(:sbt,5)
      r_step = Step.new(:sbt,Expression.new([Step.new(nil,5),Step.new(:div,1)]))
      expect(e_step.to_rational).to eq r_step
    end
    it 'converts an m-form to rational' do
      m_step = Step.new(:add,Expression.new([Step.new(nil,'x'),Step.new(:mtp,'y')]))
      r_step = Step.new(:add,Expression.new([Step.new(nil,Expression.new([
        Step.new(nil,'x'),Step.new(:mtp,'y')])),Step.new(:div,1)]))
      expect(m_step.to_rational).to eq r_step
    end
  end

  describe '#r_step_mtp_r_step' do
    it '- e x + r into new r-step' do
      e_step = Step.new(:sbt,22)
      r_step = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:div,'x')]))
      new_numerator = Step.new(nil,Expression.new([Step.new(nil,22),Step.new(:mtp,5)]))
      new_denominator = Step.new(:div,Expression.new([Step.new(nil,Expression.new([
        Step.new(nil,1),Step.new(:mtp,'x')
        ]))]))
      expected_step = Step.new(:sbt,Expression.new([new_numerator,new_denominator]))
      expect(e_step.r_step_mtp_r_step(r_step)).to eq expected_step
    end

    it '- m x nil r into new r-step' do
      m_step = Step.new(:sbt,Expression.new([Step.new(nil,3),Step.new(:mtp,'a')]))
      r_step = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:div,'x')]))
      new_numerator = Step.new(nil,Expression.new([Step.new(nil,3),
        Step.new(:mtp,'a'),Step.new(:mtp,5)]))
      new_denominator = Step.new(:div,Expression.new([Step.new(nil,Expression.new([
        Step.new(nil,1),Step.new(:mtp,'x')
        ]))]))
      expected_step = Step.new(:sbt,Expression.new([new_numerator,new_denominator]))
      expect(m_step.r_step_mtp_r_step(r_step)).to eq expected_step
    end

    it '+ r x nil e into new r-step' do
      r_step = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:div,'x')]))
      e_step = Step.new(nil,22)
      new_numerator = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,22)]))
      denominator_exp = Expression.new([Step.new(nil,Expression.new([
        Step.new(nil,'x'),Step.new(:mtp,1)]))])
      new_denominator = Step.new(:div,denominator_exp)
      expected_step = Step.new(:add,Expression.new([new_numerator,new_denominator]))
      expect(r_step.r_step_mtp_r_step(e_step)).to eq expected_step
    end

    it '- r x + m into new r-step' do
      r_step = Step.new(:sbt,Expression.new([Step.new(nil,5),Step.new(:div,'x')]))
      m_step = Step.new(:add,Expression.new([Step.new(nil,3),Step.new(:mtp,'a')]))
      new_numerator = Step.new(nil,Expression.new([Step.new(nil,5),
        Step.new(:mtp,3),Step.new(:mtp,'a')]))
      new_denominator = Step.new(:div,Expression.new([Step.new(nil,Expression.new([
        Step.new(nil,'x'),Step.new(:mtp,1)
        ]))]))
      expected_step = Step.new(:sbt,Expression.new([new_numerator,new_denominator]))
      expect(r_step.r_step_mtp_r_step(m_step)).to eq expected_step
    end

    it '+ (e/e) x (e/e) into new r-step' do
      r_step_1 = Step.new(:add,Expression.new([Step.new(nil,'x'),Step.new(:div,5)]))
      r_step_2 = Step.new(:mtp,Expression.new([Step.new(nil,3),Step.new(:div,'y')]))
      denominator_m_form = Expression.new([Step.new(nil,5),Step.new(:mtp,'y')])
      expected_r_step = Step.new(:add,Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,'x'),Step.new(:mtp,3)])),
        Step.new(:div,Expression.new([Step.new(nil,denominator_m_form)]))
        ]))
      expect(r_step_1.r_step_mtp_r_step(r_step_2)).to eq expected_r_step
    end

    it '- (m/m) x (e/ms) into new r_step' do
      m_step_1 = Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,'x')]))
      m_step_2 = Step.new(:div,Expression.new([Step.new(nil,'a'),Step.new(:mtp,'y')]))
      r_exp_1 = Expression.new([m_step_1,m_step_2])
      r_step_1 = Step.new(:sbt,r_exp_1)
      e_step = Step.new(nil,'b')
      m_step_3 = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,'c')]))
      m_step_4 = Step.new(:sbt,Expression.new([Step.new(nil,3),Step.new(:mtp,'d')]))
      m_sum_step = Step.new(:div,Expression.new([m_step_3,m_step_4]))
      r_exp_2 = Expression.new([e_step,m_sum_step])
      r_step_2 = Step.new(:mtp,r_exp_2)
      numerator_step = Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),Step.new(:mtp,'b')]))
      d_m_step_1 = Step.new(nil,Expression.new([Step.new(nil,'a'),Step.new(:mtp,'y'),Step.new(:mtp,5),Step.new(:mtp,'c')]))
      d_m_step_2 = Step.new(:sbt,Expression.new([Step.new(nil,'a'),Step.new(:mtp,'y'),Step.new(:mtp,3),Step.new(:mtp,'d')]))
      denominator_step = Step.new(:div,Expression.new([d_m_step_1,d_m_step_2]))
      expected_r_step = Step.new(:sbt,Expression.new([numerator_step,denominator_step]))
      result_step = r_step_1.r_step_mtp_r_step(r_step_2)
      expect(result_step).to eq expected_r_step
    end

    it 'nil (m/ms) x (m/ms) into new r_step' do
      m_step_1 = Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,'x')]))
      e_step_1 = Step.new(nil,6)
      m_step_2 = Step.new(:add,Expression.new([Step.new(nil,'a'),Step.new(:mtp,'y')]))
      m_sum_step_1 = Step.new(:div,Expression.new([e_step_1,m_step_2]))
      r_exp_1 = Expression.new([m_step_1,m_sum_step_1])
      r_step_1 = Step.new(nil,r_exp_1)
      m_step_3 = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,'c')]))
      e_step_2 = Step.new(nil,'b')
      m_step_4 = Step.new(:sbt,Expression.new([Step.new(nil,3),Step.new(:mtp,'d')]))
      m_sum_step_2 = Step.new(:div,Expression.new([e_step_2,m_step_4]))
      r_exp_2 = Expression.new([m_step_3,m_sum_step_2])
      r_step_2 = Step.new(:mtp,r_exp_2)
      numerator_step = Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),Step.new(:mtp,5),Step.new(:mtp,'c')]))
      d_m_step_1 = Step.new(nil,Expression.new([Step.new(nil,6),Step.new(:mtp,'b')]))
      d_m_step_2 = Step.new(:add,Expression.new([Step.new(nil,'a'),Step.new(:mtp,'y'),Step.new(:mtp,'b')]))
      d_m_step_3 = Step.new(:sbt,Expression.new([Step.new(nil,6),Step.new(:mtp,3),Step.new(:mtp,'d')]))
      d_m_step_4 = Step.new(:sbt,Expression.new([Step.new(nil,'a'),Step.new(:mtp,'y'),Step.new(:mtp,3),Step.new(:mtp,'d')]))
      denominator_step = Step.new(:div,Expression.new([d_m_step_1,d_m_step_2,d_m_step_3,d_m_step_4]))
      expected_r_step = Step.new(nil,Expression.new([numerator_step,denominator_step]))
      result_step = r_step_1.r_step_mtp_r_step(r_step_2)
      expect(result_step).to eq expected_r_step
    end
  end

  describe '#step_mtp_step - aggregated' do
    it 'nil e x + e into an m_step' do
      step_1 = Step.new(nil,5)
      step_2 = Step.new(:add,'x')
      expected_step = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      expect(step_1.step_mtp_step(step_2)).to eq expected_step
    end

    it '+ e x - e into an m_step' do
      step_1 = Step.new(:add,5)
      step_2 = Step.new(:sbt,'x')
      expected_step = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      expect(step_1.step_mtp_step(step_2)).to eq expected_step
    end

    it '- e x nil e into an m_step' do
      step_1 = Step.new(:sbt,5)
      step_2 = Step.new(nil,'x')
      expected_step = Step.new(:sbt,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      expect(step_1.step_mtp_step(step_2)).to eq expected_step
    end

    it 'nil m x + m into a new m_step' do
      m_form_1 = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      m_form_2 = Expression.new([Step.new(nil,3),Step.new(:mtp,'y')])
      m_step_1 = Step.new(nil,m_form_1)
      m_step_2 = Step.new(:add,m_form_2)
      expected_m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),
        Step.new(:mtp,3),Step.new(:mtp,'y')])
      expected_step = Step.new(nil,expected_m_form)
      expect(m_step_1.step_mtp_step(m_step_2)).to eq expected_step
    end

    it '+ m x - m into a new m_step' do
      m_form_1 = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      m_form_2 = Expression.new([Step.new(nil,3),Step.new(:mtp,'y')])
      m_step_1 = Step.new(:add,m_form_1)
      m_step_2 = Step.new(:sbt,m_form_2)
      expected_m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),
        Step.new(:mtp,3),Step.new(:mtp,'y')])
      expected_step = Step.new(:add,expected_m_form)
      expect(m_step_1.step_mtp_step(m_step_2)).to eq expected_step
    end

    it 'nil m x + e into new m_step' do
      m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      m_step = Step.new(nil,m_form)
      e_step = Step.new(:add,'d')
      expected_m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),
        Step.new(:mtp,'d')])
      expected_step = Step.new(nil,expected_m_form)
      expect(m_step.step_mtp_step(e_step)).to eq expected_step
    end

    it '- m x nil e into new m_step' do
      m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      m_step = Step.new(:sbt,m_form)
      e_step = Step.new(nil,'d')
      expected_m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),
        Step.new(:mtp,'d')])
      expected_step = Step.new(:sbt,expected_m_form)
      expect(m_step.step_mtp_step(e_step)).to eq expected_step
    end

    it 'nil e x - m into new m_step' do
      e_step = Step.new(nil,'d')
      m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      m_step = Step.new(:sbt,m_form)
      expected_m_form = Expression.new([Step.new(nil,'d'),Step.new(:mtp,2),
        Step.new(:mtp,'x')])
      expected_step = Step.new(nil,expected_m_form)
      expect(e_step.step_mtp_step(m_step)).to eq expected_step
    end

    it '- e x - m into new m_step' do
      e_step = Step.new(:sbt,'d')
      m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      m_step = Step.new(:sbt,m_form)
      expected_m_form = Expression.new([Step.new(nil,'d'),Step.new(:mtp,2),
        Step.new(:mtp,'x')])
      expected_step = Step.new(:sbt,expected_m_form)
      expect(e_step.step_mtp_step(m_step)).to eq expected_step
    end

    it '+ e x nil e into an m_step' do
      step_1 = Step.new(:add,5)
      step_2 = Step.new(:nil,'x')
      expected_step = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      expect(step_1.step_mtp_step(step_2)).to eq expected_step
    end

    it '+ m x - m into a new m_step' do
      m_form_1 = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      m_form_2 = Expression.new([Step.new(nil,3),Step.new(:mtp,'y')])
      m_step_1 = Step.new(:add,m_form_1)
      m_step_2 = Step.new(:sbt,m_form_2)
      expected_m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),
        Step.new(:mtp,3),Step.new(:mtp,'y')])
      expected_step = Step.new(:add,expected_m_form)
      expect(m_step_1.step_mtp_step(m_step_2)).to eq expected_step
    end

    it '- m x - e into new m_step' do
      m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      m_step = Step.new(:sbt,m_form)
      e_step = Step.new(:sbt,'d')
      expected_m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),
        Step.new(:mtp,'d')])
      expected_step = Step.new(:sbt,expected_m_form)
      expect(m_step.step_mtp_step(e_step)).to eq expected_step
    end

    it 'nil e x - m into new m_step' do
      e_step = Step.new(nil,'d')
      m_form = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      m_step = Step.new(:sbt,m_form)
      expected_m_form = Expression.new([Step.new(nil,'d'),Step.new(:mtp,2),
        Step.new(:mtp,'x')])
      expected_step = Step.new(nil,expected_m_form)
      expect(e_step.step_mtp_step(m_step)).to eq expected_step
    end

    it '- e x + r into new r-step' do
      e_step = Step.new(:sbt,22)
      r_step = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:div,'x')]))
      new_numerator = Step.new(nil,Expression.new([Step.new(nil,22),Step.new(:mtp,5)]))
      new_denominator = Step.new(:div,Expression.new([Step.new(nil,Expression.new([
        Step.new(nil,1),Step.new(:mtp,'x')
        ]))]))
      expected_step = Step.new(:sbt,Expression.new([new_numerator,new_denominator]))
      expect(e_step.step_mtp_step(r_step)).to eq expected_step
    end

    it '- m x nil r into new r-step' do
      m_step = Step.new(:sbt,Expression.new([Step.new(nil,3),Step.new(:mtp,'a')]))
      r_step = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:div,'x')]))
      new_numerator = Step.new(nil,Expression.new([Step.new(nil,3),
        Step.new(:mtp,'a'),Step.new(:mtp,5)]))
        new_denominator = Step.new(:div,Expression.new([Step.new(nil,Expression.new([
          Step.new(nil,1),Step.new(:mtp,'x')
          ]))]))
      expected_step = Step.new(:sbt,Expression.new([new_numerator,new_denominator]))
      expect(m_step.step_mtp_step(r_step)).to eq expected_step
    end

    it '+ r x nil e into new r-step' do
      r_step = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:div,'x')]))
      e_step = Step.new(nil,22)
      new_numerator = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,22)]))
      new_denominator = Step.new(:div,Expression.new([Step.new(nil,Expression.new([
        Step.new(nil,'x'),Step.new(:mtp,1)
        ]))]))
      expected_step = Step.new(:add,Expression.new([new_numerator,new_denominator]))
      expect(r_step.step_mtp_step(e_step)).to eq expected_step
    end

    it '- r x + m into new r-step' do
      r_step = Step.new(:sbt,Expression.new([Step.new(nil,5),Step.new(:div,'x')]))
      m_step = Step.new(:add,Expression.new([Step.new(nil,3),Step.new(:mtp,'a')]))
      new_numerator = Step.new(nil,Expression.new([Step.new(nil,5),
        Step.new(:mtp,3),Step.new(:mtp,'a')]))
        new_denominator = Step.new(:div,Expression.new([Step.new(nil,Expression.new([
          Step.new(nil,'x'),Step.new(:mtp,1)
          ]))]))
      expected_step = Step.new(:sbt,Expression.new([new_numerator,new_denominator]))
      expect(r_step.step_mtp_step(m_step)).to eq expected_step
    end

    it '+ (e/e) x (e/e) into new r-step' do
      r_step_1 = Step.new(:add,Expression.new([Step.new(nil,'x'),Step.new(:div,5)]))
      r_step_2 = Step.new(:mtp,Expression.new([Step.new(nil,3),Step.new(:div,'y')]))
      denominator_m_form = Expression.new([Step.new(nil,5),Step.new(:mtp,'y')])
      expected_r_step = Step.new(:add,Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,'x'),Step.new(:mtp,3)])),
        Step.new(:div,Expression.new([Step.new(nil,denominator_m_form)]))
        ]))
      expect(r_step_1.step_mtp_step(r_step_2)).to eq expected_r_step
    end

    it '- (m/m) x (e/ms) into new r_step' do
      m_step_1 = Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,'x')]))
      m_step_2 = Step.new(:div,Expression.new([Step.new(nil,'a'),Step.new(:mtp,'y')]))
      r_exp_1 = Expression.new([m_step_1,m_step_2])
      r_step_1 = Step.new(:sbt,r_exp_1)
      e_step = Step.new(nil,'b')
      m_step_3 = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,'c')]))
      m_step_4 = Step.new(:sbt,Expression.new([Step.new(nil,3),Step.new(:mtp,'d')]))
      m_sum_step = Step.new(:div,Expression.new([m_step_3,m_step_4]))
      r_exp_2 = Expression.new([e_step,m_sum_step])
      r_step_2 = Step.new(:mtp,r_exp_2)
      numerator_step = Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),Step.new(:mtp,'b')]))
      d_m_step_1 = Step.new(nil,Expression.new([Step.new(nil,'a'),Step.new(:mtp,'y'),Step.new(:mtp,5),Step.new(:mtp,'c')]))
      d_m_step_2 = Step.new(:sbt,Expression.new([Step.new(nil,'a'),Step.new(:mtp,'y'),Step.new(:mtp,3),Step.new(:mtp,'d')]))
      denominator_step = Step.new(:div,Expression.new([d_m_step_1,d_m_step_2]))
      expected_r_step = Step.new(:sbt,Expression.new([numerator_step,denominator_step]))
      result_step = r_step_1.step_mtp_step(r_step_2)
      expect(result_step).to eq expected_r_step
    end

    it 'nil (m/ms) x (m/ms) into new r_step' do
      m_step_1 = Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,'x')]))
      e_step_1 = Step.new(nil,6)
      m_step_2 = Step.new(:add,Expression.new([Step.new(nil,'a'),Step.new(:mtp,'y')]))
      m_sum_step_1 = Step.new(:div,Expression.new([e_step_1,m_step_2]))
      r_exp_1 = Expression.new([m_step_1,m_sum_step_1])
      r_step_1 = Step.new(nil,r_exp_1)
      m_step_3 = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,'c')]))
      e_step_2 = Step.new(nil,'b')
      m_step_4 = Step.new(:sbt,Expression.new([Step.new(nil,3),Step.new(:mtp,'d')]))
      m_sum_step_2 = Step.new(:div,Expression.new([e_step_2,m_step_4]))
      r_exp_2 = Expression.new([m_step_3,m_sum_step_2])
      r_step_2 = Step.new(:mtp,r_exp_2)
      numerator_step = Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),Step.new(:mtp,5),Step.new(:mtp,'c')]))
      d_m_step_1 = Step.new(nil,Expression.new([Step.new(nil,6),Step.new(:mtp,'b')]))
      d_m_step_2 = Step.new(:add,Expression.new([Step.new(nil,'a'),Step.new(:mtp,'y'),Step.new(:mtp,'b')]))
      d_m_step_3 = Step.new(:sbt,Expression.new([Step.new(nil,6),Step.new(:mtp,3),Step.new(:mtp,'d')]))
      d_m_step_4 = Step.new(:sbt,Expression.new([Step.new(nil,'a'),Step.new(:mtp,'y'),Step.new(:mtp,3),Step.new(:mtp,'d')]))
      denominator_step = Step.new(:div,Expression.new([d_m_step_1,d_m_step_2,d_m_step_3,d_m_step_4]))
      expected_r_step = Step.new(nil,Expression.new([numerator_step,denominator_step]))
      result_step = r_step_1.step_mtp_step(r_step_2)
      expect(result_step).to eq expected_r_step
    end
  end

  describe '#at_most_rational_add_at_most_rational' do
    it 'e + e/e into (m + e)/e' do
      step_1 = Step.new(nil,3)
      step_2 = Step.new(:add,Expression.new([Step.new(nil,4),Step.new(:div,5)]))
      numerator_step = Step.new(nil,Expression.new([Step.new(nil,Expression.new([
        Step.new(nil,3),Step.new(:mtp,5)])),Step.new(:add,Expression.new([
        Step.new(nil,4),Step.new(:mtp,1)]))]))
      denominator_step = Step.new(:div,Expression.new([Step.new(nil,Expression.new([Step.new(nil,1),Step.new(:mtp,5)]))]))
      expected_r_step = Step.new(nil,Expression.new([numerator_step,denominator_step]))
      result = step_1.at_most_rational_add_at_most_rational(step_2)
      expect(result).to eq expected_r_step
    end

    it 'e/e - e/e into (m - m)/m' do
      r_step_1 = Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:div,'x')]))
      r_step_2 = Step.new(:sbt,Expression.new([Step.new(nil,'y'),Step.new(:div,5)]))
      numerator_step = Step.new(nil,Expression.new([Step.new(nil,Expression.new([
        Step.new(nil,2),Step.new(:mtp,5)])),Step.new(:sbt,Expression.new([
        Step.new(nil,'y'),Step.new(:mtp,'x')]))]))
      denominator_step = Step.new(:div,Expression.new([Step.new(nil,Expression.new([Step.new(nil,'x'),Step.new(:mtp,5)]))]))
      expected_r_step = Step.new(nil,Expression.new([numerator_step,denominator_step]))
      result = r_step_1.at_most_rational_add_at_most_rational(r_step_2)
      expect(result).to eq expected_r_step
    end

    it 'e/ms + m/ms into (m + m)/m' do
      r_step_1 = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:div,
        Expression.new([Step.new(nil,'x'),Step.new(:sbt,4)])
        )]))
      r_step_2 = Step.new(:add,Expression.new([Step.new(nil,
        Expression.new([Step.new(nil,6),Step.new(:mtp,'b')])),Step.new(:div,
        Expression.new([Step.new(nil,'y'),Step.new(:add,Expression.new([Step.new(nil,'e'),Step.new(:mtp,'f')]))])
        )]))
      numerator_step = Step.new(nil,Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,'y')])),
        Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'e'),Step.new(:mtp,'f')])),
        Step.new(:add,Expression.new([Step.new(nil,6),Step.new(:mtp,'b'),Step.new(:mtp,'x')])),
        Step.new(:sbt,Expression.new([Step.new(nil,6),Step.new(:mtp,'b'),Step.new(:mtp,4)]))
        ]))
      denominator_step = Step.new(:div,Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,'x'),Step.new(:mtp,'y')])),
        Step.new(:sbt,Expression.new([Step.new(nil,4),Step.new(:mtp,'y')])),
        Step.new(:add,Expression.new([Step.new(nil,'x'),Step.new(:mtp,'e'),Step.new(:mtp,'f')])),
        Step.new(:sbt,Expression.new([Step.new(nil,4),Step.new(:mtp,'e'),Step.new(:mtp,'f')]))
        ]))
      expected_r_step = Step.new(nil,Expression.new([numerator_step,denominator_step]))
      result = r_step_1.at_most_rational_add_at_most_rational(r_step_2)
      expect(result).to eq expected_r_step
    end
  end

  describe '#nil_step_latex' do
    it 'returns latex for e numerical step' do
      step = Step.new(nil,5)
      expect(step.nil_step_latex).to eq '5'
    end

    it 'returns latex for e string value step' do
      step = Step.new(nil,'x')
      expect(step.nil_step_latex).to eq 'x'
    end

    it 'returns latex for m-form step' do
      step = Step.new(nil,Expression.new([Step.new(nil,6),Step.new(:mtp,'a')]))
      expect(step.nil_step_latex).to eq '6a'
    end

    it 'returns latex for m-form-sum (e + e) step' do
      step = Step.new(nil,Expression.new([Step.new(nil,6),Step.new(:add,'a')]))
      expect(step.nil_step_latex).to eq '6+a'
    end

    it 'returns latex for m-form-sum (e - m + m) step' do
      step = Step.new(nil,Expression.new([
        Step.new(nil,6),
        Step.new(:sbt,
          Expression.new([Step.new(nil,2),Step.new(:mtp,'a')])
        ),
        Step.new(:add,
          Expression.new([Step.new(nil,5),Step.new(:mtp,'x')])
        )]))
      expect(step.nil_step_latex).to eq '6-2a+5x'
    end

    it 'returns latex for rational m /(m - e) step' do
      rational = Expression.new([
        Step.new(nil,
          Expression.new([
            Step.new(nil,3),Step.new(:mtp,'x'),Step.new(:mtp,'y')])
        ),
        Step.new(:div,
          Expression.new([
            Step.new(nil,Expression.new([
              Step.new(nil,2),Step.new(:mtp,'a'),Step.new(:mtp,'b')
              ])
            ),
            Step.new(:sbt,5)
          ])
        )
      ])
      step = Step.new(nil,rational)
      expect(step.nil_step_latex).to eq '\frac{3xy}{2ab-5}'
    end

    it 'returns latex for other type of step value' do
      step_value = Expression.new([Step.new(nil,Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,'x')]))]))])
      step = Step.new(nil,step_value)
      allow(step_value).to receive(:latex).and_return('returned latex')
      expect(step.nil_step_latex).to eq 'returned latex'
    end
  end

  describe '#add_or_sbt_rgt_step_latex' do
    it 'adds latex for + e numerical step' do
      step = Step.new(:add,2)
      expected_latex = '+2'
      expect(step.add_or_sbt_rgt_step_latex).to eq expected_latex
    end

    it 'adds latex for - e string valued step' do
      step = Step.new(:sbt,'x')
      expected_latex = '-x'
      expect(step.add_or_sbt_rgt_step_latex).to eq expected_latex
    end

    it 'adds latex for + m step' do
      step = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      expected_latex = '+5x'
      expect(step.add_or_sbt_rgt_step_latex).to eq expected_latex
    end

    it 'adds latex for + m step with two consecutive number factors' do
      step = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,6)]))
      expected_latex = '+5\times6'
      expect(step.add_or_sbt_rgt_step_latex).to eq expected_latex
    end

    it 'adds latex for - m step' do
      step = Step.new(:sbt,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      expected_latex = '-5x'
      expect(step.add_or_sbt_rgt_step_latex).to eq expected_latex
    end

    it 'adds latex for + (e + e) step' do
      step = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:add,'x')]))
      expected_latex = '+\left(5+x\right)'
      expect(step.add_or_sbt_rgt_step_latex).to eq expected_latex
    end

    it 'adds latex for - (e) step' do
      step = Step.new(:sbt,Expression.new([Step.new(nil,'x')]))
      expected_latex = '-x'
      expect(step.add_or_sbt_rgt_step_latex).to eq expected_latex
    end

    it 'adds latex for for + (e + m) step' do
      step = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:add,
          Expression.new([Step.new(nil,4),Step.new(:mtp,'a')])
        )]))
      expected_latex = '+\left(5+4a\right)'
      expect(step.add_or_sbt_rgt_step_latex).to eq expected_latex
    end

    it 'adds latex for - e/e step' do
      step = Step.new(:sbt,Expression.new([Step.new(nil,5),Step.new(:div,'x')]))
      expected_latex = '-\frac{5}{x}'
      expect(step.add_or_sbt_rgt_step_latex).to eq expected_latex
    end

    it 'adds latex for + m/(m-e) step' do
      rational = Expression.new([
        Step.new(nil,
          Expression.new([
            Step.new(nil,3),Step.new(:mtp,'x'),Step.new(:mtp,'y')])
        ),
        Step.new(:div,
          Expression.new([
            Step.new(nil,Expression.new([
              Step.new(nil,2),Step.new(:mtp,'a'),Step.new(:mtp,'b')
              ])
            ),
            Step.new(:sbt,5)
          ])
        )
      ])
      step = Step.new(:add,rational)
      expected_latex = '+\frac{3xy}{2ab-5}'
      expect(step.add_or_sbt_rgt_step_latex).to eq expected_latex
    end

    it 'adds latex for + non-standard-expression step' do
      step_value = Expression.new([Step.new(nil,Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,'x')]))]))])
      step = Step.new(:add,step_value)
      allow(step_value).to receive(:latex).and_return('returned latex')
      expect(step.add_or_sbt_rgt_step_latex).to eq '+\left(returned latex\right)'
    end

    it 'adds latex for + non-standard-expression step' do
      step_value = Expression.new([Step.new(nil,Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,'x')]))]))])
      step = Step.new(:sbt,step_value)
      allow(step_value).to receive(:latex).and_return('returned latex')
      expect(step.add_or_sbt_rgt_step_latex).to eq '-\left(returned latex\right)'
    end
  end

  describe '#is_proper_sum?' do
    it 'returns true for a sum of 2 terms' do
      expression = Expression.new([Step.new(nil,3),Step.new(:sbt,5)])
      step = Step.new(:add,expression)
      expect(step.is_proper_sum?).to be true
    end

    it 'returns false for a non sum' do
      expression = Expression.new([Step.new(nil,3),Step.new(:mtp,5)])
      step = Step.new(:add,expression)
      expect(step.is_proper_sum?).to be false
    end

    it 'returns false for a sum of 1 term' do
      expression = Expression.new([Step.new(nil,3)])
      step = Step.new(:add,expression)
      expect(step.is_proper_sum?).to be false
    end

    it 'returns false for elementary step' do
      step = Step.new(:sbt,'x')
      expect(step.is_proper_sum?).to be false
    end
  end

  describe '#is_non_standard?' do
    it 'returns false for elementary step' do
      step = Step.new(:add,'x')
      expect(step.is_non_standard?).to be false
    end

    it 'returns false for m-form step' do
      step = Step.new(nil,
        Expression.new([
          Step.new(nil,3),Step.new(:mtp,'x'),Step.new(:mtp,'y')])
      )
      expect(step.is_non_standard?).to be false
    end

    it 'returns false for m-form-sum step' do
      step = Step.new(:div,
        Expression.new([
          Step.new(nil,Expression.new([
            Step.new(nil,2),Step.new(:mtp,'a'),Step.new(:mtp,'b')
            ])
          ),
          Step.new(:sbt,5)
        ])
      )
      expect(step.is_non_standard?).to be false
    end

    it 'returns false for rational step' do
      rational = Expression.new([
        Step.new(nil,
          Expression.new([
            Step.new(nil,3),Step.new(:mtp,'x'),Step.new(:mtp,'y')])
        ),
        Step.new(:div,
          Expression.new([
            Step.new(nil,Expression.new([
              Step.new(nil,2),Step.new(:mtp,'a'),Step.new(:mtp,'b')
              ])
            ),
            Step.new(:sbt,5)
          ])
        )
      ])
      step = Step.new(:add,rational)
      expect(step.is_non_standard?).to be false
    end

    it 'returns true for rational_sum step' do
      rational_1 = Expression.new([
        Step.new(nil,
          Expression.new([
            Step.new(nil,3),Step.new(:mtp,'x'),Step.new(:mtp,'y')])
        ),
        Step.new(:div,
          Expression.new([
            Step.new(nil,Expression.new([
              Step.new(nil,2),Step.new(:mtp,'a'),Step.new(:mtp,'b')
              ])
            ),
            Step.new(:sbt,5)
          ])
        )
      ])
      step_1 = Step.new(nil,rational_1)
      step_2 = Step.new(:add,'x')
      step = Step.new(:sbt,Expression.new([step_1,step_2]))
      expect(step.is_non_standard?).to be true
    end

    it 'returns true for other types of steps' do
      step_value = Expression.new([Step.new(nil,Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,'x')]))]))])
      step = Step.new(:sbt,step_value)
      expect(step.is_non_standard?).to be true
    end
  end

  describe '#add_or_sbt_lft_step_latex' do
    it 'adds latex for left addition where current steps form m-form' do
      previous_steps = [Step.new(nil,5),Step.new(:mtp,'x')]
      step = Step.new(:add,'a',:lft)
      current_latex = '5x'
      expected_latex = 'a+5x'
      expect(step.add_or_sbt_lft_step_latex(current_latex,previous_steps)).to eq expected_latex
    end

    it 'adds latex for left subtraction where current steps form 2 step m-form-sum' do
      previous_steps = [Step.new(nil,5),Step.new(:add,'x')]
      step = Step.new(:sbt,'a',:lft)
      current_latex = '5+x'
      expected_latex = 'a-\left(5+x\right)'
      expect(step.add_or_sbt_lft_step_latex(current_latex,previous_steps)).to eq expected_latex
    end

    it 'adds latex for left subtraction where current steps form 1 step m-form-sum' do
      previous_steps = [Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,'x')]))]
      step = Step.new(:sbt,'b',:lft)
      current_latex = '2x'
      expected_latex = 'b-2x'
      expect(step.add_or_sbt_lft_step_latex(current_latex,previous_steps)).to eq expected_latex
    end
  end

  describe '#mtp_step_latex' do
    it 'adds latex for left mtp by an n-elementary to an n-elementary' do
      previous_steps = [Step.new(nil,5)]
      step = Step.new(:mtp,7,:lft)
      current_latex = '5'
      expected_latex = '7\times5'
      expect(step.mtp_step_latex(current_latex,previous_steps)).to eq expected_latex
    end

    it 'adds latex for right mtp by an n-elementary to an n-elementary' do
      previous_steps = [Step.new(nil,5)]
      step = Step.new(:mtp,7,:rgt)
      current_latex = '5'
      expected_latex = '5\times7'
      expect(step.mtp_step_latex(current_latex,previous_steps)).to eq expected_latex
    end

    it 'adds latex for left mtp by an m-form to an m-form' do
      previous_steps = [Step.new(nil,5)]
      step = Step.new(:mtp,Expression.new([Step.new(nil,2),Step.new(:mtp,'x')]),:lft)
      current_latex = '5'
      expected_latex = '2x5'
      expect(step.mtp_step_latex(current_latex,previous_steps)).to eq expected_latex
    end

    it 'adds latex for right mtp by an m-form to an m-form' do
      previous_steps = [Step.new(nil,5)]
      step = Step.new(:mtp,Expression.new([Step.new(nil,2),Step.new(:mtp,'x')]),:rgt)
      current_latex = '5'
      expected_latex = '5\times2x'
      expect(step.mtp_step_latex(current_latex,previous_steps)).to eq expected_latex
    end

    it 'adds latex for left mtp by an m-form to an m-form-sum of one step eg 1' do
      previous_steps = [Step.new(nil,Expression.new([Step.new(nil,5)]))]
      step = Step.new(:mtp,Expression.new([Step.new(nil,'x'),Step.new(:mtp,2)]),:lft)
      current_latex = '5'
      expected_latex = 'x2\times5'
      expect(step.mtp_step_latex(current_latex,previous_steps)).to eq expected_latex
    end

    it 'adds latex for right mtp by an m-form to an m-form-sum of one step eg 1' do
      previous_steps = [Step.new(nil,Expression.new([Step.new(nil,5)]))]
      step = Step.new(:mtp,Expression.new([Step.new(nil,'x'),Step.new(:mtp,2)]),:rgt)
      current_latex = '5'
      expected_latex = '5x2'
      expect(step.mtp_step_latex(current_latex,previous_steps)).to eq expected_latex
    end

    it 'adds latex for left mtp by an m-form to an m-form-sum of one step eg 2' do
      previous_steps = [Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,7)]))]
      step = Step.new(:mtp,Expression.new([Step.new(nil,3),Step.new(:mtp,2)]),:lft)
      current_latex = '5\times7'
      expected_latex = '3\times2\times5\times7'
      expect(step.mtp_step_latex(current_latex,previous_steps)).to eq expected_latex
    end

    it 'adds latex for right mtp by an m-form to an m-form-sum of one step eg 2' do
      previous_steps = [Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,7)]))]
      step = Step.new(:mtp,Expression.new([Step.new(nil,3),Step.new(:mtp,2)]),:rgt)
      current_latex = '5\times7'
      expected_latex = '5\times7\times3\times2'
      expect(step.mtp_step_latex(current_latex,previous_steps)).to eq expected_latex
    end

    it 'adds latex for left mtp by a rational to an m-form-sum of two steps' do
      previous_steps = [Step.new(nil,5),Step.new(:sbt,Expression.new([Step.new(nil,2),Step.new(:mtp,'x')]))]
      step = Step.new(:mtp,Expression.new([Step.new(nil,'y'),Step.new(:div,4)]),:lft)
      current_latex = '5-2x'
      expected_latex = '\frac{y}{4}\left(5-2x\right)'
      expect(step.mtp_step_latex(current_latex,previous_steps)).to eq expected_latex
    end

    it 'adds latex for right mtp by a rational to an m-form-sum of two steps' do
      previous_steps = [Step.new(nil,5),Step.new(:sbt,Expression.new([Step.new(nil,2),Step.new(:mtp,'x')]))]
      step = Step.new(:mtp,Expression.new([Step.new(nil,'y'),Step.new(:div,4)]),:rgt)
      current_latex = '5-2x'
      expected_latex = '\left(5-2x\right)\frac{y}{4}'
      expect(step.mtp_step_latex(current_latex,previous_steps)).to eq expected_latex
    end

    it 'adds latex for left mtp by a rational to a rational-sum of two steps' do
      previous_steps = [Step.new(nil,5),Step.new(:sbt,Expression.new([Step.new(nil,2),Step.new(:div,'x')]))]
      step = Step.new(:mtp,Expression.new([Step.new(nil,'y'),Step.new(:div,4)]),:lft)
      current_latex = '5-\frac{2}{x}'
      expected_latex = '\frac{y}{4}\left(5-\frac{2}{x}\right)'
      expect(step.mtp_step_latex(current_latex,previous_steps)).to eq expected_latex
    end

    it 'adds latex for right mtp by a rational to a rational-sum of two steps' do
      previous_steps = [Step.new(nil,5),Step.new(:sbt,Expression.new([Step.new(nil,2),Step.new(:div,'x')]))]
      step = Step.new(:mtp,Expression.new([Step.new(nil,'y'),Step.new(:div,4)]),:rgt)
      current_latex = '5-\frac{2}{x}'
      expected_latex = '\left(5-\frac{2}{x}\right)\frac{y}{4}'
      expect(step.mtp_step_latex(current_latex,previous_steps)).to eq expected_latex
    end

    it 'adds latex for left mtp by a non-standard to a rational-sum of two steps' do
      previous_steps = [Step.new(nil,5),Step.new(:sbt,Expression.new([Step.new(nil,2),Step.new(:div,'x')]))]
      step_value = Expression.new([Step.new(nil,Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,'x')]))]))])
      step = Step.new(:mtp,step_value,:lft)
      allow(step_value).to receive(:latex).and_return('returned latex')
      current_latex = '5-\frac{2}{x}'
      expected_latex = '\left(returned latex\right)\left(5-\frac{2}{x}\right)'
      expect(step.mtp_step_latex(current_latex,previous_steps)).to eq expected_latex
    end

    it 'adds latex for right mtp by a non-standard to a rational-sum of two steps' do
      previous_steps = [Step.new(nil,5),Step.new(:sbt,Expression.new([Step.new(nil,2),Step.new(:div,'x')]))]
      step_value = Expression.new([Step.new(nil,Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,'x')]))]))])
      step = Step.new(:mtp,step_value,:rgt)
      allow(step_value).to receive(:latex).and_return('returned latex')
      current_latex = '5-\frac{2}{x}'
      expected_latex = '\left(5-\frac{2}{x}\right)\left(returned latex\right)'
      expect(step.mtp_step_latex(current_latex,previous_steps)).to eq expected_latex
    end
  end

  describe '#div_step_latex' do
    it 'adds latex for left div by an m-form to m-form-sum' do
      previous_steps = [Step.new(nil,5),Step.new(:sbt,Expression.new([Step.new(nil,2),Step.new(:mtp,'x')]))]
      step = Step.new(:div,Expression.new([Step.new(nil,4),Step.new(:mtp,'y')]),:lft)
      current_latex = '5-2x'
      expected_latex = '\frac{4y}{5-2x}'
      expect(step.div_step_latex(current_latex,previous_steps)).to eq expected_latex
    end

    it 'adds latex for right div by an m-form to m-form-sum' do
      previous_steps = [Step.new(nil,5),Step.new(:sbt,Expression.new([Step.new(nil,2),Step.new(:mtp,'x')]))]
      step = Step.new(:div,Expression.new([Step.new(nil,4),Step.new(:mtp,'y')]),:rgt)
      current_latex = '5-2x'
      expected_latex = '\frac{5-2x}{4y}'
      expect(step.div_step_latex(current_latex,previous_steps)).to eq expected_latex
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


end
