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
      expected_exp = msum_factory.build([
          [nil,[2,4,'y',7]],        [:sbt,[3,'x',4,'y',7]],
          [:sbt,[5,7]],             [:sbt,[6,'z',7]],
          [:sbt,[2,4,'y',8,'w']],   [:add,[3,'x',4,'y',8,'w']],
          [:add,[5,8,'w']],         [:add,[6,'z',8,'w']]
        ])
      result = exp.expand
      expect(exp.expand).to eq expected_exp
    end
    #
    # it 'expands (e + e) / e' do
    #   exp = expression_factory.build([[nil,4],[:add,'x'],[:div,11]])
    #   expected_exp = expression_factory.build([
    #     [nil,[[nil,  [[nil,4]]  ],[:div, [[nil,11]]  ]]],
    #     [:add,[[nil,'x'],[:div,11]]]])
    #   puts exp.latex
    #   puts expected_exp.latex
    #
    # end

    #THIS IS RUNNING INTO THE SAME PROBLEMS AS PREVIOUS ITERATION OF THIS METHOD
    #THIS TIME, I WILL CREATE A METHOD FOR EXPANDING RATIONAL SUMS WHERE
    #TO MAKE THINGS EASIER TO MANAGE, EVERY TERM WILL BE RATIONAL.

  end

  describe 'expand_to_rsum' do
    it 'expands an e step to a rsum' do
      exp = expression_factory.build([[nil,5]])
      r_conf = [[5], [ [nil,[1]] ]]
      r_sum_conf = [[nil,r_conf]]
      expected_exp = rsum_factory.build(r_sum_conf)
      expect(exp.expand_to_rsum).to eq expected_exp
    end

    it 'expands an m step to a rsum' do
      exp = expression_factory.build([[nil,[[nil,5],[:mtp,'x']] ]])
      r_conf = [[5,'x'], [ [nil,[1]] ]]
      r_sum_conf = [[nil,r_conf]]
      expected_exp = rsum_factory.build(r_sum_conf)
      expect(exp.expand_to_rsum).to eq expected_exp
    end

    it 'expands_to_rsum is a mutator method' do
      exp = expression_factory.build([[nil,[[nil,5],[:mtp,'x']] ]])
      r_conf = [[5,'x'], [ [nil,[1]] ]]
      r_sum_conf = [[nil,r_conf]]
      expected_exp = rsum_factory.build(r_sum_conf)
      exp.expand_to_rsum
      expect(exp).to eq expected_exp
    end

    it 'expands_to_rsum is a mutator method that returns self' do
      exp = expression_factory.build([[nil,[[nil,5],[:mtp,'x']] ]])
      r_conf = [[5,'x'], [ [nil,[1]] ]]
      r_sum_conf = [[nil,r_conf]]
      expected_exp = rsum_factory.build(r_sum_conf)
      result = exp.expand_to_rsum
      expect(exp.object_id).to eq result.object_id
    end

    it 'expands an unflattend e step exp' do
      exp = expression_factory.build([[nil,[[nil,5]]]])
      r_conf = [[5], [ [nil,[1]] ]]
      r_sum_conf = [[nil,r_conf]]
      expected_exp = rsum_factory.build(r_sum_conf)
      expect(exp.expand_to_rsum).to eq expected_exp
    end

    it 'expands a 2 layer unflattend e step exp' do
      exp = expression_factory.build([[nil,[[nil,[[nil,5]]]]]])
      r_conf = [[5], [ [nil,[1]] ]]
      r_sum_conf = [[nil,r_conf]]
      expected_exp = rsum_factory.build(r_sum_conf)
      expect(exp.expand_to_rsum).to eq expected_exp
    end

    # it 'expands (r) exp into itself (r) - no change' do
    #   r_conf = [[5,'x'], [ [nil,['y']] ]]
    #   r_sum_conf = [[nil,r_conf]]
    #   exp = rsum_factory.build(r_sum_conf)
    #   expected_exp = rsum_factory.build(r_sum_conf)
    #   expect(exp.expand_to_rsum).to eq expected_exp
    # end

  end

  #
  # describe '#flatten' do
  #   it 'flattens a one layer of exp step exp wrapping' do
  #     exp = expression_factory.build([[nil,[[nil,5]]]])
  #     expected_exp = expression_factory.build([[nil,5]])
  #     expect(exp.flatten).to eq expected_exp
  #   end
  #
  #   it 'flattens a one layer wrapping of two steps' do
  #     exp = expression_factory.build([[nil,[[nil,5],[:mtp,'x']]]])
  #     expected_exp = expression_factory.build([[nil,5],[:mtp,'x']])
  #     expect(exp.flatten).to eq expected_exp
  #   end
  #
  #   it 'flattens a 2 layer of exp step exp wrapping' do
  #     exp = expression_factory.build([[nil,[[nil,[[nil,5]]]]]])
  #     expected_exp = expression_factory.build([[nil,5]])
  #     expect(exp.flatten).to eq expected_exp
  #   end
  #
  #   it 'flattens a 4 layer of exp step exp wrapping' do
  #     exp = expression_factory.build([[nil,[[nil,[[nil,[[nil,[[nil,5]]]]]]]]]])
  #     expected_exp = expression_factory.build([[nil,5]])
  #     expect(exp.flatten).to eq expected_exp
  #   end
  #
  #
  #   it 'flattens layers of wrapping recursively eg 1' do
  #     exp = expression_factory.build([[nil,[[nil,'x'], [:add,[[nil,
  #       [[nil,5]]]]]]]])
  #     expected_exp = expression_factory.build([[nil,'x'],[:add,[[nil,5]]]])
  #     expect(exp.flatten).to eq expected_exp
  #   end
  #
  #   it 'flattens layers of wrapping recursively eg 2' do
  #     exp = expression_factory.build([[nil,[[nil,'x'], [:add,[[nil,[[nil,5],
  #       [:mtp,'y']]]]]]]])
  #     expected_exp = expression_factory.build([[nil,'x'],[:add,[[nil,5],[:mtp,'y']]]])
  #     expect(exp.flatten).to eq expected_exp
  #   end
  #
  #   it 'flattens layers of wrapping recursively eg 3' do
  #     exp = expression_factory.build([[nil,[[nil,'x'], [:add,[[nil,[[nil,5],
  #       [:mtp,[[nil,[[nil,'y']]]]]]]]]]]])
  #     expected_exp = expression_factory.build([[nil,'x'],[:add, [[nil,5],[:mtp,
  #       [[nil,'y']]]]]])
  #     result = exp.flatten
  #     expect(result).to eq expected_exp
  #   end
  #
  #   it 'flattens is a mutator method that modifies and returns self' do
  #     exp = expression_factory.build([[nil,[[nil,'x'], [:add,[[nil,[[nil,5],
  #       [:mtp,[[nil,[[nil,'y']]]]]]]]]]]])
  #     expected_exp = expression_factory.build([[nil,'x'],[:add, [[nil,5],[:mtp,
  #       [[nil,'y']]]]]])
  #     result = exp.flatten
  #     expect(exp.object_id).to eq result.object_id
  #   end
  #
  #   it 'flattens the second term of an exp with flatten being a mutator' do
  #     exp = expression_factory.build([[nil,7],[:mtp,[[nil,[[nil,'x']]]]]])
  #     expected_exp = expression_factory.build([[nil,7],[:mtp,[[nil,'x']]]])
  #     result = exp.flatten
  #     expect(exp.steps.last.val.object_id).to eq result.steps.last.val.object_id
  #   end
  # end
  #
  # describe '#latex' do
  #   it 'produce an empty string for empty exp' do
  #     exp = expression_factory.build([])
  #     expect(exp.latex).to eq ''
  #   end
  #
  #   it 'produce latex for a single nil numerical e step' do
  #     exp = expression_factory.build([[nil,2]])
  #     expect(exp.latex).to eq '2'
  #   end
  #
  #   it 'produce latex for a single nil string value e step' do
  #     exp = expression_factory.build([[nil,'x']])
  #     expect(exp.latex).to eq 'x'
  #   end
  #
  #   it 'produce latex for e + e' do
  #     exp = expression_factory.build([[nil,'x'],[:add,3]])
  #     expect(exp.latex).to eq 'x+3'
  #   end
  #
  #   it 'produce latex for e - e' do
  #     exp = expression_factory.build([[nil,'x'],[:sbt,3]])
  #     expect(exp.latex).to eq 'x-3'
  #   end
  #
  #   it 'produce latex for e - e + e' do
  #     exp = expression_factory.build([[nil,'x'],[:sbt,3],[:add,'y']])
  #     expect(exp.latex).to eq 'x-3+y'
  #   end
  #
  #   it 'produce latex for e + (e - e)' do
  #     exp = expression_factory.build([[nil,'x'],[:add,[[nil,5],[:sbt,'y']]]])
  #     expect(exp.latex).to eq 'x+\left(5-y\right)'
  #   end
  #
  #   it 'produce latex for e - (e - e)' do
  #     exp = expression_factory.build([[nil,'x'],[:sbt,[[nil,5],[:sbt,'y']]]])
  #     expect(exp.latex).to eq 'x-\left(5-y\right)'
  #   end
  #
  #   it 'produce latex for (e - e) + e' do
  #     exp = expression_factory.build([[nil,[[nil,5],[:sbt,'y']]],[:add,'x']])
  #     expect(exp.latex).to eq '5-y+x'
  #   end
  #
  #   it 'produce latex for (e - e) x e' do
  #     exp = expression_factory.build([[nil,5],[:sbt,'y'],[:mtp,'x']])
  #     expect(exp.latex).to eq '\left(5-y\right)x'
  #   end
  #
  #   it 'produce latex for (e - e)(e + e)' do
  #     exp = expression_factory.build([[nil,5],[:sbt,'y'],[:mtp,[[nil,3],[:add,'x']]]])
  #     expect(exp.latex).to eq '\left(5-y\right)\left(3+x\right)'
  #   end
  #
  #   it 'produce latex for (e - e)m' do
  #     exp = expression_factory.build([[nil,5],[:sbt,'y'],[:mtp,[[nil,3],[:mtp,'x']]]])
  #     expect(exp.latex).to eq '\left(5-y\right)3x'
  #   end
  #
  #   it 'produce latex for (e - e) x large m' do
  #     exp = expression_factory.build([[nil,5],[:sbt,'y'],[:mtp,[[nil,3],[:mtp,'x'],[:mtp,'z']]]])
  #     expect(exp.latex).to eq '\left(5-y\right)3xz'
  #   end
  #
  #   it 'produce latex for ((e - m)m - (e + m))(e - m)' do
  #     step_1_1 = step_factory.build([nil,2])
  #     step_1_2 = step_factory.build([:sbt,[[nil,3],[:mtp,'x']]])
  #     step_2 = step_factory.build([:mtp,[[nil,4],[:mtp,'y']]])
  #     step_3 = step_factory.build([:sbt,[[nil,5],[:add,[[nil,6],[:mtp,'z']]]]])
  #     step_4 = step_factory.build([:mtp,[[nil,7],[:sbt,[[nil,8],[:mtp,'w']]]]])
  #     exp = expression_factory.build([step_1_1,step_1_2,step_2,step_3,step_4])
  #     expected_latex = "\\left(\\left(2-3x\\right)4y-\\left(5+6z\\right)\\righ"\
  #       "t)\\left(7-8w\\right)"
  #     expect(exp.latex).to eq expected_latex
  #   end
  #
  #   it 'produce latex for (m + m - m) e m' do
  #     exp = expression_factory.build([[nil, [[nil,5],[:mtp,'x']]  ],
  #       [:add, [[nil,2],[:mtp,'y']] ],[:sbt, [[nil,3],[:mtp,'z']] ],
  #       [:mtp,'a'],[:mtp, [[nil,4],[:mtp,'w']] ]])
  #     expected_latex = "\\left(5x+2y-3z\\right)a4w"
  #     expect(exp.latex).to eq expected_latex
  #   end
  #
  #   it 'produce latex for ((m + e - m) + e - (m + e))e m' do
  #     msum_exp = msum_factory.build([[nil,[2,'a']],[:sbt,[3]],[:add,[4,'b','c']]])
  #     step_1 = step_factory.build([nil,msum_exp])
  #     step_2 = step_factory.build([:add,5])
  #     msum_exp_2 = msum_factory.build([[nil,[6,'d']],[:sbt,['e']]])
  #     step_3 = step_factory.build([:sbt,msum_exp_2])
  #     step_4 = step_factory.build([:mtp,7])
  #     step_5 = step_factory.build([:mtp,[[nil,[[nil,'x'],[:mtp,'y']]]]])
  #     exp = expression_factory.build([step_1,step_2,step_3,step_4,step_5])
  #     expected_latex = '\left(2a-3+4bc+5-\left(6d-e\right)\right)7xy'
  #     expect(exp.latex).to eq expected_latex
  #   end
  #
  #   it 'produce latex for e/e' do
  #     exp = expression_factory.build([[nil,'x'],[:div,5]])
  #     expect(exp.latex).to eq '\frac{x}{5}'
  #   end
  #
  #   it 'produce latex for e/e - e' do
  #     exp = expression_factory.build([[nil,'x'],[:div,5],[:sbt,'y']])
  #     expect(exp.latex).to eq '\frac{x}{5}-y'
  #   end
  #
  #   it 'produce latex for m/(e - e) + m' do
  #     exp = expression_factory.build([[nil,[[nil,2],[:mtp,'x']]],
  #       [:div,[[nil,3],[:sbt,'w']]],[:add,[[nil,'a'],[:mtp,'b']]]])
  #     expect(exp.latex).to eq '\frac{2x}{3-w}+ab'
  #   end
  #
  #   it 'produce latex for m/(e - e) + e/e' do
  #     exp = expression_factory.build([[nil,[[nil,2],[:mtp,'x']]],
  #       [:div,[[nil,3],[:sbt,'w']]],[:add,[[nil,'a'],[:div,'b']]]])
  #     expect(exp.latex).to eq '\frac{2x}{3-w}+\frac{a}{b}'
  #   end
  #
  #   it 'produce latex for (m/(e - e) + e/e)m - e/e' do
  #     exp = expression_factory.build([[nil,[[nil,2],[:mtp,'x']]],
  #       [:div,[[nil,3],[:sbt,'w']]],[:add,[[nil,'a'],[:div,'b']]],
  #       [:mtp,[[nil,4],[:mtp,'c']]],[:sbt,[[nil,11],[:div,'f']]]])
  #     expected_latex = '\left(\frac{2x}{3-w}+\frac{a}{b}\right)4c-\frac{11}{f}'
  #     expect(exp.latex).to eq expected_latex
  #   end
  #
  #   it 'produce latex for (((m/e + m - e) e + m) / (e-m) + m)(e / m-m + e)' do
  #     step_1 = step_factory.build([nil,[[nil,[[nil,2],[:mtp,'a']]],[:div,3],
  #       [:add,[[nil,4],[:mtp,'b']]],[:sbt,'c']]])
  #     step_2 = step_factory.build([:mtp,5])
  #     step_3 = step_factory.build([:add,[[nil,6],[:mtp,'d']]])
  #     step_4 = step_factory.build([:div,[[nil,6],[:sbt, [[nil,[[nil,7],[:mtp,'e']]]]        ]]])
  #     step_5 = step_factory.build([:add,[[nil,8],[:mtp,'f']]])
  #     step_6 = step_factory.build([:mtp,[[nil,9],[:div,  [[nil,
  #       [[nil,10],[:mtp,'x']]],[:sbt,[[nil,11],[:mtp,'y']]]]],[:add,12]]])
  #     exp = expression_factory.build([step_1,step_2,step_3,step_4,step_5,step_6])
  #     expected_latex = '\left(\frac{\left(\frac{2a}{3}+4b-c\right)5+6d}{6-7e}+8f\right)\left(\frac{9}{10x-11y}+12\right)'
  #     expect(exp.latex).to eq expected_latex
  #   end
  # end
  #
  #
  #

end
