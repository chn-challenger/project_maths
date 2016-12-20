require './models/evaluate'
require './models/equation'

include Evaluate

class SimultaneousEquation < Equation
  attr_reader :equation, :equation_2

  def initialize
    @parameters = { number_of_steps: 2,
                    variables: %w(x y),
                    solution_max: 10,
                    negative_allowed: false,
                    hint: 'Give integer solution.',
                    exp: 25, order: '', level: 1,
                    rails: true
                  }
    @equation = nil
    @equation_2 = nil
  end

  def generate_question
    question = nil
    2.times { |i|
      if i == 1
        question = _generate_question(i)
      else
        _generate_question(i)
      end
    }

    solution = 1
    { question: question, solution: solution }
  end

  def _gen_solution()

  end

  def _generate_question(question_num)
    solution = rand(2..@parameters[:solution_max])
    left_side = [Step.new(nil, @parameters[:variables][question_num])]
    current_value = solution

    @parameters[:number_of_steps].times do
      next_step = _next_step(left_side, solution)
      current_value = evaluate([Step.new(nil, current_value), next_step])

      if current_value.nil? || current_value == 1
        return _generate_question
      end

      left_side << next_step
    end

    left_expression = Expression.new(left_side)
    right_expression = Expression.new([Step.new(nil, current_value)])
    equation_solution = { @parameters[:variables][0] => solution, @parameters[:variables][1] => solution }

    unless !@equation.nil?
      @equation= Equation.new(left_expression, right_expression, equation_solution)
    else
      @equation_2 = Equation.new(left_expression, right_expression, equation_solution)
    end

    return self
  end

  def _next_step(left_side, current_value)
    next_step_ops = _next_step_ops(left_side)
    next_step_dir = next_step_ops == :mtp ? :lft : [:lft, :rgt].sample
    next_step_val = _next_step_val(current_value, next_step_ops, next_step_dir)
    p next_step_val
    Step.new(next_step_ops, next_step_val, next_step_dir)
  end

  def _next_step_ops(left_side)
    return [:mtp].sample if left_side.length == 1
    last_ops = left_side.last.ops

    has_div = false
    left_side.each { |step| has_div = true if step.is_div? }

    return :mtp if [:add, :sbt].include?(last_ops)
    return [:add, :sbt].sample if last_ops == :mtp
  end

  def _next_step_val(current_value, next_step_ops, next_step_dir)
    return rand(5..20) if next_step_ops == :add
    return rand(2..10) if next_step_ops == :mtp
    return rand(2..current_value - 2) if next_step_ops == :sbt &&
                                         next_step_dir == :rgt
    return rand(current_value + 2..current_value + 9) if
      next_step_ops == :sbt && next_step_dir == :lft
  end

end
