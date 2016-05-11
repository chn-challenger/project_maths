require './generators/evaluate'
require './generators/equation'

include Evaluate

class LinearEquation < Equation

  def self.set_default_parameters(parameters)
    parameters[:number_of_steps] ||= 4
    parameters[:variable] ||= 'x'
    parameters[:solution_max] ||= 10
    parameters[:negative_allowed] ||= false
    parameters[:multiple_division] ||= false
  end

  def self.generate_question(parameters={})
    question = self._generate_question(parameters)
    solution = question._generate_solution
    {question:question,solution:solution}
  end

  def self._generate_question(parameters={})
    self.set_default_parameters(parameters)
    solution = rand(2..parameters[:solution_max])
    left_side = [Step.new(nil,parameters[:variable])]
    current_value = solution
    parameters[:number_of_steps].times do
      next_step = self._next_step(left_side,current_value,parameters)
      current_value = evaluate([Step.new(nil,current_value),next_step])
      if current_value == nil || current_value == 1
        return self._generate_question(parameters)
      end
      left_side << next_step
    end
    left_expression = Expression.new(left_side)
    right_expression = Expression.new([Step.new(nil,current_value)])
    equation_solution = {parameters[:variable] => solution}
    LinearEquation.new(left_expression,right_expression,equation_solution)
  end

  def _generate_solution
    equation = self.copy
    solution_equations = [equation]
    while true
      equation = equation._solution_next_equation
      solution_equations << equation
      equation = equation.copy
      equation._evaluate_numericals
      solution_equations << equation
      break if equation.left_side.steps.count == 1 && equation.right_side.steps.count == 1
    end
    return solution_equations
  end

  def self.latex(generated_question)
    question_latex = generated_question[:question].latex
    solution_latex = self._solution_latex(generated_question[:solution])
    {question_latex:question_latex,solution_latex:solution_latex}
  end

  def self._solution_latex(solutions_array)
    result = ''
    solutions_array.each do |solution_equation|
      result += solution_equation.latex + '\\\\' + "\n"
    end
    result.slice!(-3..-1)
    result
  end

  def _solution_next_equation
    copy = self.copy
    if copy.left_side.steps.length > 1
      reverse_side, value_side = copy.left_side, copy.right_side
    else
      reverse_side, value_side = copy.right_side, copy.left_side
    end
    step_to_reverse = reverse_side.steps.delete_at(-1)
    value_side.steps << step_to_reverse.reverse_step
    if step_to_reverse.dir == :lft && (step_to_reverse.ops == :sbt || step_to_reverse.ops == :div)
      copy.left_side,copy.right_side = copy.right_side,copy.left_side
    end
    return copy
  end

  def _evaluate_numericals
    if left_side._all_steps_numerical?
      left_side.steps = [Step.new(nil,evaluate(left_side.steps))]
    end
    if right_side._all_steps_numerical?
      right_side.steps = [Step.new(nil,evaluate(right_side.steps))]
    end
  end

  private

  def self._next_step(left_side,current_value,parameters)
    next_step_ops = self._next_step_ops(left_side,parameters)
    next_step_dir = next_step_ops == :mtp ? :lft : [:lft,:rgt].sample
    next_step_val = self._next_step_val(current_value,next_step_ops,next_step_dir,parameters)
    Step.new(next_step_ops,next_step_val,next_step_dir)
  end

  def self._next_step_ops(left_side,parameters)
    return [[:add,:sbt],[:mtp,:div]].sample.sample if left_side.length == 1
    last_ops = left_side.last.ops
    has_div = false
    left_side.each do |step|
      has_div = true if step.ops == :div
    end
    if [:add,:sbt].include?(last_ops)
      no_more_div = (!parameters[:multiple_division] && has_div)
      return no_more_div ? :mtp : [:mtp,:div].sample
    end
    if [:mtp,:div].include?(last_ops)
      return [:add,:sbt].sample
    end
  end

  def self._next_step_val(current_value,next_step_ops,next_step_dir,parameters)
    return (10..99).to_a.sample if next_step_ops == :add
    return (2..10).to_a.sample if next_step_ops == :mtp
    return (2..current_value - 2).to_a.sample if next_step_ops == :sbt &&
      next_step_dir == :rgt
    return (current_value + 10 ..current_value + 99).to_a.sample if
      next_step_ops == :sbt && next_step_dir == :lft
    if next_step_ops == :div && next_step_dir == :lft
      multiples_of_current_value = (2..10).collect{|n| n * current_value}
      return multiples_of_current_value.sample
    end
    if next_step_ops == :div && next_step_dir == :rgt
      divisors_of_current_value = (1..current_value).select { |n| current_value % n == 0 && n != 1 && n < current_value}
      return divisors_of_current_value.sample
    end
  end



end
