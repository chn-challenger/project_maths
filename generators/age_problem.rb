require './generators/evaluate'
require './generators/equation'
require './generators/linear_equation'


class AgeProblem

  attr_accessor :time_1_rel, :time_1_val, :time_diff, :time_2_val, :equation

  def initialize(time_1_rel,time_1_val,time_diff,time_2_val)
    @time_1_rel = time_1_rel
    @time_1_val = time_1_val
    @time_diff = time_diff
    @time_2_val = time_2_val
    @equation = Equation.new()
    if time_1_rel == :add
      total_time_diff = time_1_val + time_diff
      left_side = Expression.new([Step.new(nil,'x'),Step.new(:add,total_time_diff)])
    elsif time_1_rel == :mtp
      left_side = Expression.new([Step.new(nil,'x'),Step.new(:mtp,time_1_val),Step.new(:add,time_diff)])
    end
    right_side = Expression.new([Step.new(nil,'x'),Step.new(:add,time_diff),Step.new(:mtp,time_2_val)])
    @equation = Equation.new(left_side,right_side)
  end

  def solution
    result = []
    stage_1 = equation
    result << stage_1
    stage_2 = stage_1.copy
    stage_2.left_side = stage_2.left_side.convert_to_rational_sum.simplify
    stage_2.right_side = stage_2.right_side.convert_to_rational_sum.simplify
    stage_2.left_side.convert_if_m_form_to_elementary
    stage_2.right_side.convert_if_m_form_to_elementary
    result << stage_2
    # #this should be replaced by a more permenant solution work on logic
    stage_3 = stage_2.copy
    reverse_step = stage_3.left_side.steps.delete_at(0)
    stage_3.left_side.steps.first.ops = nil
    reverse_step.ops = :sbt
    stage_3.right_side.steps << reverse_step
    result << stage_3
    stage_4 = stage_3.copy
    stage_4.right_side = stage_4.right_side.simplify
    stage_4.right_side.convert_if_m_form_to_elementary
    result << stage_4
    stage_5 = stage_4.copy
    linear_equation = LinearEquation.new(stage_5.right_side,stage_5.left_side)
    linear_equation_solution = linear_equation._generate_solution
    result = result + linear_equation_solution
    result
  end

  def self._solution_latex(solutions_array)
    result = ''
    solutions_array.each do |solution_equation|
      result += solution_equation.latex + '\\\\' + "\n"
    end
    result.slice!(-3..-1)
    result
  end




  def self._generate_solution_basics(question)
    #[equations to get to the solution]
  end

  def self._generate_question_basics()
    generated_question
    solution = generated_question._generate_solution_basics
    if solution.is_not_integer?
      return self_generate_question_basics
    else
      return {question:generate_question,solution:solution}
    end
  end



end
