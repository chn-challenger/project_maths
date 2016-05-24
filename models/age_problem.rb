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

  def self.generate_add_type_question
    #based on the following formula for (:add,a,b,c) question
    # a/(c - 1) = x + b
    # a = age_difference, b = time_diff, c = mtp_val
    age_difference = (4..80).to_a.sample
    mtp_val_choices = (1..8).to_a.select{|n| age_difference%n == 0 && age_difference + age_difference/n <= 90 && age_difference/n > 1}
    if mtp_val_choices.length == 0
      return self.generate_add_type_question
    else
      mtp_val = mtp_val_choices.sample
      time_diff = (1...age_difference / mtp_val).to_a.sample
      return age_problem.new(:add,age_difference,time_diff,mtp_val+1)
    end
  end

  def generate_add_question_text
    named_person = [['Adam',:m],['Beth',:f],['John',:m],['Julie',:f]].sample
    rand_choice = [0,1].sample
    p rand_choice
    puts time_1_val
    if rand_choice == 0
      younger = named_person
      if 1 <= time_1_val && time_1_val < 20
        older = [['Ken',:m],['Davina',:f],['Henry',:m],['Sarah',:f]].sample
      elsif 20 <= time_1_val && time_1_val < 50
        older = [['father',:m],['mother',:f]].sample
      elsif  50 <= time_1_val && time_1_val < 80
        older = [['grandfather',:m],['grandmother',:f]].sample
      end
    else
      older = named_person
      if 1 <= time_1_val && time_1_val < 20
        younger = [['Ken',:m],['Davina',:f],['Henry',:m],['Sarah',:f]].sample
      elsif 20 <= time_1_val && time_1_val < 50
        younger = [['son',:m],['daughter',:f]].sample
      elsif  50 <= time_1_val && time_1_val < 80
        younger = [['grandson',:m],['granddaughter',:f]].sample
      end
    end
    [younger,older]
  end

  def solution
    sol_eqn_array = []
    step_1 = equation
    step_2 = equation.copy._age_problem_expand
    sol_eqn_array << step_2
    step_3 = step_2.copy._standardise_m_sums.collect_like_terms._remove_m_form_one_coef
    sol_eqn_array << step_3
    step_4 = step_3.copy._age_problem_simplify_m_sums._remove_m_form_one_coef.standardise_linear_equation
    l_eqn = linear_equation.new(step_4.left_side,step_4.right_side)
    l_eqn_soln = l_eqn._generate_solution
    sol_eqn_array = sol_eqn_array + l_eqn_soln
    return sol_eqn_array
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
