require './models/expression'


describe Expression do
  describe '#initialize/new' do
    let(:expression){described_class.new()}

    it 'has with an array of equation-steps' do
      expect(expression.steps).to eq []
    end
  end

  describe '#==' do
    it 'asserts equality when all steps are equal' do
      expression1 = Expression.new([Step.new(:add,5,:lft),Step.new(:mtp,'x')])
      expression2 = Expression.new([Step.new(:add,5,:lft),Step.new(:mtp,'x')])
      expect(expression1).to eq expression2
    end

    it 'asserts inequality when at not all steps are equal' do
      expression1 = Expression.new([Step.new(:add,5),Step.new(:mtp,'x')])
      expression2 = Expression.new([Step.new(:add,5,:lft),Step.new(:mtp,'x')])
      expect(expression1).not_to eq expression2
    end

    it 'returns false when compared expression is not an expression' do |variable|
      expression1 = Expression.new([Step.new(:add,5),Step.new(:mtp,'x')])
      expression2 = 'not an expression'
      expect(expression1).not_to eq expression2
    end
  end

  describe '#copy' do
    context 'making a copy of self with simple steps' do
      shared_context 'self copy' do
        before(:all) do
          @step_1 = Step.new(:add,5,:lft)
          @step_2 = Step.new(:sbt,7)
          @expression = Expression.new([@step_1,@step_2])
          @expression_copy = @expression.copy
        end
      end

      include_context 'self copy'

      it 'returns an instance of the class with same states' do
        expect(@expression).to eq @expression_copy
      end

      it 'returns a different instance of the class with same states' do
        expect(@expression.object_id).not_to eq @expression_copy.object_id
      end
    end

    context 'making a copy of self steps contain expression values' do
      shared_context 'self copy 2' do
        before(:all) do
          @step_1 = Step.new(:add,Expression.new([Step.new(:mtp,'x')]),:lft)
          @step_2 = Step.new(:sbt,7)
          @expression = Expression.new([@step_1,@step_2])
          @expression_copy = @expression.copy
        end
      end

      include_context 'self copy 2'

      it 'returns an instance of the class with same states' do
        expect(@expression).to eq @expression_copy
      end

      it 'returns a different instance of the class with same states' do
        expect(@expression.object_id).not_to eq @expression_copy.object_id
      end

      it 'returns a different instance of the value expressions' do
        exp_1_id = @expression.steps.first.val.object_id
        exp_1_copy_id = @expression_copy.steps.first.val.object_id
        expect(exp_1_id).not_to eq exp_1_copy_id
      end
    end
  end

  describe '#is_m_form?' do
    it 'returns false for an empty expression' do
      expression = Expression.new()
      expect(expression.is_m_form?).to be false
    end

    it 'return true for expression with only elementary m steps' do
      expression = Expression.new([Step.new(nil,5),Step.new(:mtp,'x')])
      expect(expression.is_m_form?).to be true
    end

    it 'returns false if a step value is an Expression' do
      expression = Expression.new([Step.new(nil,Expression.new()),Step.new(:mtp,'x')])
      expect(expression.is_m_form?).to be false
    end

    it 'returns false if a step ops is addition' do
      expression = Expression.new([Step.new(nil,5),Step.new(:add,'x')])
      expect(expression.is_m_form?).to be false
    end

    it 'returns false if a step ops is subtraction' do
      expression = Expression.new([Step.new(nil,5),Step.new(:sbt,'x')])
      expect(expression.is_m_form?).to be false
    end

    it 'returns false if a step ops is division' do
      expression = Expression.new([Step.new(nil,5),Step.new(:div,'x')])
      expect(expression.is_m_form?).to be false
    end

    it 'returns true with multiple elementary m steps' do
      expression = Expression.new([Step.new(nil,5),Step.new(:mtp,'x'),
        Step.new(:mtp,3),Step.new(:mtp,'y')])
      expect(expression.is_m_form?).to be true
    end
  end

  describe '#is_m_form_sum?' do
    it 'returns true for empty expression' do
      expression = Expression.new()
      expect(expression.is_m_form_sum?).to be true
    end

    it 'returns true for expression with only initial elementary step' do
      step1 = Step.new(nil,3)
      expression = Expression.new([step1])
      expect(expression.is_m_form_sum?).to be true
    end

    it 'returns true for expression with only initial m_form step' do
      step1 = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      expression = Expression.new([step1])
      expect(expression.is_m_form_sum?).to be true
    end

    it 'returns true for a sum of m-form or elementary steps' do
      step1 = Step.new(nil,3)
      step2 = Step.new(:sbt,'x')
      step3 = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      step4 = Step.new(:add,Expression.new([Step.new(nil,'y')]))
      expression = Expression.new([step1,step2,step3,step4])
      expect(expression.is_m_form_sum?).to be true
    end

    it 'returns false when one of the steps is multiply' do
      step1 = Step.new(nil,3)
      step2 = Step.new(:mtp,'x')
      step3 = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      step4 = Step.new(:add,Expression.new([Step.new(nil,'y')]))
      expression = Expression.new([step1,step2,step3,step4])
      expect(expression.is_m_form_sum?).to be false
    end

    it 'returns false when one of the steps is divide' do
      step1 = Step.new(nil,3)
      step2 = Step.new(:div,'x')
      step3 = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      step4 = Step.new(:add,Expression.new([Step.new(nil,'y')]))
      expression = Expression.new([step1,step2,step3,step4])
      expect(expression.is_m_form_sum?).to be false
    end

    it 'returns false when one step is left addition' do
      step1 = Step.new(nil,3)
      step2 = Step.new(:sbt,'x')
      step3 = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      step4 = Step.new(:add,Expression.new([Step.new(nil,'y')]),:lft)
      expression = Expression.new([step1,step2,step3,step4])
      expect(expression.is_m_form_sum?).to be false
    end

    it 'returns false when one step is left subtraction' do
      step1 = Step.new(nil,3)
      step2 = Step.new(:sbt,'x')
      step3 = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      step4 = Step.new(:sbt,Expression.new([Step.new(nil,'y')]),:lft)
      expression = Expression.new([step1,step2,step3,step4])
      expect(expression.is_m_form_sum?).to be false
    end

    it 'returns false when one of the steps is not elementary or m-form' do
      step1 = Step.new(nil,3)
      step2 = Step.new(:sbt,'x')
      step3 = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      step4 = Step.new(:add,Expression.new([Step.new(nil,Expression.new())]))
      expression = Expression.new([step1,step2,step3,step4])
      expect(expression.is_m_form_sum?).to be false
    end
  end

  describe '#is_rational?' do
    it 'is true for elementary initial step divide by elmentary step' do
      step_first = Step.new(nil,4)
      step_last = Step.new(:div,'x')
      expression = Expression.new([step_first,step_last])
      expect(expression.is_rational?).to be true
    end

    it 'is true for elementary initial step divide by m-form step' do
      step_first = Step.new(nil,4)
      m_form = Expression.new([Step.new(nil,5),Step.new(:mtp,'x')])
      step_last = Step.new(:div,m_form)
      expression = Expression.new([step_first,step_last])
      expect(expression.is_rational?).to be true
    end

    it 'is true for elementary initial step divide by m-form-sum step' do
      step_first = Step.new(nil,4)
      step1 = Step.new(nil,3)
      step2 = Step.new(:sbt,'x')
      step3 = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      step4 = Step.new(:add,Expression.new([Step.new(nil,'y')]))
      m_form_sum = Expression.new([step1,step2,step3,step4])
      step_last = Step.new(:div,m_form_sum)
      expression = Expression.new([step_first,step_last])
      expect(expression.is_rational?).to be true
    end

    it 'is true for m-form initial step divide by elementary step' do
      m_form_top = Expression.new([Step.new(nil,5),Step.new(:mtp,'x')])
      step_first = Step.new(nil,m_form_top)
      step_last = Step.new(:div,'x')
      expression = Expression.new([step_first,step_last])
      expect(expression.is_rational?).to be true
    end

    it 'is true for m-form initial step divide by m-form step' do
      m_form_top = Expression.new([Step.new(nil,5),Step.new(:mtp,'x')])
      step_first = Step.new(nil,m_form_top)
      m_form_bot = Expression.new([Step.new(nil,5),Step.new(:mtp,'x')])
      step_last = Step.new(:div,m_form_bot)
      expression = Expression.new([step_first,step_last])
      expect(expression.is_rational?).to be true
    end

    it 'is true for m-form initial step divide by m-form-sum step' do
      m_form_top = Expression.new([Step.new(nil,5),Step.new(:mtp,'x')])
      step_first = Step.new(nil,m_form_top)
      step1 = Step.new(nil,3)
      step2 = Step.new(:sbt,'x')
      step3 = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      step4 = Step.new(:add,Expression.new([Step.new(nil,'y')]))
      m_form_sum = Expression.new([step1,step2,step3,step4])
      step_last = Step.new(:div,m_form_sum)
      expression = Expression.new([step_first,step_last])
      expect(expression.is_rational?).to be true
    end

    it 'returns false if more than 2 steps' do
      expression = Expression.new([Step.new(nil,5),Step.new(:div,'x'),
        Step.new(:div,'x')])
      expect(expression.is_rational?).to be false
    end

    it 'returns false if more than second step is not divide' do
      expression = Expression.new([Step.new(nil,5),Step.new(:add,'x')])
      expect(expression.is_rational?).to be false
    end

    it 'returns false if more than second step is not right divide' do
      expression = Expression.new([Step.new(nil,5),Step.new(:div,'x',:lft)])
      expect(expression.is_rational?).to be false
    end

    it 'returns false if first step is not elementary or m-form' do
      expression = Expression.new([Step.new(nil,Expression.new([
        Step.new(:add,Expression.new())])),Step.new(:div,'x')])
      expect(expression.is_rational?).to be false
    end

    it 'returns false if last step is not elementary or m-form or m-form-sum' do
      step1 = Step.new(:add,6)
      step2 = Step.new(:sbt,'x')
      not_m_form_sum = Expression.new([Step.new(nil,Expression.new([]))])
      expression = Expression.new([Step.new(nil,2),Step.new(:div,not_m_form_sum)])
      expect(expression.is_rational?).to be false
    end
  end

  describe '#is_rational_sum' do
    it 'returns true for set of empty steps' do
      expression = Expression.new()
      expect(expression.is_rational_sum?).to be true
    end

    it 'returns true for a sum of elementaries' do
      step1 = Step.new(nil,5)
      step2 = Step.new(:add,'x')
      expression = Expression.new([step1,step2])
      expect(expression.is_rational_sum?).to be true
    end

    it 'returns true for a sum of m-forms' do
      exp1 = Expression.new([Step.new(nil,5),Step.new(:mtp,'x'),
        Step.new(:mtp,3),Step.new(:mtp,'y')])
      step1 = Step.new(nil,exp1)
      exp2 = Expression.new([Step.new(nil,5),Step.new(:mtp,7),
        Step.new(:mtp,'d'),Step.new(:mtp,'a')])
      step2 = Step.new(:sbt,exp2)
      expression = Expression.new([step1,step2])
      expect(expression.is_rational_sum?).to be true
    end

    it 'returns true for a sum of elementaries and m-forms' do
      exp1 = Expression.new([Step.new(nil,5),Step.new(:mtp,'x'),
        Step.new(:mtp,3),Step.new(:mtp,'y')])
      step1 = Step.new(nil,exp1)
      exp2 = Expression.new([Step.new(nil,5),Step.new(:mtp,7),
        Step.new(:mtp,'d'),Step.new(:mtp,'a')])
      step2 = Step.new(:add,exp2)
      step3 = Step.new(:sbt,5)
      expression = Expression.new([step1,step2,step3])
      expect(expression.is_rational_sum?).to be true
    end

    it 'returns true for a sum of rationals' do
      m_form_top = Expression.new([Step.new(nil,5),Step.new(:mtp,'x')])
      step_first = Step.new(nil,m_form_top)
      step1 = Step.new(nil,3)
      step2 = Step.new(:sbt,'x')
      step3 = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      step4 = Step.new(:add,Expression.new([Step.new(nil,'y')]))
      m_form_sum = Expression.new([step1,step2,step3,step4])
      step_last = Step.new(:div,m_form_sum)
      rational1 = Expression.new([step_first,step_last])
      rational2_top = Step.new(nil,'x')
      rational2_bot = Step.new(:div,'y')
      rational2 = Expression.new([rational2_top,rational2_bot])
      expression = Expression.new([Step.new(nil,rational1),Step.new(:add,rational2)])
      expect(expression.is_rational_sum?).to be true
    end

    it 'returns true for a sum of elementaries m-forms and rationals' do
      rational_top = Step.new(nil,'x')
      rational_bot = Step.new(:div,'y')
      rational = Expression.new([rational_top,rational_bot])
      rational_step = Step.new(nil,rational)
      elementary_step = Step.new(:add,5)
      m_form_step = Step.new(:sbt,Expression.new([Step.new(nil,3),Step.new(:mtp,'x')]))
      expression = Expression.new([rational_step,elementary_step,m_form_step])
      expect(expression.is_rational_sum?).to be true
    end

    it 'returns false for a sum involving a left addition' do
      rational_top = Step.new(nil,'x')
      rational_bot = Step.new(:div,'y')
      rational = Expression.new([rational_top,rational_bot])
      rational_step = Step.new(nil,rational)
      elementary_step = Step.new(:add,5,:lft)
      m_form_step = Step.new(:sbt,Expression.new([Step.new(nil,3),Step.new(:mtp,'x')]))
      expression = Expression.new([rational_step,elementary_step,m_form_step])
      expect(expression.is_rational_sum?).to be false
    end

    it 'returns false for a sum involving a left subtraction' do
      rational_top = Step.new(nil,'x')
      rational_bot = Step.new(:div,'y')
      rational = Expression.new([rational_top,rational_bot])
      rational_step = Step.new(nil,rational)
      elementary_step = Step.new(:add,5)
      m_form_step = Step.new(:sbt,Expression.new([Step.new(nil,3),Step.new(:mtp,'x')]),:lft)
      expression = Expression.new([rational_step,elementary_step,m_form_step])
      expect(expression.is_rational_sum?).to be false
    end
  end

  describe 'convert_lft_add_mtp_steps' do
    it 'converts all left addition steps to right addition steps' do
      expression = Expression.new([Step.new(:add,5,:lft),Step.new(:add,'x',:lft)])
      expected_expression = Expression.new([Step.new(:add,5),Step.new(:add,'x')])
      expect(expression.convert_lft_add_mtp_steps).to eq expected_expression
    end

    it 'converts all left addition steps to right addition steps recursively' do
      expression = Expression.new([Step.new(:add,5,:lft),Step.new(:add,'x',:lft),
        Step.new(:div,Expression.new([Step.new(:add,7,:lft),
        Step.new(:add,'y',:lft)]),:lft)])
      expected_expression = Expression.new([Step.new(:add,5),Step.new(:add,'x'),
        Step.new(:div,Expression.new([Step.new(:add,7),Step.new(:add,'y')]),:lft)])
      expect(expression.convert_lft_add_mtp_steps).to eq expected_expression
    end

    it 'converts all left addition steps recursively in two iterations' do
      expression = Expression.new([Step.new(:add,5,:lft),Step.new(:add,'x',:lft),
        Step.new(:div,Expression.new([Step.new(:add,7,:lft),Step.new(:add,'y',:lft),
        Step.new(:sbt,Expression.new([Step.new(:add,8,:lft)]))]),:lft)])
      expected_expression = Expression.new([Step.new(:add,5),Step.new(:add,'x'),
        Step.new(:div,Expression.new([Step.new(:add,7),Step.new(:add,'y'),
        Step.new(:sbt,Expression.new([Step.new(:add,8)]))]),:lft)])
      expect(expression.convert_lft_add_mtp_steps).to eq expected_expression
    end

    it 'converts all left multiplication steps to right multiplication steps' do
      expression = Expression.new([Step.new(:mtp,5,:lft),Step.new(:mtp,'x',:lft)])
      expected_expression = Expression.new([Step.new(:mtp,5),Step.new(:mtp,'x')])
      expect(expression.convert_lft_add_mtp_steps).to eq expected_expression
    end

    it 'converts all left multiplication steps to right multiplication steps recursively' do
      expression = Expression.new([Step.new(:mtp,5,:lft),Step.new(:mtp,'x',:lft),
        Step.new(:div,Expression.new([Step.new(:mtp,7,:lft),
        Step.new(:mtp,'y',:lft)]),:lft)])
      expected_expression = Expression.new([Step.new(:mtp,5),Step.new(:mtp,'x'),
        Step.new(:div,Expression.new([Step.new(:mtp,7),Step.new(:mtp,'y')]),:lft)])
      expect(expression.convert_lft_add_mtp_steps).to eq expected_expression
    end

    it 'converts all left addition or multiplication steps recursively in two iterations' do
      expression = Expression.new([Step.new(:mtp,5,:lft),Step.new(:mtp,'x',:lft),
        Step.new(:div,Expression.new([Step.new(:add,7,:lft),Step.new(:mtp,'y',:lft),
        Step.new(:sbt,Expression.new([Step.new(:add,8,:lft)]))]),:lft)])
      expected_expression = Expression.new([Step.new(:mtp,5),Step.new(:mtp,'x'),
        Step.new(:div,Expression.new([Step.new(:add,7),Step.new(:mtp,'y'),
        Step.new(:sbt,Expression.new([Step.new(:add,8)]))]),:lft)])
      expect(expression.convert_lft_add_mtp_steps).to eq expected_expression
    end
  end

  describe '#convert_lft_sbt_div_steps' do
    it 'converts a left subtraction step' do
      expression = Expression.new([Step.new(nil,5),Step.new(:mtp,'x'),Step.new(:sbt,10,:lft)])
      expected_expression = Expression.new([Step.new(nil,10),Step.new(:sbt,
        Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))])
      expect(expression.convert_lft_sbt_div_steps).to eq expected_expression
    end

    it 'converts two left subtraction steps recursively' do
      exp_with_lft_sbt = Expression.new([Step.new(nil,'x'),Step.new(:sbt,11,:lft)])
      expression = Expression.new([Step.new(nil,7),Step.new(:add,exp_with_lft_sbt),
        Step.new(:sbt,12,:lft)])
      exp_without_lft_sbt = Expression.new([Step.new(nil,11),Step.new(:sbt,
        Expression.new([Step.new(nil,'x')]))])
      expected_expression = Expression.new([Step.new(nil,12),Step.new(:sbt,
        Expression.new([Step.new(nil,7),Step.new(:add,exp_without_lft_sbt)]))])
      expect(expression.convert_lft_sbt_div_steps).to eq expected_expression
    end

    it 'converts three left subtraction steps recursively' do
      layer1_lft_sbt = Expression.new([Step.new(nil,'x'),Step.new(:sbt,11,:lft)])
      layer2_lft_sbt = Expression.new([Step.new(nil,'y'),Step.new(:sbt,layer1_lft_sbt,:lft)])
      layer3_lft_sbt = Expression.new([Step.new(nil,'z'),Step.new(:sbt,layer2_lft_sbt,:lft)])
      expression = layer3_lft_sbt
      exp1 = Expression.new([Step.new(nil,11),Step.new(:sbt,Expression.new([Step.new(nil,'x')]))])
      exp2 = Expression.new([Step.new(nil,exp1),Step.new(:sbt,Expression.new([Step.new(nil,'y')]))])
      exp3 = Expression.new([Step.new(nil,exp2),Step.new(:sbt,Expression.new([Step.new(nil,'z')]))])
      expected_expression = exp3
      expect(expression.convert_lft_sbt_div_steps).to eq expected_expression
    end

    it 'converts a left division step' do
      expression = Expression.new([Step.new(nil,5),Step.new(:mtp,'x'),Step.new(:div,10,:lft)])
      expected_expression = Expression.new([Step.new(nil,10),Step.new(:div,
        Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))])
      expect(expression.convert_lft_sbt_div_steps).to eq expected_expression
    end

    it 'converts two left division steps recursively' do
      exp_with_lft_sbt = Expression.new([Step.new(nil,'x'),Step.new(:div,11,:lft)])
      expression = Expression.new([Step.new(nil,7),Step.new(:add,exp_with_lft_sbt),
        Step.new(:div,12,:lft)])
      exp_without_lft_sbt = Expression.new([Step.new(nil,11),Step.new(:div,
        Expression.new([Step.new(nil,'x')]))])
      expected_expression = Expression.new([Step.new(nil,12),Step.new(:div,
        Expression.new([Step.new(nil,7),Step.new(:add,exp_without_lft_sbt)]))])
      expect(expression.convert_lft_sbt_div_steps).to eq expected_expression
    end

    it 'converts three left subtraction or division steps recursively' do
      layer1_lft_sbt = Expression.new([Step.new(nil,'x'),Step.new(:div,11,:lft)])
      layer2_lft_sbt = Expression.new([Step.new(nil,'y'),Step.new(:sbt,layer1_lft_sbt,:lft)])
      layer3_lft_sbt = Expression.new([Step.new(nil,'z'),Step.new(:div,layer2_lft_sbt,:lft)])
      expression = layer3_lft_sbt
      exp1 = Expression.new([Step.new(nil,11),Step.new(:div,Expression.new([Step.new(nil,'x')]))])
      exp2 = Expression.new([Step.new(nil,exp1),Step.new(:sbt,Expression.new([Step.new(nil,'y')]))])
      exp3 = Expression.new([Step.new(nil,exp2),Step.new(:div,Expression.new([Step.new(nil,'z')]))])
      expected_expression = exp3
      expect(expression.convert_lft_sbt_div_steps).to eq expected_expression
    end
  end

  describe '#m_sum_mtp_m_sum' do
    it 'expands (e + e) x (e - e)' do
      m_sum_1 = Expression.new([Step.new(nil,2),Step.new(:add,'x')])
      m_sum_2 = Expression.new([Step.new(nil,5),Step.new(:sbt,'y')])
      expected_expression = Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,5)])),
        Step.new(:add,Expression.new([Step.new(nil,'x'),Step.new(:mtp,5)])),
        Step.new(:sbt,Expression.new([Step.new(nil,2),Step.new(:mtp,'y')])),
        Step.new(:sbt,Expression.new([Step.new(nil,'x'),Step.new(:mtp,'y')]))
        ])
      expect(m_sum_1.m_sum_mtp_m_sum(m_sum_2)).to eq expected_expression
    end

    it 'expands (e - m) x (m + e)' do
      m_sum_1 = Expression.new([Step.new(nil,2),Step.new(:sbt,
        Expression.new([Step.new(nil,3),Step.new(:mtp,'a')]))])
      m_sum_2 = Expression.new([Step.new(nil,
        Expression.new([Step.new(nil,4),Step.new(:mtp,'x')])
        ),Step.new(:add,'y')])
      expected_expression = Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,4),
          Step.new(:mtp,'x')])),
        Step.new(:sbt,Expression.new([Step.new(nil,3),Step.new(:mtp,'a'),
          Step.new(:mtp,4),Step.new(:mtp,'x')])),
        Step.new(:add,Expression.new([Step.new(nil,2),Step.new(:mtp,'y')])),
        Step.new(:sbt,Expression.new([Step.new(nil,3),Step.new(:mtp,'a'),
          Step.new(:mtp,'y')]))
        ])
      expect(m_sum_1.m_sum_mtp_m_sum(m_sum_2)).to eq expected_expression
    end
  end

  describe '#convert_to_rational_sum' do
    shared_context 'shared examples' do
      before(:all) do
        @nil_elementary_step_1 = Step.new(nil,5)
        @nil_elementary_step_2 = Step.new(nil,'x')
        @nil_elementary_step_3 = Step.new(nil,'x')
        @elementary_step_add_1 = Step.new(:add,7)
        @elementary_step_add_2 = Step.new(:add,'a')
        @elementary_step_add_3 = Step.new(:add,'b')
        @elementary_step_sbt_1 = Step.new(:sbt,8)
        @elementary_step_sbt_2 = Step.new(:sbt,'c')
        @elementary_step_sbt_3 = Step.new(:sbt,'d')
        @elementary_step_mtp_1 = Step.new(:mtp,11)
        @elementary_step_mtp_2 = Step.new(:mtp,'b')
        @elementary_step_mtp_3 = Step.new(:mtp,'c')
        @elementary_step_div_1 = Step.new(:div,12)
        @elementary_step_div_2 = Step.new(:div,'e')
        @elementary_step_div_3 = Step.new(:div,'f')
        @m_form_1 = Expression.new([@nil_elementary_step_1,@elementary_step_mtp_1])
        @m_form_2 = Expression.new([@nil_elementary_step_2,@elementary_step_mtp_2])
        @m_form_3 = Expression.new([@nil_elementary_step_3,@elementary_step_mtp_3])
        @m_form_sum_1 = Expression.new([Step.new(nil,@m_form_1),Step.new(:sbt,@m_form_2)])
        @m_form_sum_2 = Expression.new([Step.new(nil,5),Step.new(:sbt,@m_form_2)])
        @m_form_sum_3 = Expression.new([Step.new(nil,@m_form_1),Step.new(:sbt,'x')])
        @m_form_sum_4 = Expression.new([Step.new(nil,5),Step.new(:sbt,'a'),Step.new(:add,'b')])
        @rational_1 = Expression.new([Step.new(nil,7),Step.new(:div,@m_form_1)])
        @rational_2 = Expression.new([Step.new(nil,@m_form_2),Step.new(:div,@m_form_sum_1)])
        @rational_3 = Expression.new([Step.new(nil,@m_form_3),Step.new(:div,@m_form_sum_2)])
        @rational_sum_1 = Expression.new([Step.new(nil,@rational_1),Step.new(:sbt,@rational_2)])
        @rational_sum_2 = Expression.new([Step.new(nil,'x'),Step.new(:add,@rational_3)])
        @rational_sum_3 = Expression.new([Step.new(nil,@m_form_1),Step.new(:add,@rational_1)])
      end
    end

    include_context 'shared examples'

    it 'converts e expression' do
      expression = Expression.new([@nil_elementary_step_1])
      expect(expression.convert_to_rational_sum).to eq expression
    end

    it 'converts m expression' do
      expression = Expression.new([Step.new(nil,@m_form_1)])
      expect(expression.convert_to_rational_sum).to eq expression
    end

    it 'converts r expression' do
      expression = Expression.new([Step.new(nil,@rational_1)])
      expect(expression.convert_to_rational_sum).to eq expression
    end

    it 'converts ms expression' do
      expression = Expression.new([Step.new(nil,@m_form_sum_1)])
      expected_expression = @m_form_sum_1
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts rs expression' do
      expression = Expression.new([Step.new(nil,@rational_sum_1)])
      expected_expression = @rational_sum_1
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts e + m expression' do
      expression = Expression.new([Step.new(nil,3),Step.new(:add,@m_form_2)])
      expect(expression.convert_to_rational_sum).to eq expression
    end

    it 'converts e + r expression' do
      expression = Expression.new([Step.new(nil,3),Step.new(:add,@rational_3)])
      expect(expression.convert_to_rational_sum).to eq expression
    end

    it 'converts e + ms expression' do
      expression = Expression.new([Step.new(nil,3),Step.new(:add,@m_form_sum_1)])
      expected_steps = [Step.new(nil,3)]+ @m_form_sum_1.steps
      expected_expression = Expression.new(expected_steps)
      # p expected_expression
      #the following step will change expected_expressions second step ops
      result = expression.convert_to_rational_sum
      # p expected_expression
      expect(result).to eq expected_expression
    end

    it 'converts e + rs expression' do
      expression = Expression.new([Step.new(nil,3),Step.new(:add,@rational_sum_1)])
      expected_steps = [Step.new(nil,3)]+ @rational_sum_1.steps
      expected_expression = Expression.new(expected_steps)
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts m + e + rs + ms expression' do
      m_step = Step.new(nil,@m_form_1)
      e_step = Step.new(:add,'x')
      rs_step = Step.new(:add,@rational_sum_3)
      ms_step = Step.new(:add,@m_form_sum_2)
      expression = Expression.new([m_step,e_step,rs_step,ms_step])
      expected_steps = [m_step,e_step] + @rational_sum_3.steps + @m_form_sum_2.steps
      expected_expression = Expression.new(expected_steps)
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts e + n expression recursively' do
      e_step = Step.new(nil,5)
      m_form_sum = Expression.new([Step.new(nil,'x'),Step.new(:add,'y')])
      non_standard_exp = Expression.new([Step.new(nil,'z'),Step.new(:add,m_form_sum)])
      n_step = Step.new(:add,non_standard_exp)
      expression = Expression.new([e_step,n_step])
      expected_expression = Expression.new([Step.new(nil,5),Step.new(:add,'z'),Step.new(:add,'x'),Step.new(:add,'y')])
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts e - e expression' do
      expression = Expression.new([Step.new(nil,5),Step.new(:sbt,'x')])
      expect(expression.convert_to_rational_sum).to eq expression
    end

    it 'converts e - m expression' do
      expression = Expression.new([Step.new(nil,5),Step.new(:sbt,@m_form_1)])
      expect(expression.convert_to_rational_sum).to eq expression
    end

    it 'converts e - r expression' do
      expression = Expression.new([Step.new(nil,5),Step.new(:sbt,'x',@rational1)])
      expect(expression.convert_to_rational_sum).to eq expression
    end

    it 'converts e - ms expression' do
      e_step = Step.new(nil,'x')
      ms_step = Step.new(:sbt,@m_form_sum_2)
      expression = Expression.new([e_step,ms_step])
      ms_negated_steps = [Step.new(:sbt,5),Step.new(:add,@m_form_2)]
      expected_steps = [e_step] + ms_negated_steps
      expected_expression = Expression.new(expected_steps)
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts e - rs expression' do
      e_step = Step.new(nil,'x')
      rs_step = Step.new(:sbt,@rational_sum_3)
      expression = Expression.new([e_step,rs_step])
      ms_negated_steps = [Step.new(:sbt,@m_form_1),Step.new(:sbt,@rational_1)]
      expected_steps = [e_step] + ms_negated_steps
      expected_expression = Expression.new(expected_steps)
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts e - n expression recursively' do
      e_step = Step.new(nil,2)
      non_standard_exp = Expression.new([Step.new(nil,'x'),Step.new(:sbt,@m_form_sum_1)])
      n_step = Step.new(:sbt,non_standard_exp)
      expression = Expression.new([e_step,n_step])
      expected_steps = [e_step,Step.new(:sbt,'x'),Step.new(:add,@m_form_1),
        Step.new(:sbt,@m_form_2)]
      expected_expression = Expression.new(expected_steps)
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts e x e expression' do
      e_step_1 = Step.new(nil,5)
      e_step_2 = Step.new(:mtp,'y')
      expression = Expression.new([e_step_1,e_step_2])
      m_step_1 = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,'y')]))
      expected_expression = Expression.new([m_step_1])
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts e + e x e expression' do
      e_step_1 = Step.new(nil,5)
      e_step_2 = Step.new(:add,'x')
      e_step_3 = Step.new(:mtp,'y')
      expression = Expression.new([e_step_1,e_step_2,e_step_3])
      m_step_1 = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,'y')]))
      m_step_2 = Step.new(:add,Expression.new([Step.new(nil,'x'),Step.new(:mtp,'y')]))
      expected_expression = Expression.new([m_step_1,m_step_2])
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts m + m x e expression' do
      m_step_1 = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      m_step_2 = Step.new(:add,Expression.new([Step.new(nil,2),Step.new(:mtp,'y')]))
      e_step = Step.new(:mtp,'z')
      expression = Expression.new([m_step_1,m_step_2,e_step])
      new_m_step_1_steps = m_step_1.val.steps + [e_step]
      new_m_step_2_steps = m_step_2.val.steps + [e_step]
      new_m_step_1 = Step.new(nil,Expression.new(new_m_step_1_steps))
      new_m_step_2 = Step.new(:add,Expression.new(new_m_step_2_steps))
      expected_expression = Expression.new([new_m_step_1,new_m_step_2])
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts m - r x e with e numerator for r expression' do
      m_step = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      r_step = Step.new(:sbt,Expression.new([Step.new(nil,7),Step.new(:div,'a')]))
      e_step = Step.new(:mtp,'z')
      expression = Expression.new([m_step,r_step,e_step])
      new_m_step = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,'x'),
        Step.new(:mtp,'z')]))
      new_r_step = Step.new(:sbt,Expression.new([Step.new(nil,Expression.new([
        Step.new(nil,7),Step.new(:mtp,'z')])),Step.new(:div,Expression.new([
          Step.new(nil,Expression.new([Step.new(nil,'a'),Step.new(:mtp,1)]))
          ]))]))
      expected_expression = Expression.new([new_m_step,new_r_step])
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts m + r x e with m numerator for r expression' do
      m_step = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      m_form = Expression.new([Step.new(nil,7),Step.new(:mtp,'c')])
      r_step = Step.new(:add,Expression.new([Step.new(nil,m_form),Step.new(:div,'a')]))
      e_step = Step.new(:mtp,'z')
      expression = Expression.new([m_step,r_step,e_step])
      new_m_step = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,'x'),
        Step.new(:mtp,'z')]))
      denominator_step = Step.new(:div,Expression.new([Step.new(nil,Expression.new([Step.new(nil,'a'),Step.new(:mtp,1)]))]))
      new_r_step = Step.new(:add,Expression.new([Step.new(nil,Expression.new([
        Step.new(nil,7),Step.new(:mtp,'c'),Step.new(:mtp,'z')])),denominator_step]))
      expected_expression = Expression.new([new_m_step,new_r_step])
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts e - m/ms x m' do
      step_1 = Step.new(nil,2)
      numerator_step = Step.new(nil,Expression.new([Step.new(nil,3),Step.new(:mtp,'x')]))
      m_step_1 = Step.new(nil,Expression.new([Step.new(nil,4),Step.new(:mtp,'a')]))
      m_step_2 = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'b')]))
      m_sum_exp = Expression.new([m_step_1,m_step_2])
      denominator_step = Step.new(:div,m_sum_exp)
      r_exp = Expression.new([numerator_step,denominator_step])
      step_2 = Step.new(:sbt,r_exp)
      step_3 = Step.new(:mtp,Expression.new([Step.new(nil,6),Step.new(:mtp,'c')]))
      expression = Expression.new([step_1,step_2,step_3])
      expected_step_1 = Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,6),Step.new(:mtp,'c')]))
      expected_numerator_step = Step.new(nil,Expression.new([Step.new(nil,3),Step.new(:mtp,'x'),
        Step.new(:mtp,6),Step.new(:mtp,'c')]))
      new_m_step_1 = Step.new(nil,Expression.new([Step.new(nil,4),Step.new(:mtp,'a'),Step.new(:mtp,1)]))
      new_m_step_2 = Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'b'),Step.new(:mtp,1)]))
      new_m_sum_exp = Expression.new([new_m_step_1,new_m_step_2])
      new_denominator_step = Step.new(:div,new_m_sum_exp)
      r_exp_2 = Expression.new([expected_numerator_step,new_denominator_step])
      expected_step_2 = Step.new(:sbt,r_exp_2)
      expected_expression = Expression.new([expected_step_1,expected_step_2])
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts e + (e/e) x (e/e)' do
      step_1 = Step.new(nil,1)
      step_2 = Step.new(:add,Expression.new([Step.new(nil,2),Step.new(:div,'x')]))
      step_3 = Step.new(:mtp,Expression.new([Step.new(nil,'a'),Step.new(:div,'b')]))
      expression = Expression.new([step_1,step_2,step_3])
      r_exp_1 = Expression.new([Step.new(nil,Expression.new([Step.new(nil,1),
        Step.new(:mtp,'a')])),Step.new(:div,Expression.new([Step.new(nil,Expression.new([Step.new(nil,1),Step.new(:mtp,'b')]))]))])
      m_sum_exp = Expression.new([Step.new(nil,Expression.new([Step.new(nil,'x'),Step.new(:mtp,'b')]))])
      r_exp_2 = Expression.new([Step.new(nil,Expression.new([Step.new(nil,2),
        Step.new(:mtp,'a')])),Step.new(:div,m_sum_exp)])
      expected_expression = Expression.new([Step.new(nil,r_exp_1),Step.new(:add,r_exp_2)])
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts (e/m) + m x (m/m)' do
      step_1 = Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:div,
        Expression.new([Step.new(nil,3),Step.new(:mtp,'x')])
        )]))
      step_2 = Step.new(:add,Expression.new([Step.new(nil,'y'),Step.new(:mtp,4)]))
      step_3 = Step.new(:mtp,Expression.new([
        Step.new(nil,
          Expression.new([Step.new(nil,'z'),Step.new(:mtp,5)])
        ),
        Step.new(:div,
          Expression.new([Step.new(nil,6),Step.new(:mtp,'a')])
        )
        ]))
      expression = Expression.new([step_1,step_2,step_3])
      r_step_1 = Step.new(nil,Expression.new([
        Step.new(nil,
          Expression.new([Step.new(nil,2),Step.new(:mtp,'z'),Step.new(:mtp,5)])
        ),
        Step.new(:div,
          Expression.new([
            Step.new(nil,Expression.new([Step.new(nil,3),Step.new(:mtp,'x'),
              Step.new(:mtp,6),Step.new(:mtp,'a')]))
          ])
        )
        ]))
      r_step_2 = Step.new(:add,Expression.new([
        Step.new(nil,
          Expression.new([Step.new(nil,'y'),Step.new(:mtp,4),Step.new(:mtp,'z'),Step.new(:mtp,5)])
        ),
        Step.new(:div,
          Expression.new([Step.new(nil,
            Expression.new([Step.new(nil,1),Step.new(:mtp,6),Step.new(:mtp,'a')]))])
        )
        ]))
      expected_expression = Expression.new([r_step_1,r_step_2])
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts (m/ms) - m x (e/ms)' do
      step_1 = Step.new(nil,
        Expression.new([
          Step.new(nil,
            Expression.new([Step.new(nil,'z'),Step.new(:mtp,5)])
          ),
          Step.new(:div,
            Expression.new([
              Step.new(nil,6),
              Step.new(:sbt,
                Expression.new([Step.new(nil,'a'),Step.new(:mtp,3)])
              )
            ])
          )
        ])
      )
      step_2 = Step.new(:sbt,Expression.new([Step.new(nil,4),Step.new(:mtp,'b')]))
      step_3 = Step.new(:mtp,
        Expression.new([
          Step.new(nil,'d'),
          Step.new(:div,
            Expression.new([
              Step.new(nil,7),
              Step.new(:add,
                Expression.new([Step.new(nil,'e'),Step.new(:mtp,9)])
              )
            ])
          )
        ])
      )
      expression = Expression.new([step_1,step_2,step_3])
      r_step_1 = Step.new(nil,
        Expression.new([
          Step.new(nil,
            Expression.new([Step.new(nil,'z'),Step.new(:mtp,5),Step.new(:mtp,'d')])
          ),
          Step.new(:div,
            Expression.new([
              Step.new(nil,
                Expression.new([Step.new(nil,6),Step.new(:mtp,7)])
              ),
              Step.new(:sbt,
                Expression.new([Step.new(nil,'a'),Step.new(:mtp,3),Step.new(:mtp,7)])
              ),
              Step.new(:add,
                Expression.new([Step.new(nil,6),Step.new(:mtp,'e'),Step.new(:mtp,9)])
              ),
              Step.new(:sbt,
                Expression.new([Step.new(nil,'a'),Step.new(:mtp,3),
                  Step.new(:mtp,'e'),Step.new(:mtp,9)])
              )
            ])
          )
        ])
      )
      r_step_2 = Step.new(:sbt,
        Expression.new([
          Step.new(nil,
            Expression.new([Step.new(nil,4),Step.new(:mtp,'b'),Step.new(:mtp,'d')])
          ),
          Step.new(:div,
            Expression.new([
              Step.new(nil,
                Expression.new([Step.new(nil,1),Step.new(:mtp,7)])
              ),
              Step.new(:add,
                Expression.new([Step.new(nil,1),Step.new(:mtp,'e'),Step.new(:mtp,9)])
              )
            ])
          )
        ])
      )
      expected_expression = Expression.new([r_step_1,r_step_2])
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts e + e x (e - e)' do
      step_1 = Step.new(nil,2)
      step_2 = Step.new(:add,'x')
      step_3 = Step.new(:mtp,Expression.new([Step.new(nil,'a'),Step.new(:sbt,'b')]))
      expression = Expression.new([step_1,step_2,step_3])
      result_step_1 = Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,'a')]))
      result_step_2 = Step.new(:add,Expression.new([Step.new(nil,'x'),Step.new(:mtp,'a')]))
      result_step_3 = Step.new(:sbt,Expression.new([Step.new(nil,2),Step.new(:mtp,'b')]))
      result_step_4 = Step.new(:sbt,Expression.new([Step.new(nil,'x'),Step.new(:mtp,'b')]))
      expected_expression = Expression.new([result_step_1,result_step_2,
        result_step_3,result_step_4])
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts e - m x (e + e/e)' do
      step_1 = Step.new(nil,2)
      step_2 = Step.new(:sbt,Expression.new([Step.new(nil,3),Step.new(:mtp,'x')]))
      step_3 = Step.new(:mtp,Expression.new([Step.new(nil,'a'),Step.new(:add,
          Expression.new([Step.new(nil,7),Step.new(:div,'y')])
        )]))
      expression = Expression.new([step_1,step_2,step_3])
      result_step_1 = Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,'a')]))
      result_step_2 = Step.new(:sbt,Expression.new([Step.new(nil,3),
        Step.new(:mtp,'x'),Step.new(:mtp,'a')]))
      result_step_3 = Step.new(:add,
        Expression.new([
          Step.new(nil,
            Expression.new([Step.new(nil,2),Step.new(:mtp,7)])
          ),
          Step.new(:div,
            Expression.new([Step.new(nil,Expression.new([Step.new(nil,1),Step.new(:mtp,'y')]))])
          )
        ])
      )
      result_step_4 = Step.new(:sbt,
        Expression.new([
          Step.new(nil,
            Expression.new([Step.new(nil,3),Step.new(:mtp,'x'),Step.new(:mtp,7)])
          ),
          Step.new(:div,
            Expression.new([Step.new(nil,Expression.new([Step.new(nil,1),Step.new(:mtp,'y')]))])
          )
        ])
      )
      expected_expression = Expression.new([result_step_1,result_step_2,
        result_step_3,result_step_4])
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts e - m x (nil (e + e/e)) recursively' do
      step_1 = Step.new(nil,2)
      step_2 = Step.new(:sbt,Expression.new([Step.new(nil,3),Step.new(:mtp,'x')]))
      step_3 = Step.new(:mtp,
        Expression.new([Step.new(nil,
          Expression.new([
            Step.new(nil,'a'),
            Step.new(:add,Expression.new([Step.new(nil,7),Step.new(:div,'y')]))
          ])
        )])
      )
      expression = Expression.new([step_1,step_2,step_3])
      result_step_1 = Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,'a')]))
      result_step_2 = Step.new(:sbt,Expression.new([Step.new(nil,3),
        Step.new(:mtp,'x'),Step.new(:mtp,'a')]))
      result_step_3 = Step.new(:add,
        Expression.new([
          Step.new(nil,
            Expression.new([Step.new(nil,2),Step.new(:mtp,7)])
          ),
          Step.new(:div,
            Expression.new([Step.new(nil,Expression.new([Step.new(nil,1),Step.new(:mtp,'y')]))])
          )
        ])
      )
      result_step_4 = Step.new(:sbt,
        Expression.new([
          Step.new(nil,
            Expression.new([Step.new(nil,3),Step.new(:mtp,'x'),Step.new(:mtp,7)])
          ),
          Step.new(:div,
            Expression.new([Step.new(nil,Expression.new([Step.new(nil,1),Step.new(:mtp,'y')]))])
          )
        ])
      )
      expected_expression = Expression.new([result_step_1,result_step_2,
        result_step_3,result_step_4])
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts e + e / e' do
      step_1 = Step.new(nil,5)
      step_2 = Step.new(:add,'x')
      step_3 = Step.new(:div,'y')
      expression = Expression.new([step_1,step_2,step_3])
      result_step_1 = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:div,'y')]))
      result_step_2 = Step.new(:add,Expression.new([Step.new(nil,'x'),Step.new(:div,'y')]))
      expected_expression = Expression.new([result_step_1,result_step_2])
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts e + (e/e) / e' do
      step_1 = Step.new(nil,5)
      step_2 = Step.new(:add,Expression.new([Step.new(nil,4),Step.new(:div,'x')]))
      step_3 = Step.new(:div,'y')
      expression = Expression.new([step_1,step_2,step_3])
      result_step_1 = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:div,'y')]))
      result_step_2 = Step.new(:add,Expression.new([Step.new(nil,4),Step.new(:div,
        Expression.new([Step.new(nil,Expression.new([Step.new(nil,'x'),Step.new(:mtp,'y')]))])
        )]))
      expected_expression = Expression.new([result_step_1,result_step_2])
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts e + (e/e) / (e - e)' do
      step_1 = Step.new(nil,5)
      step_2 = Step.new(:add,Expression.new([Step.new(nil,4),Step.new(:div,'x')]))
      step_3 = Step.new(:div,Expression.new([Step.new(nil,'a'),Step.new(:sbt,'b')]))
      expression = Expression.new([step_1,step_2,step_3])
      result_step_1 = Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:div,
        Expression.new([Step.new(nil,'a'),Step.new(:sbt,'b')])
        )]))
      result_step_2 = Step.new(:add,Expression.new([Step.new(nil,4),Step.new(:div,
        Expression.new([
          Step.new(nil,Expression.new([Step.new(nil,'x'),Step.new(:mtp,'a')])),
          Step.new(:sbt,Expression.new([Step.new(nil,'x'),Step.new(:mtp,'b')])),
          ])
        )]))
      expected_expression = Expression.new([result_step_1,result_step_2])
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts e + e / (e/e)' do
      step_1 = Step.new(nil,5)
      step_2 = Step.new(:add,'x')
      step_3 = Step.new(:div,Expression.new([Step.new(nil,'a'),Step.new(:div,'b')]))
      expression = Expression.new([step_1,step_2,step_3])
      result_step_1 = Step.new(nil,Expression.new([Step.new(nil,
        Expression.new([Step.new(nil,5),Step.new(:mtp,'b')])),Step.new(:div,'a')]))
      result_step_2 = Step.new(:add,Expression.new([Step.new(nil,
        Expression.new([Step.new(nil,'x'),Step.new(:mtp,'b')])),Step.new(:div,'a')]))
      expected_expression = Expression.new([result_step_1,result_step_2])
      expect(expression.convert_to_rational_sum).to eq expected_expression
    end

    it 'converts e - e / (e + e/e)' do
      step_1 = Step.new(nil,5)
      step_2 = Step.new(:sbt,'x')
      step_3 = Step.new(:div,Expression.new([Step.new(nil,6),
        Step.new(:add,Expression.new([Step.new(nil,'a'),Step.new(:div,'b')]))]))
      expect(step_3.is_m_form_sum?).to be false
      expect(step_3.is_rational_sum?).to be true
      expression = Expression.new([step_1,step_2,step_3])
      result_step_1 = Step.new(nil,Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,1),Step.new(:mtp,'b')])),
        Step.new(:div,Expression.new([Step.new(nil,Expression.new([
          Step.new(nil,6),Step.new(:mtp,'b')])),Step.new(:add,Expression.new([
            Step.new(nil,'a'),Step.new(:mtp,1)]))]))]))
      result_step_2 = Step.new(:sbt,Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,'x'),Step.new(:mtp,1),Step.new(:mtp,'b')])),
        Step.new(:div,Expression.new([Step.new(nil,Expression.new([
          Step.new(nil,6),Step.new(:mtp,'b')])),Step.new(:add,Expression.new([
            Step.new(nil,'a'),Step.new(:mtp,1)]))]))]))
      expect(result_step_1.is_rational?).to be true
      expect(result_step_2.is_rational?).to be true
      expected_expression = Expression.new([result_step_1,result_step_2])
      result = expression.convert_to_rational_sum
      expect(result).to eq expected_expression
    end

    it 'converts e / (e + e - e/e )' do
      step_1 = Step.new(nil,2)
      step_2 = Step.new(:div,Expression.new([
        Step.new(nil,3),
        Step.new(:add,4),
        Step.new(:sbt,Expression.new([Step.new(nil,5),Step.new(:div,6)]))
        ]))
      expect(step_2.is_rational_sum?).to be true
      expression = Expression.new([step_1,step_2])
      numerator_step = Step.new(nil,Expression.new([Step.new(nil,2),
        Step.new(:mtp,1),Step.new(:mtp,1),Step.new(:mtp,6)]))
      denominator_step = Step.new(:div,Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,3),Step.new(:mtp,1),Step.new(:mtp,6)])),
        Step.new(:add,Expression.new([Step.new(nil,4),Step.new(:mtp,1),Step.new(:mtp,6)])),
        Step.new(:sbt,Expression.new([Step.new(nil,5),Step.new(:mtp,1),Step.new(:mtp,1)]))
        ]))
      expected_expression = Expression.new([Step.new(nil,Expression.new([numerator_step,denominator_step]))])
      result = expression.convert_to_rational_sum
      expect(expected_expression.is_rational_sum?).to be true
      expect(result).to eq expected_expression
    end

    it 'converts e / n where n = [(nil,(e + e - e/e))] recursively' do
      step_1 = Step.new(nil,2)
      step_2 = Step.new(:div,Expression.new([
        Step.new(nil,3),
        Step.new(:add,4),
        Step.new(:sbt,Expression.new([Step.new(nil,5),Step.new(:div,Expression.new([Step.new(nil,6)]))]))
        ]))
      expression = Expression.new([step_1,step_2])

      numerator_step = Step.new(nil,Expression.new([Step.new(nil,2),
        Step.new(:mtp,1),Step.new(:mtp,1),Step.new(:mtp,6)]))
      denominator_step = Step.new(:div,Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,3),Step.new(:mtp,1),Step.new(:mtp,6)])),
        Step.new(:add,Expression.new([Step.new(nil,4),Step.new(:mtp,1),Step.new(:mtp,6)])),
        Step.new(:sbt,Expression.new([Step.new(nil,5),Step.new(:mtp,1),Step.new(:mtp,1)]))
        ]))
      expected_expression = Expression.new([Step.new(nil,Expression.new([numerator_step,denominator_step]))])
      result = expression.convert_to_rational_sum
      expect(result).to eq expected_expression
    end
  end

  describe '#m_form_latex' do
    it 'returns latex for a one string-valued step m-form' do
      m_form = Expression.new([Step.new(nil,'x')])
      expected_latex = "x"
      expect(m_form.m_form_latex).to eq expected_latex
    end

    it 'returns latex for a one number-valued step m-form' do
      m_form = Expression.new([Step.new(nil,5)])
      expected_latex = "5"
      expect(m_form.m_form_latex).to eq expected_latex
    end

    it 'returns latex for a two step m-form' do
      m_form = Expression.new([Step.new(nil,5),Step.new(:mtp,'x')])
      expected_latex = "5x"
      expect(m_form.m_form_latex).to eq expected_latex
    end

    it 'returns latex for a three step m-form' do
      m_form = Expression.new([Step.new(nil,5),Step.new(:mtp,'x'),
        Step.new(:mtp,'y')])
      expected_latex = "5xy"
      expect(m_form.m_form_latex).to eq expected_latex
    end

    it 'returns latex for m-form with consecutive numerical steps' do
      m_form = Expression.new([Step.new(nil,'x'),Step.new(:mtp,5),
        Step.new(:mtp,7),Step.new(:mtp,'y')])
      expected_latex = 'x5\times7y'
      expect(m_form.m_form_latex).to eq expected_latex
    end
  end

  describe '#m_form_sum_latex' do
    it 'returns latex for one expression m-form-sum' do
      m_form_sum = Expression.new([Step.new(nil,Expression.new([
        Step.new(nil,5),Step.new(:mtp,'x'),Step.new(:mtp,'y')]))])
      expected_latex = "5xy"
      expect(m_form_sum.m_form_sum_latex).to eq expected_latex
    end

    it 'returns latex for two expression m-form-sum' do
      m_form_sum = Expression.new([
        Step.new(nil,Expression.new([
          Step.new(nil,5),Step.new(:mtp,'x'),Step.new(:mtp,'y')])),
        Step.new(:sbt,Expression.new([
          Step.new(nil,2),Step.new(:mtp,'a'),Step.new(:mtp,'b')]))
        ])
      expected_latex = "5xy-2ab"
      expect(m_form_sum.m_form_sum_latex).to eq expected_latex
    end

    it 'returns latex for three term elementary and expression m-form-sum' do
      m_form_sum = Expression.new([
        Step.new(nil,Expression.new([
          Step.new(nil,5),Step.new(:mtp,'x'),Step.new(:mtp,'y')])),
        Step.new(:add,'p'),
        Step.new(:sbt,Expression.new([
          Step.new(nil,2),Step.new(:mtp,'a'),Step.new(:mtp,'b')]))
        ])
      expected_latex = "5xy+p-2ab"
      expect(m_form_sum.m_form_sum_latex).to eq expected_latex
    end

    it 'returns latex for four term elementary and expression m-form-sum' do
      m_form_sum = Expression.new([
        Step.new(nil,123),
        Step.new(:sbt,Expression.new([
          Step.new(nil,5),Step.new(:mtp,'x'),Step.new(:mtp,'y')])),
        Step.new(:add,'p'),
        Step.new(:sbt,Expression.new([
          Step.new(nil,2),Step.new(:mtp,'a'),Step.new(:mtp,'b')]))
        ])
      expected_latex = "123-5xy+p-2ab"
      expect(m_form_sum.m_form_sum_latex).to eq expected_latex
    end
  end

  describe '#rational_latex' do
    it 'returns latex for e/e rational' do
      rational = Expression.new([Step.new(nil,5),Step.new(:div,'x')])
      expected_latex = '\frac{5}{x}'
      expect(rational.rational_latex).to eq expected_latex
    end

    it 'returns latex for e/m rational' do
      rational = Expression.new([
        Step.new(nil,5),
        Step.new(:div,
          Expression.new([
            Step.new(nil,2),Step.new(:mtp,'a'),Step.new(:mtp,'b')])
        )
      ])
      expected_latex = '\frac{5}{2ab}'
      expect(rational.rational_latex).to eq expected_latex
    end

    it 'returns latex for m/e rational' do
      rational = Expression.new([
        Step.new(nil,
          Expression.new([
            Step.new(nil,2),Step.new(:mtp,'a'),Step.new(:mtp,'b')])
        ),
        Step.new(:div,'y')
      ])
      expected_latex = '\frac{2ab}{y}'
      expect(rational.rational_latex).to eq expected_latex
    end

    it 'returns latex for m/m rational' do
      rational = Expression.new([
        Step.new(nil,
          Expression.new([
            Step.new(nil,3),Step.new(:mtp,'x'),Step.new(:mtp,'y')])
        ),
        Step.new(:div,
          Expression.new([
            Step.new(nil,2),Step.new(:mtp,'a'),Step.new(:mtp,'b')])
        )
      ])
      expected_latex = "\\frac{3xy}{2ab}"
      expect(rational.rational_latex).to eq expected_latex
    end

    it 'returns latex for m/(m) over ms rational' do
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
            )
          ])
        )
      ])
      expected_latex = "\\frac{3xy}{2ab}"
      expect(rational.rational_latex).to eq expected_latex
    end

    it 'returns latex for m/(m-e) rational' do
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
      expected_latex = "\\frac{3xy}{2ab-5}"
      expect(rational.rational_latex).to eq expected_latex
    end

    it 'returns latex for m/(e+m-m) rational' do
      rational = Expression.new([
        Step.new(nil,
          Expression.new([
            Step.new(nil,3),Step.new(:mtp,'x'),Step.new(:mtp,'y')])
        ),
        Step.new(:div,
          Expression.new([
            Step.new(nil,'t'),
            Step.new(:add,Expression.new([
              Step.new(nil,2),Step.new(:mtp,'a'),Step.new(:mtp,'b')
              ])
            ),
            Step.new(:sbt,Expression.new([
              Step.new(nil,'x'),Step.new(:mtp,3),Step.new(:mtp,5)
              ])
            ),
          ])
        )
      ])
      expected_latex = "\\frac{3xy}{t+2ab-x3\\times5}"
      expect(rational.rational_latex).to eq expected_latex
    end
  end

  describe '#latex' do
    it 'returns latex for a 1 elementary step expression' do
      expression = Expression.new([Step.new(nil,5)])
      expect(expression.latex).to eq '5'
    end

    it 'returns latex for a 2 elementary step expression' do
      expression = Expression.new([Step.new(nil,'x'),Step.new(:add,2,:lft)])
      expect(expression.latex).to eq '2+x'
    end

    it 'returns latex for a 4 elementary step expression' do
      expression = Expression.new([Step.new(nil,'x'),Step.new(:add,2),
        Step.new(:div,15,:lft),Step.new(:mtp,4)])
      expect(expression.latex).to eq '4\left(\frac{15}{x+2}\right)'
    end

    it 'returns latex for a 3 step expression with some exp steps' do
      expression = Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,'a'),Step.new(:sbt,'b')])),
        Step.new(:add,Expression.new([Step.new(nil,2),Step.new(:mtp,6)]),:lft),
        Step.new(:div,Expression.new([Step.new(nil,'x'),Step.new(:sbt,11,:lft)]))
        ])
      expected_latex = '\frac{2\times6+\left(a-b\right)}{11-x}'
      expect(expression.latex).to eq expected_latex
    end

    it 'returns latex for a multi-step expression with mixture of steps eg 1' do
      rational_1 = Expression.new([
        Step.new(nil,
          Expression.new([
            Step.new(nil,3),Step.new(:mtp,'x'),Step.new(:mtp,'y')])
        ),
        Step.new(:div,
          Expression.new([
            Step.new(nil,Expression.new([
              Step.new(nil,2),Step.new(:mtp,4),Step.new(:mtp,'b')
              ])
            ),
            Step.new(:sbt,5)
          ])
        )
      ])
      step_1 = Step.new(nil,rational_1)
      step_2 = Step.new(:mtp,'x')
      step_3 = Step.new(:sbt,123,:lft)
      expression = Expression.new([step_1,step_2,step_3])
      expected_latex = "123-x\\left(\\frac{3xy}{2\\times4b-5}\\right)"
      result_latex = expression.latex
      expect(result_latex).to eq expected_latex
    end

    it 'returns latex for a multi-step expression with mixture of steps eg 2' do
      step_1 = Step.new(nil,Expression.new([Step.new(nil,3),Step.new(:div,
        Expression.new([Step.new(nil,'x'),Step.new(:sbt,4,:lft)]))]))
      step_2 = Step.new(:add,2,:lft)
      step_3 = Step.new(:mtp,Expression.new([Step.new(nil,3),Step.new(:mtp,'a')]))
      step_4 = Step.new(:sbt,Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,4),Step.new(:mtp,'x')])),
        Step.new(:div,Expression.new([Step.new(nil,5),Step.new(:mtp,'y'),Step.new(:add,2)]))
        ]),:lft)
      expression = Expression.new([step_1,step_2,step_3,step_4])
      result_latex = expression.latex
      expected_latex = "\\frac{4x}{5y+2}-3a\\left(2+\\frac{3}{4-x}\\right)"
      expect(result_latex).to eq expected_latex
    end

    it 'returns latex for a multi-step expression with mixture of steps eg 2 again' do
      step_1 = Step.new(nil,Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,4),Step.new(:mtp,'x')])),
        Step.new(:div,Expression.new([Step.new(nil,5),Step.new(:mtp,'y'),Step.new(:add,2)]))
        ]))
      step_2 = Step.new(:sbt,Expression.new([
          Step.new(nil,3),
          Step.new(:mtp,'a'),
          Step.new(:mtp,Expression.new([
              Step.new(nil,2),
              Step.new(:add,Expression.new([Step.new(nil,3),Step.new(:div,
                Expression.new([Step.new(nil,'x'),Step.new(:sbt,4,:lft)]))]))
            ])
          )
        ]))
      expression = Expression.new([step_1,step_2])
      result_latex = expression.latex
      expected_latex = "\\frac{4x}{5y+2}-3a\\left(2+\\frac{3}{4-x}\\right)"
      expect(result_latex).to eq expected_latex
    end
  end

  describe '#similar?' do
    it 'returns true when comparing two m-forms with same string valued steps' do
      expression_1 = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      expression_2 = Expression.new([Step.new(nil,3),Step.new(:mtp,'x')])
      expect(expression_1.similar?(expression_2)).to be true
    end

    it 'returns false if there is on non-m-form' do
      expression_1 = Expression.new([Step.new(nil,2),Step.new(:div,'x')])
      expression_2 = Expression.new([Step.new(nil,3),Step.new(:div,'x')])
      expect(expression_1.similar?(expression_2)).to be false
    end

    it 'returns false for two m-form with different string valued steps' do
      expression_1 = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      expression_2 = Expression.new([Step.new(nil,3),Step.new(:mtp,'y')])
      expect(expression_1.similar?(expression_2)).to be false
    end
  end

  describe '#convert_string_value_steps_to_m_forms?' do
    it 'does nothing and returns self if not a sum' do
      expression = Expression.new([Step.new(nil,'x'),Step.new(:div,'y')])
      expected_expression = Expression.new([Step.new(nil,'x'),Step.new(:div,'y')])
      expression.convert_string_value_steps_to_m_forms
      expect(expression).to eq expected_expression
    end

    it 'converts 1 string valued step to m-form' do
      expression = Expression.new([Step.new(nil,'x')])
      expression.convert_string_value_steps_to_m_forms
      expected_expression = Expression.new([Step.new(nil,Expression.new([Step.new(nil,1),Step.new(:mtp,'x')]))])
      expect(expression).to eq expected_expression
    end

    it 'converts 1 string valued step to m-form' do
      expression = Expression.new([Step.new(nil,'x'),Step.new(:sbt,'y',:lft)])
      expected_expression = Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,1),Step.new(:mtp,'x')])),
        Step.new(:sbt,Expression.new([Step.new(nil,1),Step.new(:mtp,'y')]),:lft)
        ])
      expect(expression.convert_string_value_steps_to_m_forms).to eq expected_expression
    end

    it 'makes no change if it is not a general m-form or rational sum' do
      expression = Expression.new([Step.new(nil,'x'),Step.new(:div,'y',:lft)])
      expected_expression = Expression.new([Step.new(nil,'x'),Step.new(:div,'y',:lft)])
      expect(expression.convert_string_value_steps_to_m_forms).to eq expected_expression
    end
  end

  describe '#simplify_m_form' do
    it 'returns self for a non-m-form' do
      expression = Expression.new([Step.new(nil,5),Step.new(:add,'x')])
      expected_expression = Expression.new([Step.new(nil,5),Step.new(:add,'x')])
      expression.simplify_m_form
      expect(expression).to eq expected_expression
    end

    it 'combines numerical steps into one step' do
      expression = Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),Step.new(:mtp,5)])
      expected_expression = Expression.new([Step.new(nil,10),Step.new(:mtp,'x')])
      expression.simplify_m_form
      expect(expression).to eq expected_expression
    end

    it 'adds nil 1 if there is no numerical value and string values are in order' do
      expression = Expression.new([Step.new(nil,'x'),Step.new(:mtp,'y'),Step.new(:mtp,'z')])
      expected_expression = Expression.new([Step.new(nil,1),Step.new(:mtp,'x'),
        Step.new(:mtp,'y'),Step.new(:mtp,'z')])
      expect(expression.simplify_m_form).to eq expected_expression
    end

    it 'sorts the string valued steps into alphabetical order' do
      expression = Expression.new([Step.new(nil,'c'),Step.new(:mtp,'b'),Step.new(:mtp,'a')])
      expected_expression = Expression.new([Step.new(nil,1),Step.new(:mtp,'a'),Step.new(:mtp,'b'),Step.new(:mtp,'c')])
      expression.simplify_m_form
      expect(expression).to eq expected_expression
    end

    it 'removes the numerical step if its value is 1' do
      expression = Expression.new([Step.new(nil,1),Step.new(:mtp,'b'),Step.new(:mtp,'a')])
      expected_expression = Expression.new([Step.new(nil,1),Step.new(:mtp,'a'),Step.new(:mtp,'b')])
      expect(expression.simplify_m_form).to eq expected_expression
    end

    it 'sorts the string valued steps and combines numerical steps' do
      expression = Expression.new([Step.new(nil,'c'),Step.new(:mtp,5),
        Step.new(:mtp,'a'),Step.new(:mtp,4),Step.new(:mtp,'b')])
      expected_expression = Expression.new([Step.new(nil,20),Step.new(:mtp,'a'),
        Step.new(:mtp,'b'),Step.new(:mtp,'c')])
      expect(expression.simplify_m_form).to eq expected_expression
    end
  end

  describe "#simplify_m_forms_in_sum" do
    it 'simplifies and 2 m_forms in a sum' do
      expression = Expression.new([
        Step.new(nil,Expression.new([
          Step.new(nil,2),Step.new(:mtp,'x'),Step.new(:mtp,3)
        ])),
        Step.new(:sbt,Expression.new([
          Step.new(nil,'c'),Step.new(:mtp,'b'),Step.new(:mtp,2)
        ]))
      ])
      expected_expression = Expression.new([
        Step.new(nil,Expression.new([
          Step.new(nil,6),Step.new(:mtp,'x')
        ])),
        Step.new(:sbt,Expression.new([
          Step.new(nil,2),Step.new(:mtp,'b'),Step.new(:mtp,'c')
        ]))
      ])
      expression.simplify_m_forms_in_sum
      expect(expression).to eq expected_expression
    end
  end

  describe '#convert_m_form_to_elementary' do
    it 'converts nil 1 x m-form to x string valued step' do
      expression = Expression.new([Step.new(nil,5),Step.new(:div,
        Expression.new([Step.new(nil,1),Step.new(:mtp,'x')]))])
      expected_expression = Expression.new([Step.new(nil,5),Step.new(:div,'x')])
      expect(expression.convert_m_form_to_elementary).to eq expected_expression
    end

    it 'converts nil 5 m-form to 5 numerical valued step' do
      expression = Expression.new([Step.new(nil,2),Step.new(:div,
        Expression.new([Step.new(nil,5)]))])
      expected_expression = Expression.new([Step.new(nil,2),Step.new(:div,5)])
      expect(expression.convert_m_form_to_elementary).to eq expected_expression
    end
  end

  describe '#simplify' do
    it 'combine two similar terms to one term' do
      exp_1 = Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])
      exp_2 = Expression.new([Step.new(nil,3),Step.new(:mtp,'x')])
      expression = Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])),
        Step.new(:add,Expression.new([Step.new(nil,3),Step.new(:mtp,'x')]))
      ])
      expected_expression = Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))
      ])
      expect(expression.simplify).to eq expected_expression
    end

    it 'combine two similar terms in a 3 term expression' do
      expression = Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])),
        Step.new(:add,Expression.new([Step.new(nil,3),Step.new(:mtp,'y')])),
        Step.new(:add,Expression.new([Step.new(nil,3),Step.new(:mtp,'x')]))
      ])
      expected_expression = Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')])),
        Step.new(:add,Expression.new([Step.new(nil,3),Step.new(:mtp,'y')]))
      ])
      expect(expression.simplify).to eq expected_expression
    end

    it 'combine two sets of two similar terms in a 4 term expression' do
      expression = Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),Step.new(:mtp,'z')])),
        Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'y')])),
        Step.new(:sbt,Expression.new([Step.new(nil,7),Step.new(:mtp,'y')])),
        Step.new(:add,Expression.new([Step.new(nil,3),Step.new(:mtp,'x'),Step.new(:mtp,'z')]))
      ])
      expected_expression = Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:mtp,'x'),Step.new(:mtp,'z')])),
        Step.new(:sbt,Expression.new([Step.new(nil,2),Step.new(:mtp,'y')]))
      ])
      expect(expression.simplify).to eq expected_expression
    end

    it 'combines numerical terms together' do
      expression = Expression.new([
        Step.new(nil,21),
        Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'y')])),
        Step.new(:sbt,11)
      ])
      expected_expression = Expression.new([
        Step.new(nil,10),
        Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'y')]))
      ])
      expect(expression.simplify).to eq expected_expression
    end

    it 'combines x with +2x' do
      expression = Expression.new([
        Step.new(nil,21),
        Step.new(:add,Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])),
        Step.new(:add,'x')
      ])
      expected_expression = Expression.new([
        Step.new(nil,21),
        Step.new(:add,Expression.new([Step.new(nil,3),Step.new(:mtp,'x')]))
      ])
      expect(expression.simplify).to eq expected_expression
    end

    it 'combines -y with -y' do
      expression = Expression.new([
        Step.new(nil,21),
        Step.new(:sbt,'y'),
        Step.new(:add,'x'),
        Step.new(:sbt,'y')
      ])
      expected_expression = Expression.new([
        Step.new(nil,21),
        Step.new(:sbt,Expression.new([Step.new(nil,2),Step.new(:mtp,'y')])),
        Step.new(:add,'x')
      ])
      expect(expression.simplify).to eq expected_expression
    end

    it 'deletes combined terms such as 0x' do
      expression = Expression.new([
        Step.new(nil,21),
        Step.new(:add,Expression.new([Step.new(nil,6),Step.new(:mtp,'y')])),
        Step.new(:sbt,Expression.new([Step.new(nil,2),Step.new(:mtp,'y')])),
        Step.new(:sbt,Expression.new([Step.new(nil,2),Step.new(:mtp,'y')])),
        Step.new(:sbt,Expression.new([Step.new(nil,2),Step.new(:mtp,'y')]))
      ])
      expected_expression = Expression.new([Step.new(nil,21)])
      expect(expression.simplify).to eq expected_expression
    end

    it 'if all terms cancel, expression left with nil 0 step' do
      expression = Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,'y')])),
        Step.new(:sbt,Expression.new([Step.new(nil,2),Step.new(:mtp,'y')])),
        Step.new(:sbt,Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),Step.new(:mtp,'z')])),
        Step.new(:add,Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),Step.new(:mtp,'z')])),
      ])
      expected_expression = Expression.new([Step.new(nil,0)])
      expect(expression.simplify).to eq expected_expression
    end

    it 'simplifies m-forms and combines like terms' do
      expression = Expression.new([
        Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,3)])),
        Step.new(:sbt,Expression.new([Step.new(nil,2),Step.new(:mtp,'x'),Step.new(:mtp,'y')])),
        Step.new(:sbt,Expression.new([Step.new(nil,3),Step.new(:mtp,'y'),Step.new(:mtp,'x')])),
        Step.new(:add,Expression.new([Step.new(nil,2)]))
      ])
      expected_expression = Expression.new([
        Step.new(nil,8),
        Step.new(:sbt,Expression.new([Step.new(nil,5),Step.new(:mtp,'x'),Step.new(:mtp,'y')]))
      ])
      expect(expression.simplify).to eq expected_expression
    end
  end

  describe '#first_two_steps_swap' do
    it 'swaps first two steps which are both numerical' do
      expression = Expression.new([Step.new(nil,2),Step.new(:mtp,3)])
      expected_expression = Expression.new([Step.new(nil,3),Step.new(:mtp,2,:lft)])
      expression.first_two_steps_swap
      expect(expression).to eq expected_expression
    end

    it 'returns self if the expression is empty' do
      expression = Expression.new([])
      expected_expression = Expression.new([])
      expression.first_two_steps_swap
      expect(expression).to eq expected_expression
    end

    it 'flattens the first expression if there is only one step' do
      expression = Expression.new([Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:div,5)]))])
      expected_expression = Expression.new([Step.new(nil,2),Step.new(:div,5)])
      expect(expression.first_two_steps_swap).to eq expected_expression
    end

    it 'swaps e step with n step' do
      expression = Expression.new([Step.new(nil,Expression.new([Step.new(nil,3),
        Step.new(:div,5)])),Step.new(:mtp,3)])
      expected_expression = Expression.new([Step.new(nil,3),Step.new(:mtp,
        Expression.new([Step.new(nil,3),Step.new(:div,5)]),:lft)])
      expression.first_two_steps_swap
      expect(expression).to eq expected_expression
    end

    it 'swaps n step with e step and flattens the e step' do
      expression = Expression.new([Step.new(nil,4),Step.new(:mtp,Expression.new([Step.new(nil,3),
        Step.new(:div,5)]))])
      expected_expression = Expression.new([Step.new(nil,3),Step.new(:div,5),Step.new(:mtp,4,:lft)])
      expression.first_two_steps_swap
      expect(expression).to eq expected_expression
    end

    it 'swaps e step with e step and flattens the e step' do
      expression = Expression.new([Step.new(nil,Expression.new([Step.new(nil,22),
        Step.new(:sbt,11)])),Step.new(:mtp,Expression.new([Step.new(nil,3),
        Step.new(:div,5)]))])
      expected_expression = Expression.new([Step.new(nil,3),Step.new(:div,5),
        Step.new(:mtp,Expression.new([Step.new(nil,22),Step.new(:sbt,11)]),:lft)])
      expression.first_two_steps_swap
      expect(expression).to eq expected_expression
    end
  end

  describe '#is_elementary?' do
    it 'returns true when contains only numerical or string valued steps' do
      expression = Expression.new([Step.new(nil,5),Step.new(:sbt,'x')])
      expect(expression.is_elementary?).to be true
    end

    it 'returns false when there is at least one expression valued step' do
      expression = Expression.new([Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:sbt,'x')]))])
      expect(expression.is_elementary?).to be false
    end
  end

  describe '#flatten_first_step?' do
    it 'flattens one layer of exp step' do
      expression = Expression.new([Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:sbt,'x')]))])
      expected_expression = Expression.new([Step.new(nil,5),Step.new(:sbt,'x')])
      expect(expression.flatten_first_step).to eq expected_expression
    end

    it 'flattens two layer of exp step' do
      expression = Expression.new([Step.new(nil,Expression.new([Step.new(nil,
        Expression.new([Step.new(nil,5),Step.new(:sbt,'x')]))]))])
      expected_expression = Expression.new([Step.new(nil,5),Step.new(:sbt,'x')])
      expect(expression.flatten_first_step).to eq expected_expression
    end

    # xit 'flattens all expressions whos first step value is an expression' do
    #   expression = Expression.new([
    #     Step.new(nil,
    #       Expression.new([
    #         Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:sbt,'x')]))])),
    #     Step.new(:add,
    #       Expression.new([
    #         Step.new(nil,Expression.new([Step.new(nil,6),Step.new(:sbt,'y')]))]))
    #     ])
    #   expected_expression = Expression.new([Step.new(nil,5),Step.new(:sbt,'x'),
    #     Step.new(:add,Expression.new([Step.new(nil,6),Step.new(:sbt,'y')]))
    #     ])
    #   expect(expression.flatten).to eq expected_expression
    # end
  end

  describe '#standardise_linear_expression' do
    it 'moves x term to first term in a flat expression' do
      expression = Expression.new([Step.new(nil,5),Step.new(:sbt,'x')])
      expected_expression = Expression.new([Step.new(nil,'x'),Step.new(:sbt,5,:lft)])
      expect(expression.standardise_linear_expression).to eq expected_expression
    end

    # xit 'flattens and moves x term to first term' do
    #   expression = Expression.new([Step.new(nil,Expression.new([Step.new(nil,5),Step.new(:sbt,'x')]))])
    #   expected_expression = Expression.new([Step.new(nil,'x'),Step.new(:sbt,5,:lft)])
    #   expect(expression.standardise_linear_expression).to eq expected_expression
    # end
  end

  describe '#expand' do
    it 'is a mutator method which returns the object itself' do
      exp = expression_factory.build([[nil,5],[:add,'x']])
      expected_exp = expression_factory.build([[nil,5],[:add,'x']])
      expect(exp.expand.object_id).to eq exp.object_id
    end

    it 'expands an addition step' do
      exp = expression_factory.build([[nil,5],[:add,'x']])
      expected_exp = expression_factory.build([[nil,5],[:add,'x']])
      expect(exp.expand).to eq expected_exp
    end

    it 'expands 2 addition steps' do
      exp = expression_factory.build([[nil,5],[:add,'x'],[:add,'y']])
      expected_exp = expression_factory.build([[nil,5],[:add,'x'],[:add,'y']])
      expect(exp.expand).to eq expected_exp
    end

    it 'expands addition step whos value is an expression of additions steps' do
      exp = expression_factory.build([[nil,5],[:add,[[nil,7],[:add,'x']]],[:add,'y']])
      expected_exp = expression_factory.build([[nil,5],[:add,7],[:add,'x'],[:add,'y']])
      expect(exp.expand).to eq expected_exp
    end

    # it 'expands e + m with no change' do
    #   exp = expression_factory.build([[nil,2],[:add,[[nil,'x'],[:mtp,'y']]]])
    #   expected_exp = expression_factory.build([[nil,2],[:add,[[nil,'x'],[:mtp,'y']]]])
    #   expect(exp.expand).to eq expected_exp
    # end

    it 'expands subtraction steps' do
      exp = expression_factory.build([[nil,4],[:sbt,'x']])
      expected_exp = expression_factory.build([[nil,4],[:sbt,'x']])
      expect(exp.expand).to eq expected_exp
    end

    it 'expands e - (e + e) into e - e - e' do
      exp = expression_factory.build([[nil,4],[:sbt,[[nil,'x'],[:add,7]]]])
      expected_exp = expression_factory.build([[nil,4],[:sbt,'x'],[:sbt,7]])
      expect(exp.expand).to eq expected_exp
    end

    it 'expands e - (e - e + e) into e - e + e - e' do
      exp = expression_factory.build([[nil,4],[:sbt,[[nil,'x'],[:sbt,7],[:add,'y']]]])
      expected_exp = expression_factory.build([[nil,4],[:sbt,'x'],[:add,7],[:sbt,'y']])
      expect(exp.expand).to eq expected_exp
    end

    it 'expands e - (e - (e - e)) into e - e + e - e' do
      exp = expression_factory.build([[nil,4],[:sbt,[[nil,'x'],[:sbt,[[nil,5],[:sbt,'y']]]]]])
      expected_exp = expression_factory.build([[nil,4],[:sbt,'x'],[:add,5],[:sbt,'y']])
      expect(exp.expand).to eq expected_exp
    end

    it 'expands e e into m' do
      exp = expression_factory.build([[nil,5],[:mtp,'z']])
      expected_exp = expression_factory.build([[nil,[[nil,5],[:mtp,'z']]]])
      expect(exp.expand).to eq expected_exp
    end

    it 'expands (e + e) e into m + m' do
      exp = expression_factory.build([[nil,4],[:add,'x'],[:mtp,5]])
      expected_exp = expression_factory.build([[nil,[[nil,4],[:mtp,5]]],
        [:add,[[nil,'x'],[:mtp,5]]]])
      expect(exp.expand).to eq expected_exp
    end

    it 'expands (e + m) e into m + m' do
      exp = expression_factory.build([[nil,4],[:add,[[nil,'x'],[:mtp,'y']]],[:mtp,5]])
      expected_exp = expression_factory.build([
        [nil,[[nil,4],[:mtp,5]]],[:add, [[nil,'x'],[:mtp,'y'],[:mtp,5]]]])
      expect(exp.expand).to eq expected_exp
    end

    it 'expands (e + m) m into m + m' do
      exp = expression_factory.build([[nil,4],[:add,[[nil,'x'],[:mtp,'y']]],
        [:mtp,[[nil,5],[:mtp,'z']]]])
      expected_exp = expression_factory.build([
        [nil,[[nil,4],[:mtp,5],[:mtp,'z']]],[:add, [[nil,'x'],[:mtp,'y'],[:mtp,5],[:mtp,'z']]]])
      expect(exp.expand).to eq expected_exp
    end

    it 'expands (e + e)(e - e) into m + m + m + m' do
      exp = expression_factory.build([[nil,4],[:add,'x'],[:mtp,[[nil,5],[:sbt,'y']]]])
      expected_exp = expression_factory.build([
        [nil,[[nil,4],[:mtp,5]]],[:add, [[nil,'x'],[:mtp,5]]],
        [:sbt, [[nil,4],[:mtp,'y']]],[:sbt, [[nil,'x'],[:mtp,'y']]]])
      expect(exp.expand).to eq expected_exp
    end

    it 'expands (e - e)(e - e)(e + e)' do
      exp = expression_factory.build([
        [nil,[[nil,4],[:sbt,'x']]],
        [:mtp,[[nil,7],[:sbt,'y']]],
        [:mtp,[[nil,5],[:add,'z']]]
      ])
      expected_exp = expression_factory.build([
        [nil,[[nil,4],[:mtp,7],[:mtp,5]]],
        [:sbt,[[nil,'x'],[:mtp,7],[:mtp,5]]],
        [:sbt,[[nil,4],[:mtp,'y'],[:mtp,5]]],
        [:add,[[nil,'x'],[:mtp,'y'],[:mtp,5]]],
        [:add,[[nil,4],[:mtp,7],[:mtp,'z']]],
        [:sbt,[[nil,'x'],[:mtp,7],[:mtp,'z']]],
        [:sbt,[[nil,4],[:mtp,'y'],[:mtp,'z']]],
        [:add,[[nil,'x'],[:mtp,'y'],[:mtp,'z']]]
      ])
      expect(exp.expand).to eq expected_exp
    end

    it 'expands ((e - m)m - (e + m))(e - m)' do
      step_1 = step_factory.build([nil,[[nil,2],[:sbt,[[nil,3],[:mtp,'x']]]]])
      step_2 = step_factory.build([:mtp,[[nil,4],[:mtp,'y']]])
      step_3 = step_factory.build([:sbt,[[nil,5],[:add,[[nil,6],[:mtp,'z']]]]])
      step_4 = step_factory.build([:mtp,[[nil,7],[:sbt,[[nil,8],[:mtp,'w']]]]])
      exp = expression_factory.build([step_1,step_2,step_3,step_4])
      expected_exp = expression_factory.build([
        [nil,[[nil,2],[:mtp,4],[:mtp,'y'],[:mtp,7]]],
        [:sbt,[[nil,3],[:mtp,'x'],[:mtp,4],[:mtp,'y'],[:mtp,7]]],
        [:sbt,[[nil,5],[:mtp,7]]],
        [:sbt,[[nil,6],[:mtp,'z'],[:mtp,7]]],
        [:sbt,[[nil,2],[:mtp,4],[:mtp,'y'],[:mtp,8],[:mtp,'w']]],
        [:add,[[nil,3],[:mtp,'x'],[:mtp,4],[:mtp,'y'],[:mtp,8],[:mtp,'w']]],
        [:add,[[nil,5],[:mtp,8],[:mtp,'w']]],
        [:add,[[nil,6],[:mtp,'z'],[:mtp,8],[:mtp,'w']]]
      ])
      expect(exp.expand).to eq expected_exp
    end
  end


end
