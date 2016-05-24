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
    named_person = [['Adam',:m,:named],['Beth',:f,:named],['John',:m,:named],['Julie',:f,:named]].sample
    rand_choice = [0,1].sample
    # p rand_choice
    # puts time_1_val
    if rand_choice == 0
      younger = named_person
      if 1 <= time_1_val && time_1_val < 20
        older = [['Ken',:m,:named],['Davina',:f,:named],['Henry',:m,:named],['Sarah',:f,:named]].sample
      elsif 20 <= time_1_val && time_1_val < 50
        older = [['father',:m,:rel],['mother',:f,:rel]].sample
      elsif  50 <= time_1_val && time_1_val <= 80
        older = [['grandfather',:m,:rel],['grandmother',:f,:rel]].sample
      end
    else
      older = named_person
      if 1 <= time_1_val && time_1_val < 20
        younger = [['Ken',:m,:named],['Davina',:f,:named],['Henry',:m,:named],['Sarah',:f,:named]].sample
      elsif 20 <= time_1_val && time_1_val < 50
        younger = [['son',:m,:rel],['daughter',:f,:rel]].sample
      elsif  50 <= time_1_val && time_1_val <= 80
        younger = [['grandson',:m,:rel],['granddaughter',:f,:rel]].sample
      end
    end
    persons = [younger,older]

    p persons
    #pick first timeline



    #NOT NEEDED FOR ADD
    # younger_age = time_1_val / (time_2_val - 1) - time_diff
    # fail_safe_counter = 1
    # time_line_1 = (-10..5).to_a.sample
    # while younger_age + time_line_1 <= 0 && fail_safe_counter < 100
    #   fail_safe_counter += 1
    #   time_line_1 = (-10..5).to_a.sample
    # end

    who_first = [0,1].sample

    # puts 'who first is ' + who_first.to_s

    if who_first == 0 && persons[0][2] == :named
      #younger first && younger is named
      question_text = "#{persons[0][0]} is #{time_1_val} years younger than "
      if persons[1][2] == :named
        question_text += "#{persons[1][0]}. "
        text_part_2 = ["In #{time_diff} years time, ","#{time_diff} years from now, "].sample
        text_part_2 += "#{persons[1][0]} will be #{time_2_val} times as old as #{persons[0][0]}. "
        text_part_2 += "How old is #{persons[0][0]} now?"
        question_text += text_part_2
      else
        if persons[0][1] == :m
          question_text += "his #{persons[1][0]}. "
        else
          question_text += "her #{persons[1][0]}. "
        end
      end
    end

    if who_first == 0 && persons[0][2] == :rel
      #younger first && younger is relation
      question_text = "#{persons[1][0]}'s #{persons[0][0]} is #{time_1_val} years younger than #{persons[1][0]}. "
      text_part_2 = ["In #{time_diff} years time, ","#{time_diff} years from now, "].sample
      if persons[1][1] == :m
        text_part_2 += "#{persons[1][0]} will be #{time_2_val} times as old as his #{persons[0][0]}. "
      else
        text_part_2 += "#{persons[1][0]} will be #{time_2_val} times as old as her #{persons[0][0]}. "
      end
      text_part_2 += "How old is #{persons[1][0]}'s #{persons[0][0]} now?"
      question_text += text_part_2
      #John's grandson is 50 years younger than John,
    end

    if who_first == 1 && persons[1][2] == :named
      #older first && older is named
      question_text = "#{persons[1][0]} is #{time_1_val} years older than "
      if persons[0][2] == :named
        question_text += "#{persons[0][0]}."
      else
        if persons[1][1] == :m
          question_text += "his #{persons[0][0]}."
        else
          question_text += "her #{persons[0][0]}."
        end
      end
    end

    if who_first == 1 && persons[1][2] == :rel
      #older first && older is rel
      question_text = "#{persons[0][0]}'s #{persons[1][0]} is #{time_1_val} years older than #{persons[0][0]}."
    end

    question_text

    text_part_2 = ["In #{time_diff} years time, ","#{time_diff} years from now, "].sample


    # [younger_age,t]
    #
    # if [0..1].sample == 0
    #   question_str =
    # else
    #
    # end
    question_text
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






    #
    # who_first = [0,1].sample
    #
    # if who_first == 0 && persons[0][2] == :named
    #   #younger first
    #   if time_line_1 < 0
    #     question_text = "#{time_line_1.abs} years ago, #{persons[0][0]} was #{time_1_val} years younger than "
    #     if 1 <= time_1_val && time_1_val < 20
    #       question_text += "#{persons[1][0]}."
    #     else
    #       if persons[0][0][1] == :m
    #         question_text += "his #{persons[1][0]}."
    #       else
    #         question_text += "her #{persons[1][0]}."
    #       end
    #     end
    #   elsif time_line_1 == 0
    #     question_text = "#{persons[0][0]} is #{time_1_val} years younger than "
    #     if 1 <= time_1_val && time_1_val < 20
    #       question_text += "#{persons[1][0]}."
    #     else
    #       if persons[0][0][1] == :m
    #         question_text += "his #{persons[1][0]}."
    #       else
    #         question_text += "her #{persons[1][0]}."
    #       end
    #     end
    #   elsif time_line_1 > 0
    #     question_text = "#{time_line_1.abs} years from now, #{persons[0][0]} was #{time_1_val} years younger than "
    #     if 1 <= time_1_val && time_1_val < 20
    #       question_text += "#{persons[1][0]}."
    #     else
    #       if persons[0][0][1] == :m
    #         question_text += "his #{persons[1][0]}."
    #       else
    #         question_text += "her #{persons[1][0]}."
    #       end
    #     end
    #
    #   end
    # else
    #   #older first
    #
    # end
