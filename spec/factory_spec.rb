require './models/factory'

describe ExpressionFactory do
  describe '#build' do
    it 'can create an empty expression' do
      step_config_array = []
      expected_exp = Expression.new([])
      expect(ExpressionFactory.build(step_config_array)).to eq expected_exp
    end

    it 'creates an expression of one step' do
      step_config_array = [[nil,5]]
      expected_exp = Expression.new([Step.new(nil,5)])
      expect(ExpressionFactory.build(step_config_array)).to eq expected_exp
    end

    it 'creates an expression of one step when given full config' do
      step_config_array = [[nil,5,:rgt]]
      expected_exp = Expression.new([Step.new(nil,5)])
      expect(ExpressionFactory.build(step_config_array)).to eq expected_exp
    end

    it 'creates an expression when given an array of step-configs' do
      step_config_array = [[nil,5],[:mtp,'x']]
      expected_exp = Expression.new([Step.new(nil,5),Step.new(:mtp,'x')])
      expect(ExpressionFactory.build(step_config_array)).to eq expected_exp
    end

    it 'creates an expression where one of the steps has an expression value' do
      step_config_array = [[nil,5],[:mtp,[[nil,7],[:div,'x']]]]
      expected_exp = Expression.new([Step.new(nil,5),Step.new(:mtp,
        Expression.new([Step.new(nil,7),Step.new(:div,'x')]))])
      expect(ExpressionFactory.build(step_config_array)).to eq expected_exp
    end

    it 'creates 2 level multiple nested expression' do
      step_config_array = [[nil,5],[:mtp,[[nil,7],[:div,[[nil,2],[:add,3,:lft]]]]]]
      expected_exp = Expression.new([Step.new(nil,5),Step.new(:mtp,
        Expression.new([Step.new(nil,7),Step.new(:div,Expression.new([Step.new(nil,2),Step.new(:add,3,:lft)]))]))])
      expect(ExpressionFactory.build(step_config_array)).to eq expected_exp
    end

    it 'creates an expression of one step whose value is an expression' do
      step_config_array = [[nil,[[nil,2],[:add,7]]]]
      expected_exp = Expression.new([Step.new(nil,Expression.new([
        Step.new(nil,2),Step.new(:add,7)]))])
      expect(ExpressionFactory.build(step_config_array)).to eq expected_exp
    end

    it 'creates an expresion when given an array of steps' do
      step_1, step_2 = Step.new(:add,5), Step.new(:add,'x')
      step_config_array = [step_1,step_2]
      expected_exp = Expression.new([Step.new(:add,5), Step.new(:add,'x')])
      expect(ExpressionFactory.build(step_config_array)).to eq expected_exp
    end

    it 'creates exp when given a mixed array of configs and steps' do
      step_1, step_2 = Step.new(:add,5), Step.new(:add,'x')
      step_config_array = [[nil,2],step_1,step_2,[:mtp,[[nil,2]]]]
      expected_exp = Expression.new([Step.new(nil,2),Step.new(:add,5),Step.new(:add,'x'),
          Step.new(:mtp,Expression.new([Step.new(nil,2)]))])
      expect(ExpressionFactory.build(step_config_array)).to eq expected_exp
    end
  end
end

describe StepFactory do
  describe '#build' do
    it 'builds a basic step with default direction' do
      step_config = [:add,5]
      expected_step = Step.new(:add,5,:rgt)
      expect(StepFactory.build(step_config)).to eq expected_step
    end

    it 'builds a basic step with given direction' do
      step_config = [:add,5,:lft]
      expected_step = Step.new(:add,5,:lft)
      expect(StepFactory.build(step_config)).to eq expected_step
    end

    it 'builds a step with expression building config' do
      step_config = [:add,[[nil,2],[:mtp,'x']],:lft]
      expected_step = Step.new(:add,Expression.new([Step.new(nil,2),
        Step.new(:mtp,'x')]),:lft)
      expect(StepFactory.build(step_config)).to eq expected_step
    end

    it 'builds a step with an expression value' do
      step_config = [:add,Expression.new([])]
      expected_step = Step.new(:add,Expression.new([]),:rgt)
      expect(step_factory.build(step_config)).to eq expected_step
    end
  end
end

describe MtpFormFactory do
  describe '#build' do
    it 'builds a 1 step m-form expression' do
      config = [4]
      expected_exp = expression_class.new([step_class.new(nil,4)])
      expect(mform_factory.build(config)).to eq expected_exp
    end

    it 'builds a 3 step m-form expression' do
      config = [4,'x','y']
      expected_exp = expression_class.new([step_class.new(nil,4),
        step_class.new(:mtp,'x'),step_class.new(:mtp,'y')])
      expect(mform_factory.build(config)).to eq expected_exp
    end

    it 'builds a 5 step m-form expression' do
      config = [4,5,6,7,8]
      expected_exp = expression_factory.build([[nil,4],[:mtp,5],[:mtp,6],
        [:mtp,7],[:mtp,8]])
      expect(mform_factory.build(config)).to eq expected_exp
    end

    it 'builds a 3 step compound m-form expression' do
      config = [4,[[nil,'x'],[:add,'y']],6]
      expected_exp = expression_factory.build([[nil,4],[:mtp,[[nil,'x'],[:add,'y']]],[:mtp,6]])
      expect(mform_factory.build(config)).to eq expected_exp
    end
  end
end

describe MtpFormSumFactory do
  describe '#build' do
    it 'builds a 1 step m-form-sum expression' do
      config = [[nil,[2,'x']]]
      expected_exp = expression_factory.build([[nil,[[nil,2],[:mtp,'x']]]])
      expect(msum_factory.build(config)).to eq expected_exp
    end

    it 'builds a 2 step m-form-sum expression' do
      config = [[nil,[2,'x']],[:sbt,[3,'y']]]
      expected_exp = expression_factory.build([
        [nil,[[nil,2],[:mtp,'x']]],
        [:sbt,[[nil,3],[:mtp,'y']]]
        ])
      expect(msum_factory.build(config)).to eq expected_exp
    end

    it 'builds a 3 step m-form-sum expression' do
      config = [[nil,[2,'x']],[:sbt,[3,'y']],[:add,[4,'z','w']]]
      expected_exp = expression_factory.build([
        [nil,[[nil,2],[:mtp,'x']]],
        [:sbt,[[nil,3],[:mtp,'y']]],
        [:add,[[nil,4],[:mtp,'z'],[:mtp,'w']]]
        ])
      expect(msum_factory.build(config)).to eq expected_exp
    end
  end
end
