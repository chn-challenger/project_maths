require './models/evaluate'
require './models/equation'
require './models/linear_equation'

include Evaluate

class SimultaneousEquation < Equation
  attr_accessor :equation_1, :equation_2

  def initialize
    @parameters = { number_of_steps: 2,
                    variables: %w(x y),
                    solution_max: 9,
                    negative_allowed: false,
                    hint: 'Give integer solution.',
                    exp: 25, order: '', level: 1,
                    rails: true
                  }
    @equation_1 = Equation.new
    @equation_2 = Equation.new
    @eq_1_coefs = []
    @eq_2_coefs = []
    @eq_vars  = []
    @eq_rhs   = []
    @ops      = { operaion: nil, multiplier: nil }
  end

  def generate_question_with_latex(parameters)
    update_params(parameters)
    latex(_generate_question)
  end


  def _generate_question
    set_coefficients

    puts "x is #{@eq_vars[0]}"
    puts "y is #{@eq_vars[1]}"

    equation_1_config = [[nil,[@eq_1_coefs[0],@parameters[:variables][0]]],
                         [:add,[@eq_1_coefs[1],@parameters[:variables][1]]]]
    @equation_1.left_side = msum_factory.build(equation_1_config)
    @equation_1.right_side = expression_factory.build([[nil,@eq_rhs[0]]])

    equation_2_config = [[nil,[@eq_2_coefs[0],@parameters[:variables][0]]],
                         [:add,[@eq_2_coefs[1],@parameters[:variables][1]]]]
    @equation_2.left_side = msum_factory.build(equation_2_config)
    @equation_2.right_side = expression_factory.build([[nil,@eq_rhs[1]]])

    @equation_1.left_side.simplify_all_m_sums._remove_m_form_one_coef
    @equation_2.left_side.simplify_all_m_sums._remove_m_form_one_coef

    question_latex = format_questions

    # puts @equation_1.latex
    # puts @equation_2.latex
    p "==========================="
    puts question_latex
    p "==========================="
    equation_2_copy = @equation_2.copy
    # puts 'EQ 2 COEFS'
    # p @eq_2_coefs
    # puts 'EQ 1 COEFS'
    # p @eq_1_coefs
    @equation_1.same_change(Step.new(:mtp,@eq_2_coefs[1].abs))
    @equation_2.same_change(Step.new(:mtp,@eq_1_coefs[1].abs))

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


    equation_2_copy.left_side.steps[0].val.steps[1].val = @eq_vars[0]
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

  # rescue NoMethodError
  #     _generate_question

    # { question: question, solution: solution }
  end

  def update_params(params)
    @parameters.each do |k,v|
      @parameters[k] = params[k] unless params[k].nil?
    end
  end

  def set_coefficients
    var_1 = rand(2..@parameters[:solution_max])
    var_2 = rand(2..@parameters[:solution_max])

    coef_set = (-7..-1).to_a + (1..7).to_a

    @eq_1_coefs.clear
    @eq_2_coefs.clear

    2.times{ @eq_1_coefs << coef_set.sample }
    2.times{ @eq_2_coefs << coef_set.sample }

    eq_1_rhs = @eq_1_coefs[0] * var_1 + @eq_1_coefs[1] * var_2 # b_1
    eq_2_rhs = @eq_2_coefs[0] * var_1 + @eq_2_coefs[1] * var_2 # b_2

    # @eq_rhs  = [eq_1_rhs, eq_2_rhs]

    puts '====================='
    puts 'EQ 1 Y-INTER'
    p @eq_1_coefs[0].to_s + "*" + var_1.to_s
    p @eq_1_coefs[1].to_s + "*" + var_2.to_s
    puts 'EQ 2 Y_INTER'
    p eq_1_rhs
    puts '====================='


    if no_solutions?(eq_1_rhs, eq_2_rhs)
      set_coefficients
    elsif infinite_solutions?(eq_1_rhs, eq_2_rhs)
      set_coefficients
    end

    puts '====================='
    puts 'EQ 1 COEFS'
    p @eq_1_coefs
    puts 'EQ 2 COEFS'
    p @eq_2_coefs
    puts '====================='

    @eq_vars = [var_1, var_2]
    @eq_rhs  = [eq_1_rhs, eq_2_rhs]

    puts '====================='
    puts 'EQ 1 Y-INTER'
    p @eq_rhs
    puts '====================='
  end

  def no_solutions?(eq_1_rhs, eq_2_rhs)
    (@eq_1_coefs[0].abs % @eq_2_coefs[0].abs == 0 ||
    @eq_1_coefs[0].abs == @eq_2_coefs[0].abs ||
    @eq_2_coefs[0].abs % @eq_1_coefs[0].abs == 0) &&
    eq_1_rhs.abs == eq_2_rhs.abs
  end

  def infinite_solutions?(eq_1_rhs, eq_2_rhs)
    (@eq_1_coefs[0].abs % @eq_2_coefs[0].abs == 0 ||
    @eq_1_coefs[0].abs == @eq_2_coefs[0].abs ||
    @eq_2_coefs[0].abs % @eq_1_coefs[0].abs == 0) &&
    eq_1_rhs.abs != eq_2_rhs.abs
  end

  def multiply_eq(num = 0)

    coefs = [@eq_1_coefs.dup, @eq_2_coefs.dup]

    coefs[num].each_with_index do |coef, i|
      case coef
      when @eq_2_coefs[i]
        if (coef == @eq_2_coefs[i])

        elsif (coef - @eq_2_coefs[i] == 0)

        else
          multiply_eq(@eq_1_coefs[0], @eq_2_coefs)
        end
      end

    end
  end

  def format_questions
    q_arr = [@equation_1, @equation_2]
    result = ""
    q_arr.each_with_index do |q, i|
      result << '&&' + q.latex + "&(#{i+1})&\\\\[5pt]\n"
    end
    result
  end
end
