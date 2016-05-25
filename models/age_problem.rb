require './models/evaluate'
require './models/equation'
require './models/linear_equation'
require './models/english_number'

include EnglishNumber

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
    mtp_val_choices = (1..8).to_a.select{|n| age_difference%n == 0 &&
      age_difference + age_difference/n <= 90 && age_difference/n > 1}
    if mtp_val_choices.length == 0
      return self.generate_add_type_question
    else
      mtp_val = mtp_val_choices.sample
      time_diff = (1...age_difference / mtp_val).to_a.sample
      return age_problem.new(:add,age_difference,time_diff,mtp_val+1)
    end
  end

  def generate_add_question_text(people)
    age_diff = english_years(time_1_val)
    tme_diff = english_years(time_diff)
    age_mtp = english_times(time_2_val)
    named_person = people.sample
    rand_choice = [0,1].sample
    if rand_choice == 0
      younger = named_person
      if 1 <= time_1_val && time_1_val < 20
        older = people.select{|name| name != named_person}.sample
      elsif 20 <= time_1_val && time_1_val < 45
        older = [['father',:m,:rel],['mother',:f,:rel]].sample
      elsif  45 <= time_1_val && time_1_val <= 80
        older = [['grandfather',:m,:rel],['grandmother',:f,:rel]].sample
      end
    else
      older = named_person
      if 1 <= time_1_val && time_1_val < 20
        younger = people.select{|name| name != named_person}.sample
      elsif 20 <= time_1_val && time_1_val < 45
        younger = [['son',:m,:rel],['daughter',:f,:rel]].sample
      elsif  45 <= time_1_val && time_1_val <= 80
        younger = [['grandson',:m,:rel],['granddaughter',:f,:rel]].sample
      end
    end

    persons = [younger,older]
    who_first = [:younger,:older].sample

    text_part_2 = ["in #{tme_diff} time, ","#{tme_diff} from now, "].sample.capitalize
    text_part_3 = "#{persons[1][0]} will be #{age_mtp}as old as"

    if who_first == :younger && persons[0][2] == nil #1st person is named
      text_part_1 = "#{persons[0][0]} is #{age_diff} younger than "
      if persons[1][2] == nil #2nd person is named
        text_part_1 += "#{persons[1][0]}. "
        text_part_3 = "#{text_part_3} #{persons[0][0]}. "
        text_part_4 = "How old is #{persons[0][0]} now?"
        # puts 'case 1'
      else
        if persons[0][1] == :m
          text_part_1 += "his #{persons[1][0]}. "
          text_part_3 = "his #{text_part_3} him. "
          text_part_4 = "How old is #{persons[0][0]} now?"
          # puts 'case 2'
        else
          text_part_1 += "her #{persons[1][0]}. "
          text_part_3 = "her #{text_part_3} her. "
          text_part_4 = "How old is #{persons[0][0]} now?"
          # puts 'case 3'
        end
      end
    end

    if who_first == :older && persons[1][2] == nil #second person is named
      text_part_1 = "#{persons[1][0]} is #{age_diff} older than "
      if persons[0][2] == nil
        text_part_1 += "#{persons[0][0]}. "
        text_part_3 = "#{text_part_3} #{persons[0][0]}. "
        text_part_4 = "How old is #{persons[0][0]} now?"
        # puts 'case 5'
      else
        if persons[1][1] == :m
          text_part_1 += "his #{persons[0][0]}. "
          text_part_3 = "#{text_part_3} his #{persons[0][0]}. "
          text_part_4 = "How old is his #{persons[0][0]} now?"
          # puts 'case 6'
        else
          text_part_1 += "her #{persons[0][0]}. "
          text_part_3 = "#{text_part_3} her #{persons[0][0]}. "
          text_part_4 = "How old is her #{persons[0][0]} now?"
          # puts 'case 7'
        end
      end
    end

    if who_first == :younger && persons[0][2] == :rel #first person is relative
      text_part_1 = "#{persons[1][0]}'s #{persons[0][0]} is #{age_diff} younger than #{persons[1][0]}. "
      if persons[1][1] == :m
        text_part_3 = "#{text_part_3} his #{persons[0][0]}. "
        # puts 'case 9'
      else
        text_part_3 = "#{text_part_3} her #{persons[0][0]}. "
        # puts 'case 4'
      end
      text_part_4 = "How old is #{persons[1][0]}'s #{persons[0][0]} now?"
    end

    if who_first == :older && persons[1][2] == :rel #second person is relative
      text_part_1 = "#{persons[0][0]}'s #{persons[1][0]} is #{age_diff} older than #{persons[0][0]}. "
      text_part_3 = "#{persons[0][0]}'s #{text_part_3} #{persons[0][0]}. "
      text_part_4 = "How old is #{persons[0][0]} now?"
      # puts 'case 8'
    end

    text_part_1 + text_part_2 + text_part_3 + text_part_4
  end

  def self.generate_mtp_type_question
    # based on the following formula for (:mtp,a,b,c) question
    # b(c - 1) = x(a - c)
    x = rand(2..30)
    a_sbt_c = rand(1..[6,100/x].min)
    _gen_mtp_back_track_recursion(x,a_sbt_c)
  end

  def self._gen_mtp_back_track_recursion(x,a_sbt_c)
    a_c_choices = []
    for c in 2..7
      a = c + a_sbt_c
      unless a * x > 100 || a_sbt_c * x % (c-1) != 0 || a * x + a_sbt_c * x / (c-1) > 100 #|| x == a_sbt_c * x / (c-1)
        b = a_sbt_c * x / (c-1)
        a_c_choices << [x, a , b , c]
      end
    end
    if a_c_choices.length == 0
      if a_sbt_c > 1
        return _gen_mtp_back_track_recursion(x,a_sbt_c-1)
      else
        return generate_mtp_type_question
      end
    else
      result = a_c_choices.sample
      p result
      return age_problem.new(:mtp,result[1],result[2],result[3])
    end
  end



  def generate_mtp_question_text(people)
    age_mtp_1 = english_times(time_1_val)
    tme_diff = english_years(time_diff)
    age_mtp_2 = english_times(time_2_val)
    younger_age = time_diff*(time_2_val-1)/(time_1_val-time_2_val)
    age_diff = younger_age * (time_1_val - 1)

    named_person = people.sample
    if rand(0..1) == 0
      younger = named_person
      if 1 <= age_diff && age_diff < 20
        older = people.select{|name| name != named_person}.sample
      elsif 20 <= age_diff && age_diff < 45
        older = [['father',:m,:rel],['mother',:f,:rel]].sample
      elsif  45 <= age_diff && age_diff <= 80
        older = [['grandfather',:m,:rel],['grandmother',:f,:rel]].sample
      end
    else
      older = named_person
      if 1 <= age_diff && age_diff < 20
        younger = people.select{|name| name != named_person}.sample
      elsif 20 <= age_diff && age_diff < 45
        younger = [['son',:m,:rel],['daughter',:f,:rel]].sample
      elsif  45 <= age_diff && age_diff <= 80
        younger = [['grandson',:m,:rel],['granddaughter',:f,:rel]].sample
      end
    end

    persons = [younger,older]

    #choose two time lines
    min_time = -1*younger_age + 1
    time_1 = rand(min_time..min_time.abs)
    time_2 = time_1 + time_diff

    if time_1 < 0
      time_1_text = "#{english_years(time_1.abs)} ago, ".capitalize
    elsif time_1 == 0
      time_1_text = 'This year, '
    else
      time_1_text = ["In #{english_years(time_1)} time, ", "#{english_years(time_1)} from now, "].sample.capitalize
    end

    if time_2 < 0
      time_2_text = "#{english_years(time_2.abs)} ago, ".capitalize
    elsif time_2 == 0
      time_2_text = 'This year, '
    else
      time_2_text = ["In #{english_years(time_2)} time, ", "#{english_years(time_2)} from now, "].sample.capitalize
    end

    if persons[1][2] == nil && persons[0][2] == nil #both named
      if time_1 < 0
        text_part_1 = "#{persons[1][0]} was #{age_mtp_1} as old as #{persons[0][0]}. "
      elsif time_1 == 0
        text_part_1 = "#{persons[1][0]} is #{age_mtp_1} as old as #{persons[0][0]}. "
      else
        text_part_1 = "#{persons[1][0]} will be #{age_mtp_1} as old as #{persons[0][0]}. "
      end
      if time_2 < 0
        text_part_2 = "#{persons[1][0]} was #{age_mtp_2} as old as #{persons[0][0]}. "
      elsif time_2 == 0
        text_part_2 = "#{persons[1][0]} is #{age_mtp_2} as old as #{persons[0][0]}. "
      else
        text_part_2 = "#{persons[1][0]} will be #{age_mtp_2} as old as #{persons[0][0]}. "
      end
    end

    if persons[1][2] == nil && persons[0][2] == :rel #both named
      older_s = persons[0][1] == :m ? 'his' : 'her'
      if time_1 < 0
        text_part_1 = "#{persons[1][0]} was #{age_mtp_1} as old as #{older_s} #{persons[0][0]}. "
      elsif time_1 == 0
        text_part_1 = "#{persons[1][0]} is #{age_mtp_1} as old as #{older_s} #{persons[0][0]}. "
      else
        text_part_1 = "#{persons[1][0]} will be #{age_mtp_1} as old as #{older_s} #{persons[0][0]}. "
      end
      if time_2 < 0
        text_part_2 = "#{persons[1][0]} was #{age_mtp_2} as old as #{older_s} #{persons[0][0]}. "
      elsif time_2 == 0
        text_part_2 = "#{persons[1][0]} is #{age_mtp_2} as old as #{older_s} #{persons[0][0]}. "
      else
        text_part_2 = "#{persons[1][0]} will be #{age_mtp_2} as old as #{older_s} #{persons[0][0]}. "
      end
    end

    if persons[1][2] == :rel && persons[0][2] == nil #both named
      if time_1 < 0
        text_part_1 = "#{persons[0][0]}'s #{persons[1][0]} was #{age_mtp_1} as old as #{persons[0][0]}. "
      elsif time_1 == 0
        text_part_1 = "#{persons[0][0]}'s #{persons[1][0]} is #{age_mtp_1} as old as #{persons[0][0]}. "
      else
        text_part_1 = "#{persons[0][0]}'s #{persons[1][0]} will be #{age_mtp_1} as old as #{persons[0][0]}. "
      end
      if time_2 < 0
        text_part_2 = "#{persons[0][0]}'s #{persons[1][0]} was #{age_mtp_2} as old as #{persons[0][0]}. "
      elsif time_2 == 0
        text_part_2 = "#{persons[0][0]}'s #{persons[1][0]} is #{age_mtp_2} as old as #{persons[0][0]}. "
      else
        text_part_2 = "#{persons[0][0]}'s #{persons[1][0]} will be #{age_mtp_2} as old as #{persons[0][0]}. "
      end
    end

    if persons[0][2] == nil
      text_part_3 = "How old is #{persons[0][0]} now?"
    else
      text_part_3 = "How old is #{persons[1][0]}'s #{persons[0][0]} now?"
    end

  end











  def solution
    sol_eqn_array = []
    step_1 = equation
    sol_eqn_array << step_1
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
