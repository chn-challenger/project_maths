require './models/evaluate'
require './models/equation'
require './models/linear_equation'


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
      left_side = Expression.new([Step.new(nil,'x'),Step.new(:mtp,time_1_val,:lft),Step.new(:add,time_diff)])
    end
    right_side = Expression.new([Step.new(nil,'x'),Step.new(:add,time_diff),Step.new(:mtp,time_2_val,:lft)])
    @equation = Equation.new(left_side,right_side)
  end

  def solution
    sol_eqn_array = [equation]
    step_2 = equation.copy._age_problem_expand
    sol_eqn_array << step_2
    step_3 = step_2.copy.collect_like_terms
    sol_eqn_array << step_3
    step_4 = step_3.copy._age_problem_simplify_m_sums.standardise_linear_equation
    # sol_eqn_array << step_4
    return step_4
    # l_eqn = linear_equation.new(step_4.left_side,step_4.right_side)
    # l_eqn_soln = l_eqn._generate_solution
    # sol_eqn_array = sol_eqn_array + l_eqn_soln
    # return sol_eqn_array
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
