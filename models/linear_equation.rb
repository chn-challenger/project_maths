require './models/evaluate'
require './models/equation'

include Evaluate

class LinearEquation < Equation
  def self.set_default_parameters(parameters)
    parameters[:number_of_steps] ||= 4
    parameters[:variable] ||= 'x'
    parameters[:solution_max] ||= 10
    parameters[:negative_allowed] ||= false
    parameters[:multiple_division] ||= false
    parameters[:hint] ||= 'Give integer solution.'
    parameters[:exp] ||= 25
    parameters[:order] ||= ''
    parameters[:level] ||= 1
    parameters[:rails] ||= false
  end

  def self.generate_question(parameters = {})
    question = _generate_question(parameters)
    solution = question._generate_solution
    { question: question, solution: solution }
  end

  def self._generate_question(parameters = {})
    set_default_parameters(parameters)
    solution = rand(2..parameters[:solution_max])
    left_side = [Step.new(nil, parameters[:variable])]
    current_value = solution
    parameters[:number_of_steps].times do
      next_step = _next_step(left_side, current_value, parameters)
      current_value = evaluate([Step.new(nil, current_value), next_step])
      if current_value.nil? || current_value == 1
        return _generate_question(parameters)
      end
      left_side << next_step
    end
    left_expression = Expression.new(left_side)
    right_expression = Expression.new([Step.new(nil, current_value)])
    equation_solution = { parameters[:variable] => solution }
    LinearEquation.new(left_expression, right_expression, equation_solution)
  end

  def _generate_solution
    equation = copy
    solution_equations = [equation]
    return solution_equations if equation.left_side.steps.count == 1 && equation.right_side.steps.count == 1
    loop do
      equation = equation._solution_next_equation
      solution_equations << equation
      equation = equation.copy
      equation._evaluate_numericals
      solution_equations << equation
      break if equation.left_side.steps.count == 1 && equation.right_side.steps.count == 1
    end
    solution_equations
  end

  def self.latex(generated_question, parameters = {})
    set_default_parameters(parameters)
    return if generated_question[:question].nil?

    question_latex = generated_question[:question].latex
    solution_latex = _solution_latex(generated_question[:solution])

    if parameters[:rails] == true
      rails_format_question(question_latex, solution_latex) do |r|
        r.insert(-1, format_answer(generated_question))
      end
    else
      { question_latex: question_latex, solution_latex: solution_latex }
    end
  end

  def self.rails_format_question(question_latex, solution_latex, parameters = {})
    set_default_parameters(parameters)
    question_exp = 'question-experience$\\\$' + "\n" + parameters[:exp].to_s + '$\\\$' + "\n\n"
    question_order = 'question-order-group$\\\$' + "\n" + parameters[:order].to_s + '$\\\$' + "\n\n"
    question_lvl = 'question-level$\\\$' + "\n" + parameters[:level].to_s + '$\\\$' + "\n\n"

    rails_latex = rails_decorator('question-text', question_latex) +
                  rails_decorator('solution-text', solution_latex) +
                  question_exp + question_order + question_lvl

    yield(rails_latex)
    { rails_question_latex: rails_latex }
  end

  def self.rails_decorator(sym_name, value)
    value.prepend("#{sym_name}$\\\\$" + "\n" + '$\begin{align*}') << '\end{align*}$$\\\$' + "\n\n"
  end

  def self.format_answer(generated_question, parameters = {})
    set_default_parameters(parameters)
    solution = generated_question[:question].solution[parameters[:variable]]

    answer_label = 'answer-label$\\\$' + "\n$" + parameters[:variable] + '=$$\\\$' + "\n\n"
    answer_value = 'answer-value$\\\$' + "\n" + solution.to_s + '$\\\$' + "\n\n"
    answer_hint = 'answer-hint$\\\$' + "\n" + parameters[:hint] + '$\\\$' + "\n\n"
    answer_label + answer_value + answer_hint
  end

  def self._solution_latex(solutions_array)
    result = ''
    solutions_array.each_with_index do |solution_equation, i|
      result += if i == solutions_array.size - 1
                  solution_equation.latex
                else
                  solution_equation.latex + '\\\[2pt]' + "\n"
                end
    end
    # result.slice!(-1..-1)
    result
  end

  def _solution_next_equation
    copy = self.copy
    if copy.left_side.steps.length > 1
      reverse_side = copy.left_side
      value_side = copy.right_side
    else
      reverse_side = copy.right_side
      value_side = copy.left_side
    end
    step_to_reverse = reverse_side.steps.delete_at(-1)
    value_side.steps << step_to_reverse.reverse_step
    if step_to_reverse.dir == :lft && (step_to_reverse.ops == :sbt || step_to_reverse.ops == :div)
      copy.left_side, copy.right_side = copy.right_side, copy.left_side
    end
    copy
  end

  def _evaluate_numericals
    if left_side._all_steps_numerical?
      left_side.steps = [Step.new(nil, evaluate(left_side.steps))]
    end
    if right_side._all_steps_numerical?
      right_side.steps = [Step.new(nil, evaluate(right_side.steps))]
    end
  end

  private

  def self._next_step(left_side, current_value, parameters)
    next_step_ops = _next_step_ops(left_side, parameters)
    next_step_dir = next_step_ops == :mtp ? :lft : [:lft, :rgt].sample
    next_step_val = _next_step_val(current_value, next_step_ops, next_step_dir, parameters)
    Step.new(next_step_ops, next_step_val, next_step_dir)
  end

  def self._next_step_ops(left_side, parameters)
    return [[:add, :sbt], [:mtp, :div]].sample.sample if left_side.length == 1
    last_ops = left_side.last.ops
    has_div = false
    left_side.each do |step|
      has_div = true if step.ops == :div
    end
    if [:add, :sbt].include?(last_ops)
      no_more_div = (!parameters[:multiple_division] && has_div)
      return no_more_div ? :mtp : [:mtp, :div].sample
    end
    return [:add, :sbt].sample if [:mtp, :div].include?(last_ops)
  end

  def self._next_step_val(current_value, next_step_ops, next_step_dir, _parameters)
    return (10..99).to_a.sample if next_step_ops == :add
    return (2..10).to_a.sample if next_step_ops == :mtp
    return (2..current_value - 2).to_a.sample if next_step_ops == :sbt &&
                                                 next_step_dir == :rgt
    return (current_value + 10..current_value + 99).to_a.sample if
      next_step_ops == :sbt && next_step_dir == :lft
    if next_step_ops == :div && next_step_dir == :lft
      multiples_of_current_value = (2..10).collect { |n| n * current_value }
      return multiples_of_current_value.sample
    end
    if next_step_ops == :div && next_step_dir == :rgt
      divisors_of_current_value = (1..current_value).select { |n| current_value % n == 0 && n != 1 && n < current_value }
      return divisors_of_current_value.sample
    end
  end
end
#
#
# 11-x
#
# (nil,11,:rgt), (:sbt,'x',:rgt)
#
# 11-x
#
# (nil,'x',:rgt),(:sbt,11,:lft)

# 11-2x = 3
# 11-3 = 2x
# (11-2x)3
# 3(11-2x)

#
# x = 9
#
# LHS = (nil,'x') (:add,5) (:mtp,3) (:sbt,10) (:div,64,:lft)          RHS = (nil,2)
#
#
# # 64/(3(x+5)-10)=2
#
# LHS = (nil,'x') (:add,5) (:mtp,3) (:sbt,10) (:div,64,:lft)          RHS = (nil,2)
# LHS = (nil,'x') (:add,5) (:mtp,3) (:sbt,10)                         RHS = (nil,2) (:div,64,:lft)
# LHS = (nil,'x') (:add,5) (:mtp,3) (:sbt,10)                         RHS = (nil,32)
# LHS = (nil,'x') (:add,5) (:mtp,3)                                   RHS = (nil,32) (:add,10)
# LHS = (nil,'x') (:add,5)                                            RHS = (nil,42) (:div,3)
# LHS = (nil,'x') (:add,5)                                            RHS = (nil,14)
# LHS = (nil,'x')                                                     RHS = (nil,14) (:sbt,5)
# LHS = (nil,'x')                                                     RHS = (nil,9)
#
# ((x-3)(a+4)(b-5)-10)(11-c)
#
# 2x + 3y = 11
# 3x - 3y = 30
#
# (x-y)3 = 3x-3y
