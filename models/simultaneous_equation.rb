require './models/evaluate'
require './models/equation'
require './models/linear_equation'

include Evaluate

class SimultaneousEquation < Equation
  attr_accessor :equation_1, :equation_2, :parameters

  def initialize
    @parameters = { number_of_steps: 2,
                    variables: %w(x y),
                    solution_max: 9,
                    negative_allowed: false,
                    hint: 'Give integer solution.',
                    exp: 25, order: '', level: 1,
                    rails: false
                  }
    @equation_1 = Equation.new
    @equation_2 = Equation.new
    @eq_1_coefs = []
    @eq_2_coefs = []
    @eq_vars  = []
    @eq_rhs   = []
    @ops      = { operaion: nil, multiplier: nil, equation: nil }
    @question_latex = ""
    @solution_latex = ""
  end

  def self.generate_question_with_latex(parameters={})
    sim_eq = SimultaneousEquation.new
    sim_eq.update_params(parameters)
    sim_eq._generate_question
    return sim_eq.rails_format_question if sim_eq.parameters[:rails]
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

    format_questions

    equation_2_copy = @equation_2.copy
    determine_multiplier([@eq_1_coefs, @eq_2_coefs])

    latex(equation_2_copy)
  rescue NoMethodError
      _generate_question
  end

  def rails_format_question
    question_exp = 'question-experience$\\\$' + "\n" + @parameters[:exp].to_s + '$\\\$' + "\n\n"
    question_order = 'question-order-group$\\\$' + "\n" + @parameters[:order].to_s + '$\\\$' + "\n\n"
    question_lvl = 'question-level$\\\$' + "\n" + @parameters[:level].to_s + '$\\\$' + "\n\n"

    rails_latex = rails_decorator('question-text', @question_latex) +
                  rails_decorator('solution-text', @solution_latex) +
                  question_exp + question_order + question_lvl +
                  format_answers

    { rails_question_latex: rails_latex }
  end

  def rails_decorator(sym_name, value)
    value.prepend("#{sym_name}$\\\\$" + "\n" + '$\begin{align*}') << '\end{align*}$$\\\$' + "\n\n"
  end

  def format_answers
    answers = ""

    @parameters[:variables].each_with_index do |var, i|
      answer_label = 'answer-label$\\\$' + "\n$" + var.to_s + '=$$\\\$' + "\n\n"
      answer_value = 'answer-value$\\\$' + "\n" + @eq_vars[i].to_s + '$\\\$' + "\n\n"
      answer_hint = 'answer-hint$\\\$' + "\n" + @parameters[:hint] + '$\\\$' + "\n\n"
      answers <<  answer_label + answer_value + answer_hint
    end
    answers
  end

  def latex(equation_2_copy)
    puts "============== LATEX METHOD IN WORK ====================="
    if @ops[:multiplier].nil? || @ops[:multiplier] == 0
      puts @equation_1.latex
      _solution_latex(equation_2_copy)
    elsif @ops[:multiplier].is_a?(Array)

      _solution_latex_with_mtp(equation_2_copy)
    elsif @ops[:multiplier].is_a?(Integer)

      _solution_latex_with_single_mtp(equation_2_copy)
    end

    @solution_latex << "&x=#{@eq_vars[0]}\\hspace{5pt} \\text{and}\\hspace{5pt} y=#{@eq_vars[1]}& && &&"

    puts "====================== DONE ============================="
    { question_latex: @question_latex, solution_latex: @solution_latex }
  end

  def update_params(params)
    @parameters.each do |k,v|
      @parameters[k] = params[k] unless params[k].nil?
    end
  end

  def sanitize
    @equation_1.left_side.expand_n_simplify
    @equation_1.right_side.expand_n_simplify
    @equation_2.left_side.expand_n_simplify
    @equation_2.right_side.expand_n_simplify
  end

  def normalize(equation)
    equation.left_side.expand_n_simplify
    equation.right_side.expand_n_simplify
  end

  def update_coefs(coefs, mtp)
    if coefs.dup.flatten.size == 2
      coefs.collect! { |e| e * mtp.abs }
    else
      coefs.each_with_index do |coef, i|
        coef.collect! { |e| e * mtp[i].abs }
      end
    end
  end

  def determine_multiplier(coefs=[], num=0, count=0)
    eqs = [@equation_1, @equation_2]

    coefs[num].each_with_index do |coef, i|
      if coef.abs == coefs[num-1][i].abs
        if coef + coefs[num-1][i] == 0
          @ops[:operation] = :add
          @ops[:equation]  = eqs[num]
          normalize(eqs[num])
          normalize(eqs[num-1])
          eqs[num].left_side.steps << step_factory.build([:add,eqs[num-1].left_side])
          eqs[num].right_side.steps << step_factory.build([:add,eqs[num-1].right_side])

        else
          @ops[:operation] = :sbt
          @ops[:equation]  = eqs[num]
          normalize(eqs[num])
          normalize(eqs[num-1])
          eqs[num].left_side.steps << step_factory.build([:sbt,eqs[num-1].left_side])
          eqs[num].right_side.steps << step_factory.build([:sbt,eqs[num-1].right_side])

        end
        return
      elsif coef.abs % coefs[num-1][i].abs == 0
        @ops[:multiplier] = coef[-1] / coefs[num-1][-1]

        eqs[num-1].same_change(Step.new(:mtp,@ops[:multiplier]))

        sanitize

        determine_multiplier(update_coefs(coefs[num-1], @ops[:multiplier]), num, 0)
        return
      elsif coefs[num-1][i].abs % coef.abs == 0
        @ops[:multiplier] = coefs[num-1][-1] / coef

        eqs[num].same_change(Step.new(:mtp,@ops[:multiplier]))

        sanitize

        determine_multiplier(update_coefs(coefs[num], @ops[:multiplier]), num, 0)
        return
      elsif count == 8
        eqs[0].same_change(Step.new(:mtp,@eq_2_coefs[1].abs))
        eqs[1].same_change(Step.new(:mtp,@eq_1_coefs[1].abs))

        @ops[:multiplier] = [@eq_2_coefs[1], @eq_1_coefs[1]]

        # puts @equation_1.latex
        # puts @equation_2.latex
        #
        # sanitize
        #
        # puts @equation_1.latex
        # puts @equation_2.latex

        determine_multiplier(update_coefs(coefs, [@eq_2_coefs[1], @eq_1_coefs[1]]), num, 0)
        return
      else
        int = num == 0 ? 1 : 0
        determine_multiplier([@eq_1_coefs, @eq_2_coefs], int, count += 1) if i == coefs[num].size - 1
      end
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


    if no_solutions?(eq_1_rhs, eq_2_rhs)
      set_coefficients
    elsif infinite_solutions?(eq_1_rhs, eq_2_rhs)
      set_coefficients
    else
      @eq_vars = [var_1, var_2]
      @eq_rhs  = [eq_1_rhs, eq_2_rhs]
    end
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

  def format_questions
    q_arr = [@equation_1, @equation_2]
    @question_latex.clear
    q_arr.each_with_index do |q, i|
    line_ending =  i == 1 ? "[15pt]" : ""
      @question_latex << '&&' + q.latex + "& &(#{i+1})&\\\\" + line_ending
    end
  end

  def _solution_latex_with_mtp(equation_2_copy)
    eq_arr = [copy(@equation_1), @equation_2]

    # sanitize
    @solution_latex.clear
    eq_arr.each_with_index do |eq, i|
      line_ending = i == 1 ? "[15pt]" : ""
      @solution_latex << "&(#{i+1})\\times#{@ops[:multiplier][i].abs}& " + eq.latex + "& &(#{i+3})&\\\\" + line_ending + "\n"
    end

    @solution_latex << "&(3)#{ operation_print }(4)& " + @equation_1.latex + "\\\\\n"

    solutions = solve_eq_1

    @solution_latex << solutions + "\\\\[15pt]\n"

    @solution_latex << "&\\text{Sub}\\hspace{5pt} x\\hspace{5pt} \\text{into}\\hspace{5pt} (1)&\\\n"

    solutions_2 = solve_eq_2(equation_2_copy)

    @solution_latex << solutions_2 + "\\\\[5pt]\n"
  end

  def _solution_latex_with_single_mtp(equation_2_copy)
    eq_arr = [copy(@equation_1), copy(@equation_2)]

    # sanitize
    @solution_latex.clear
    eq_arr.each_with_index do |eq, i|
      next if i == 1
      @solution_latex << "&(#{i+1})\\times#{@ops[:multiplier].abs}& " + eq.latex + "& &(#{i+1})&\\\\[5pt]\n"
    end

    @solution_latex << "&(1)#{ operation_print }(2)&\\\n" + @equation_1.latex + "\\\n"

    solutions = solve_eq_1

    @solution_latex << solutions + "\\\\[5pt]\n"

    @solution_latex << "&\\text{Sub}\\hspace{5pt} x\\hspace{5pt} \\text{into}\\hspace{5pt} (1)& "

    solutions_2 = solve_eq_2(equation_2_copy)

    @solution_latex << solutions_2 + "\\\\[5pt]\n"
  end


  def solve_eq_1
    @equation_1.left_side.expand_n_simplify
    @equation_1.right_side.expand_n_simplify

    @equation_1.standardise_linear_equation
    @equation_1 = linear_equation.new(@equation_1.left_side,@equation_1.right_side)

    return linear_equation._solution_latex(@equation_1._generate_solution, true)
  end

  def solve_eq_2(equation_2_copy)

    equation_2_copy.left_side.steps[0].val.steps[1].val = @eq_vars[0]

    @solution_latex << equation_2_copy.latex + "\\\\[5pt]\n"
    #
    equation_2_copy.left_side.expand_n_simplify
    #
    equation_2_copy.standardise_linear_equation
    #
    equation_2_copy = linear_equation.new(equation_2_copy.left_side,equation_2_copy.right_side)
    #
    solutions_2 = equation_2_copy._generate_solution
    #
    linear_equation._solution_latex(solutions_2, true)
  end

  def copy(equation)
    eq = equation.copy
    eq.left_side.steps.pop
    eq.right_side.steps.pop
    # normalize(eq)
    eq
  end

  def _solution_latex(equation_2_copy)
    begining = "&(1)" + operation_print + "(2)&\\\\\n"

    @solution_latex << begining + @equation_1.latex + "\\\\\n"

    @equation_1.left_side.expand_n_simplify
    @equation_1.right_side.expand_n_simplify

    @equation_1.standardise_linear_equation
    @equation_1 = linear_equation.new(@equation_1.left_side,@equation_1.right_side)

    solutions = solve_eq_1

    @solution_latex << solutions + "\\\\[5pt]\n"

    @solution_latex << "&\\text{Sub}\\hspace{5pt} x\\hspace{5pt} \\text{into}\\hspace{5pt} (1)&"

    solutions_2 = solve_eq_2(equation_2_copy)

    @solution_latex << solutions_2 + "\\\\[5pt]\n"
  end

  def operation_print
    if @ops[:operaion] == :sbt
      return "-"
    else
      return "+"
    end
  end

end
