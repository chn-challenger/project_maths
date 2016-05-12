require './models/expression_factory'

describe ExpressionFactory do
  describe '#build' do
    it 'creates an expression of one step' do
      step_config_array = [5]
      expected_exp = Expression.new([Step.new(nil,5)])
      expect(ExpressionFactory.build(step_config_array)).to eq expected_exp
    end

    it 'creates an expression when given an array of step-configs' do
      step_config_array = [5,[:mtp,'x']]
      expected_exp = Expression.new([Step.new(nil,5),Step.new(:mtp,'x')])
      expect(ExpressionFactory.build(step_config_array)).to eq expected_exp
    end

    it 'creates an expression where one of the steps has an expression value' do
      step_config_array = [5,[:mtp,[7,[:div,'x']]]]
      expected_exp = Expression.new([Step.new(nil,5),Step.new(:mtp,
        Expression.new([Step.new(nil,7),Step.new(:div,'x')]))])
      expect(ExpressionFactory.build(step_config_array)).to eq expected_exp
    end

    it 'creates 2 level multiple nested expression' do
      step_config_array = [5,[:mtp,[7,[:div,[2,[:add,3,:lft]]]]]]
      expected_exp = Expression.new([Step.new(nil,5),Step.new(:mtp,
        Expression.new([Step.new(nil,7),Step.new(:div,Expression.new([Step.new(nil,2),Step.new(:add,3,:lft)]))]))])
      expect(ExpressionFactory.build(step_config_array)).to eq expected_exp
    end

    it 'creates an expression of one step whose value is an expression' do
      step_config_array = [[2,[:add,7]]]
      expected_exp = Expression.new([Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:add,7)]))])
      expect(ExpressionFactory.build(step_config_array)).to eq expected_exp
    end
  end
end
