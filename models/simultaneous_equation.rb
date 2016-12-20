require './models/evaluate'
require './models/equation'
require './models/linear_equation'

include Evaluate

class SimultaneousEquation < Equation
  attr_accessor :equation_1, :equation_2

  def initialize
    @parameters = { number_of_steps: 2,
                    variables: %w(x y),
                    solution_max: 10,
                    negative_allowed: false,
                    hint: 'Give integer solution.',
                    exp: 25, order: '', level: 1,
                    rails: true
                  }
    @equation_1 = Equation.new
    @equation_2 = Equation.new
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

  def _generate_question()
    var_1 = rand(2..9)
    var_2 = rand(2..9)

    puts "x is #{var_1}"
    puts "y is #{var_2}"

    coef_set = (-5..-1).to_a + (1..5).to_a

    var_1_coef_1 = coef_set.sample
    var_1_coef_2 = coef_set.sample
    var_2_coef_1 = coef_set.sample
    var_2_coef_2 = coef_set.sample

    equation_1_config = [[nil,[var_1_coef_1,'x']],[:add,[var_2_coef_1,'y']]]
    @equation_1.left_side = msum_factory.build(equation_1_config)
    equation_1_rhs = var_1_coef_1 * var_1 + var_2_coef_1 * var_2
    @equation_1.right_side = expression_factory.build([[nil,equation_1_rhs]])

    equation_2_config = [[nil,[var_1_coef_2,'x']],[:add,[var_2_coef_2,'y']]]
    @equation_2.left_side = msum_factory.build(equation_2_config)
    equation_2_rhs = var_1_coef_2 * var_1 + var_2_coef_2 * var_2
    @equation_2.right_side = expression_factory.build([[nil,equation_2_rhs]])

    puts @equation_1.latex
    puts @equation_2.latex

    equation_2_copy = @equation_2.copy

    @equation_1.same_change(Step.new(:mtp,var_2_coef_2))
    @equation_2.same_change(Step.new(:mtp,var_2_coef_1))

    puts @equation_1.latex
    puts @equation_2.latex

    @equation_1.left_side.expand_n_simplify
    @equation_1.right_side.expand_n_simplify
    @equation_2.left_side.expand_n_simplify
    @equation_2.right_side.expand_n_simplify

    puts @equation_1.latex
    puts @equation_2.latex

    @equation_1.left_side.steps << step_factory.build([:sbt,@equation_2.left_side])
    @equation_1.right_side.steps << step_factory.build([:sbt,@equation_2.right_side])

    puts @equation_1.latex

    @equation_1.left_side.expand_n_simplify
    @equation_1.right_side.expand_n_simplify

    puts @equation_1.latex

    @equation_1.standardise_linear_equation

    @equation_1 = linear_equation.new(@equation_1.left_side,@equation_1.right_side)
    # l_eqn = linear_equation.new(step_4.left_side, step_4.right_side)
    solutions_1 = @equation_1._generate_solution

    puts linear_equation._solution_latex(solutions_1)


    puts equation_2_copy.latex


    equation_2_copy.left_side.steps[0].val.steps[1].val = var_1
    #
    puts equation_2_copy.latex
    #
    equation_2_copy.left_side.expand_n_simplify
    #
    puts equation_2_copy.latex
    #
    equation_2_copy.standardise_linear_equation
    #
    equation_2_copy = linear_equation.new(equation_2_copy.left_side,equation_2_copy.right_side)
    #
    solutions_2 = equation_2_copy._generate_solution
    #
    puts linear_equation._solution_latex(solutions_2)




    # puts @equation_2.latex
    # @equation_2.

    # left_side = [Step.new(nil, @parameters[:variables][question_num])]
    # current_value = solution
    #
    # @parameters[:number_of_steps].times do
    #   next_step = _next_step(left_side, solution)
    #   current_value = evaluate([Step.new(nil, current_value), next_step])
    #
    #   if current_value.nil? || current_value == 1
    #     return _generate_question
    #   end
    #
    #   left_side << next_step
    # end
    #
    # left_expression = Expression.new(left_side)
    # right_expression = Expression.new([Step.new(nil, current_value)])
    # equation_solution = { @parameters[:variables][0] => solution, @parameters[:variables][1] => solution }
    #
    # unless !@equation.nil?
    #   @equation= Equation.new(left_expression, right_expression, equation_solution)
    # else
    #   @equation_2 = Equation.new(left_expression, right_expression, equation_solution)
    # end
    #
    # return self
  end



  def _gen_solution()

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
