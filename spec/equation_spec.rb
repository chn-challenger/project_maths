require './models/equation'

describe Equation do
  describe '#initialize/new' do
    let(:equation){described_class.new}

    it 'initialize with a left side expression' do
      expect(equation.left_side).to eq Expression.new
    end

    it 'initialize with a right side expression' do
      expect(equation.right_side).to eq Expression.new
    end

    it 'initialize with a solution hash' do
      expect(equation.solution).to be {}
    end
  end

  describe '#==' do
    it 'can determine equivalence of two default equations' do
      equation1 = Equation.new
      equation2 = Equation.new
      expect(equation1).to eq equation2
    end

    it 'can determine equivalence of two equations with steps' do
      equation1 = Equation.new(Expression.new([Step.new(nil,'x'),
        Step.new(:add,5)]),Expression.new([Step.new(nil,11)]))
      equation2 = Equation.new(Expression.new([Step.new(nil,'x'),
        Step.new(:add,5)]),Expression.new([Step.new(nil,11)]))
      expect(equation1).to eq equation2
    end

    it 'can determine non-equivalence of two equations with steps' do
      equation1 = Equation.new(Expression.new([Step.new(nil,'x'),
        Step.new(:add,5)]),Expression.new([Step.new(nil,11,:lft)]))
      equation2 = Equation.new(Expression.new([Step.new(nil,'x'),
        Step.new(:add,5)]),Expression.new([Step.new(nil,11)]))
      expect(equation1).not_to eq equation2
    end
  end

  describe '#copy' do
    shared_context 'self copy' do
      before(:all) do
        @step1 = Step.new(:add,5,:lft)
        @step2 = Step.new(:sbt,7,:rgt)
        @step3 = Step.new(:mtp,3,:lft)
        @step4 = Step.new(:div,4,:rgt)
        @expression1 = Expression.new([@step1,@step2])
        @expression2 = Expression.new([@step3,@step4])
        @equation = Equation.new(@expression1,@expression2)
        @equation_copy = @equation.copy
      end
    end

    include_context 'self copy'

    it 'returns an instance of the class with same states' do
      expect(@equation).to eq @equation_copy
    end

    it 'the copied instance states have different object_ids example' do
      copied_equation_state_object_id = @equation_copy.left_side.steps.first.object_id
      expect(@equation.left_side.steps.first.object_id).not_to eq copied_equation_state_object_id
    end

    it 'returns a different instance of the class with same states' do
      expect(@equation.object_id).not_to eq @equation_copy.object_id
    end
  end

  describe '#latex' do
    it 'returns latex for with alignment &&' do
      left_side = double(:left_exp,latex:'left latex')
      right_side = double(:right_exp,latex:'right latex')
      equation = Equation.new(left_side,right_side)
      expect(equation.latex).to eq 'left latex&=right latex'
    end

    it 'returns latex for without alignment &&' do
      left_side = double(:left_exp,latex:'left latex')
      right_side = double(:right_exp,latex:'right latex')
      equation = Equation.new(left_side,right_side)
      expect(equation.latex(false)).to eq 'left latex=right latex'
    end
  end

  describe '#collect_like_terms' do
    # it 'collects one set of like terms (similar m-forms) from left to right side' do
    #   left_side = Expression.new([Step.new(nil,2),Step.new(:add,Expression.new([
    #     Step.new(nil,3),Step.new(:mtp,'x')]))])
    #   right_side = Expression.new([Step.new(nil,2),Step.new(:add,Expression.new([
    #     Step.new(nil,4),Step.new(:mtp,'x')]))])
    #   equation = Equation.new(left_side,right_side)
    #   expected_left_side = Expression.new([Step.new(nil,2)])
    #   expected_right_side = Expression.new([Step.new(nil,2),Step.new(:add,
    #     Expression.new([Step.new(nil,4),Step.new(:mtp,'x')])),Step.new(:sbt,
    #     Expression.new([Step.new(nil,3),Step.new(:mtp,'x')]))])
    #   expected_equation = Equation.new(expected_left_side,expected_right_side)
    #   expect(equation.collect_like_terms).to eq expected_equation
    # end
    #
    # it 'collects one set to left and one set to right' do
    #   left_side = Expression.new([Step.new(nil,2),Step.new(:add,Expression.new([Step.new(nil,3),Step.new(:mtp,'y')])),Step.new(:sbt,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))])
    #   right_side = Expression.new([Step.new(nil,2),Step.new(:sbt,Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])),Step.new(:sbt,Expression.new([Step.new(nil,3),Step.new(:mtp,'y')]))])
    #   equation = Equation.new(left_side,right_side)
    #   expected_left_side = Expression.new([Step.new(nil,2),Step.new(:add,Expression.new([Step.new(nil,3),Step.new(:mtp,'y')])),Step.new(:add,Expression.new([Step.new(nil,3),Step.new(:mtp,'y')]))])
    #   expected_right_side = Expression.new([Step.new(nil,2),Step.new(:sbt,Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])),Step.new(:add,Expression.new([Step.new(nil,5),Step.new(:mtp,'x')]))])
    #   expected_equation = Equation.new(expected_left_side,expected_right_side)
    #   expect(equation.collect_like_terms).to eq expected_equation
    # end

    it 'collects 2 sets of like terms' do
      left_side = msum_factory.build([[nil,[2,'b']],[:add,[6,'x']],[:sbt,[4,'y']]])
      right_side = msum_factory.build([[nil,[5,'a']],[:add,[2,'x']],[:add,[2,'y']]])
      equation = Equation.new(left_side,right_side)
      new_left_side = msum_factory.build([[nil,[2,'b']],[:add,[6,'x']],[:sbt,[2,'x']]])
      new_right_side = msum_factory.build([[nil,[5,'a']],[:add,[2,'y']],[:add,[4,'y']]])
      expected_equation = Equation.new(new_left_side,new_right_side)
      expect(equation.collect_like_terms).to eq expected_equation

      #once a term has been moved or added, the number of terms on both sides
      #change causing the iterations to fail

    end

  end


end
