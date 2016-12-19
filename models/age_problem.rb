require './models/evaluate'
require './models/equation'
require './models/linear_equation'
require './models/english_number'

include EnglishNumber

class AgeProblem
  attr_accessor :time_1_rel, :time_1_val, :time_diff, :time_2_val, :answer,
                :time_line_1, :time_line_2, :time_line_3, :persons

  def initialize(time_1_rel, time_1_val, time_diff, time_2_val, answer, time_line_1,
                 time_line_2, time_line_3, persons)
    @time_1_rel = time_1_rel
    @time_1_val = time_1_val
    @time_diff = time_diff
    @time_2_val = time_2_val
    @answer = answer
    @time_line_1 = time_line_1
    @time_line_2 = time_line_2
    @time_line_3 = time_line_3
    @persons = persons
  end

  def self._generate_people(named_persons, younger_rels, older_rels, diff_in_age)
    named_person = named_persons.sample
    if rand(0..1) == 0
      younger = named_person
      if 1 <= diff_in_age && diff_in_age < 20
        older = named_persons.select { |name| name != named_person }.sample
      elsif 20 <= diff_in_age && diff_in_age < 45
        older = older_rels[:gen1].sample
      elsif 45 <= diff_in_age && diff_in_age <= 80
        older = older_rels[:gen2].sample
      end
    else
      older = named_person
      if 1 <= diff_in_age && diff_in_age < 20
        younger = named_persons.select { |name| name != named_person }.sample
      elsif 20 <= diff_in_age && diff_in_age < 45
        younger = younger_rels[:gen1].sample
      elsif 45 <= diff_in_age && diff_in_age <= 80
        younger = younger_rels[:gen2].sample
      end
    end
    [younger, older]
  end

  def self.generate_add_type_question(named_persons, younger_rels, older_rels)
    # based on the following formula for (:add,a,b,c) question
    # a/(c - 1) = x + b
    # a = age_difference, b = time_diff, c = mtp_val
    age_difference = (4..80).to_a.sample
    mtp_val_choices = (1..8).to_a.select do |n|
      age_difference % n == 0 &&
        age_difference + age_difference / n <= 90 && age_difference / n > 1
    end
    if mtp_val_choices.empty?
      return generate_add_type_question(named_persons, younger_rels, older_rels)
    else
      mtp_val = mtp_val_choices.sample
      time_diff = (1...age_difference / mtp_val).to_a.sample
      answer = age_difference / mtp_val - time_diff
      if answer == 1
        return generate_add_type_question(named_persons, younger_rels, older_rels)
      end
      time_line_1 = 0
      time_line_2 = time_diff
      time_line_3 = 0
      persons = _generate_people(named_persons, younger_rels, older_rels,
                                 age_difference)
      return age_problem.new(:add, age_difference, time_diff, mtp_val + 1, answer,
                             time_line_1, time_line_2, time_line_3, persons)
    end
  end

  def generate_add_question_text
    age_diff = english_years(time_1_val)
    tme_diff = english_years(time_diff)
    age_mtp = english_times(time_2_val)

    who_first = [:younger, :older].sample

    text_part_2 = ["in #{tme_diff} time, ", "#{tme_diff} from now, "].sample.capitalize
    text_part_3 = "#{persons[1][0]} will be #{age_mtp}as old as"

    if who_first == :younger && persons[0][2].nil? # 1st person is named
      text_part_1 = "#{persons[0][0]} is #{age_diff} younger than "
      if persons[1][2].nil? # 2nd person is named
        text_part_1 += "#{persons[1][0]}. "
        text_part_3 = "#{text_part_3} #{persons[0][0]}. "
      else
        if persons[0][1] == :m
          text_part_1 += "his #{persons[1][0]}. "
          text_part_3 = "his #{text_part_3} him. "
        else
          text_part_1 += "her #{persons[1][0]}. "
          text_part_3 = "her #{text_part_3} her. "
        end
      end
      text_part_4 = "How old is #{persons[0][0]} now?"
    end

    if who_first == :older && persons[1][2].nil? # second person is named
      text_part_1 = "#{persons[1][0]} is #{age_diff} older than "
      if persons[0][2].nil?
        text_part_1 += "#{persons[0][0]}. "
        text_part_3 = "#{text_part_3} #{persons[0][0]}. "
        text_part_4 = "How old is #{persons[0][0]} now?"
      else
        if persons[1][1] == :m
          text_part_1 += "his #{persons[0][0]}. "
          text_part_3 = "#{text_part_3} his #{persons[0][0]}. "
          text_part_4 = "How old is his #{persons[0][0]} now?"
        else
          text_part_1 += "her #{persons[0][0]}. "
          text_part_3 = "#{text_part_3} her #{persons[0][0]}. "
          text_part_4 = "How old is her #{persons[0][0]} now?"
        end
      end
    end

    if who_first == :younger && persons[0][2] == :rel # first person is relative
      text_part_1 = "#{persons[1][0]}'s #{persons[0][0]} is #{age_diff} younger than #{persons[1][0]}. "
      his_her = persons[1][1] == :m ? 'his' : 'her'
      text_part_3 = "#{text_part_3} #{his_her} #{persons[0][0]}. "
      text_part_4 = "How old is #{persons[1][0]}'s #{persons[0][0]} now?"
    end

    if who_first == :older && persons[1][2] == :rel # second person is relative
      text_part_1 = "#{persons[0][0]}'s #{persons[1][0]} is #{age_diff} older than #{persons[0][0]}. "
      text_part_3 = "#{persons[0][0]}'s #{text_part_3} #{persons[0][0]}. "
      text_part_4 = "How old is #{persons[0][0]} now?"
    end

    text_part_1 + text_part_2 + text_part_3 + text_part_4
  end

  def self._generate_mtp_type_question_part_1
    # based on the following formula for (:mtp,a,b,c) question
    # b(c - 1) = x(a - c)
    x = rand(2..30)
    a_sbt_c = rand(1..[6, 100 / x].min)
    _gen_mtp_back_track_recursion(x, a_sbt_c)
  end

  def self._gen_mtp_back_track_recursion(x, a_sbt_c)
    a_c_choices = []
    for c in 2..7
      a = c + a_sbt_c
      unless a * x > 100 || a_sbt_c * x % (c - 1) != 0 || a * x + a_sbt_c * x / (c - 1) > 100 # || x == a_sbt_c * x / (c-1)
        b = a_sbt_c * x / (c - 1)
        a_c_choices << [x, a, b, c]
      end
    end
    if a_c_choices.empty?
      if a_sbt_c > 1
        return _gen_mtp_back_track_recursion(x, a_sbt_c - 1)
      else
        return _generate_mtp_type_question_part_1
      end
    else
      return a_c_choices.sample
    end
  end

  def self.generate_mtp_type_question(named_persons, younger_rels, older_rels)
    choosen = _generate_mtp_type_question_part_1
    answer = choosen[0]
    time_1_val = choosen[1]
    time_diff = choosen[2]
    time_2_val = choosen[3]
    min_time = -1 * answer + 1
    time_line_1 = rand(min_time..min_time.abs)
    time_line_2 = time_line_1 + time_diff
    time_line_3 = 0
    age_diff = answer * (time_1_val - 1)
    persons = _generate_people(named_persons, younger_rels, older_rels,
                               age_diff)
    age_problem.new(:mtp, time_1_val, time_diff, time_2_val, answer,
                    time_line_1, time_line_2, time_line_3, persons)
  end

  def _mtp_question_texts(person_1, person_2, time, age_mtp)
    be = 'was' if time < 0
    be = 'is' if time == 0
    be = 'will be' if time > 0
    "#{person_2} #{be} #{age_mtp}as old as #{person_1}. "
  end

  def _time_text(time)
    if time < 0
      "#{english_years(time.abs)} ago, ".capitalize
    elsif time == 0
      'This year, '
    else
      ["In #{english_years(time)} time, ", "#{english_years(time)} from now, "].sample.capitalize
    end
  end

  def generate_mtp_question_text
    age_mtp_1 = english_times(time_1_val)
    tme_diff = english_years(time_diff)
    age_mtp_2 = english_times(time_2_val)
    younger_age = time_diff * (time_2_val - 1) / (time_1_val - time_2_val)
    age_diff = younger_age * (time_1_val - 1)

    time_1 = time_line_1
    time_2 = time_line_2

    time_1_text = _time_text(time_1)
    time_2_text = _time_text(time_2)

    person_1 = persons[0][0]
    person_2 = persons[1][0]

    if persons[0][2] == :rel # older named
      prefix = persons[1][1] == :m ? 'his ' : 'her '
      person_1 = prefix + person_1
    end
    if persons[1][2] == :rel # younger named
      prefix = "#{persons[0][0]}'s "
      person_2 = prefix + person_2
    end

    text_part_1 = _mtp_question_texts(person_1, person_2, time_1, age_mtp_1)
    text_part_2 = _mtp_question_texts(person_1, person_2, time_2, age_mtp_2)
    text_part_3 = "How old is #{person_1} now?"

    time_1_text + text_part_1 + time_2_text + text_part_2 + text_part_3
  end

  def _time_soln_text(time)
    plural = time.abs == 1 ? '' : 's'
    if time < 0
      "#{time.abs} year#{plural} ago"
    elsif time == 0
      'Now'
    else
      "#{time} year#{plural} from now"
    end
  end

  def _soln_part_1
    time_1 = _time_soln_text(time_line_1)
    time_2 = _time_soln_text(time_line_2)
    time_line_text = "&\\text{#{time_1}}&&&&\\text{#{time_2}}&\\\\\n"
    younger_line = "&\\text{#{persons[0][0]}}\\hspace{10pt}x&&&&\\text{#{persons[0][0]}}\\hspace{10pt}x+#{time_diff}&\\\\\n"
    if time_1_rel == :add
      older_line = "&\\text{#{persons[1][0]}}\\hspace{10pt}x + #{time_1_val}&&&&\\text{#{persons[1][0]}}\\hspace{10pt}x + #{time_1_val} + #{time_diff}&\\\\\n"
    else
      older_line = "&\\text{#{persons[1][0]}}\\hspace{10pt}#{time_1_val}x&&&&\\text{#{persons[1][0]}}\\hspace{10pt}#{time_1_val}x+#{time_diff}&\\\\\n"
    end
    word_eqn = "&&\\text{#{persons[1][0]}} &= \\text{#{time_2_val}} \\times \\text{#{persons[0][0]}}&\\\\\n"
    time_line_text + younger_line + older_line + word_eqn
  end

  def _both_type_soln_part_2
    if time_1_rel == :add
      total_time_diff = time_1_val + time_diff
      left_side = expression_factory.build([[nil, 'x'], [:add, total_time_diff]])
    end
    if time_1_rel == :mtp
      left_side = expression_factory.build([[nil, 'x'], [:mtp, time_1_val, :lft], [:add, time_diff]])
    end
    right_side = expression_factory.build([[nil, 'x'], [:add, time_diff], [:mtp, time_2_val, :lft]])
    equation = equation_class.new(left_side, right_side)
    sol_eqn_array = [equation]
    step_2 = equation.copy._age_problem_expand
    sol_eqn_array << step_2
    step_3 = step_2.copy._standardise_m_sums.collect_like_terms._remove_m_form_one_coef
    sol_eqn_array << step_3
    step_4 = step_3.copy._age_problem_simplify_m_sums._remove_m_form_one_coef.standardise_linear_equation
    l_eqn = linear_equation.new(step_4.left_side, step_4.right_side)
    l_eqn_soln = l_eqn._generate_solution
    sol_eqn_array += l_eqn_soln
    sol_eqn_array.inject('') { |res, eqn| res += '&&' + eqn.latex + '&\\\\' + "\n" }
  end

  def _add_type_soln_part_3
    "&Answer:&\\text{#{persons[0][0]} now} &= #{answer}"
  end

  def _mtp_type_soln_part_3
    if time_line_1 == 0
      return "&Answer:&\\text{#{persons[0][0]} now} &= #{answer}"
    end
    reverse_time_line_1 = "+ #{time_line_1.abs}" if time_line_1 < 0
    reverse_time_line_1 = "- #{time_line_1}" if time_line_1 > 0
    time_1 = _time_soln_text(time_line_1)
    part_3 = "&&\\text{#{persons[0][0]} now} &= \\text{#{persons[0][0]} #{time_1}} " + reverse_time_line_1 + "\\\\\n"
    part_3 += "&&\\text{#{persons[0][0]} now} &= #{answer} " + reverse_time_line_1 + "\\\\\n"
    part_3 += "&Answer:&\\text{#{persons[0][0]} now} &= #{answer - time_line_1}"
    part_3
  end

  def mtp_type_soln
    _soln_part_1 + _both_type_soln_part_2 + _mtp_type_soln_part_3
  end

  def add_type_soln
    _soln_part_1 + _both_type_soln_part_2 + _add_type_soln_part_3
  end

  def self.named_persons
    [['Adam', :m], ['Beth', :f], ['John', :m], ['Julie', :f], ['Ken', :m], ['Davina', :f],
     ['Henry', :m], ['Sarah', :f], ['Alice', :f], ['Justin', :m]]
  end

  def self.older_rels
    { gen1: [['father', :m, :rel], ['mother', :f, :rel], ['aunt', :f, :rel],
             ['uncle', :m, :rel]],
      gen2: [['grandfather', :m, :rel], ['grandmother', :f, :rel]] }
  end

  def self.younger_rels
    { gen1: [['son', :m, :rel], ['daughter', :f, :rel], ['nephew', :m, :rel],
             ['niece', :f, :rel]],
      gen2: [['grandson', :m, :rel], ['granddaughter', :f, :rel]] }
  end

  def self.generate_question(_parameters = {})
    if rand(0..1) == 0
      generate_mtp_type_question(named_persons, younger_rels, older_rels)
    else
      generate_add_type_question(named_persons, younger_rels, older_rels)
    end
  end

  def self.latex(question)
    if question.time_1_rel == :mtp
      question_latex = '\\intertext{' + question.generate_mtp_question_text + '}'
      solution_latex = question_latex + question.mtp_type_soln
    else
      question_latex = '\\intertext{' + question.generate_add_question_text + '}'
      solution_latex = question_latex + question.add_type_soln
    end
    { question_latex: question_latex, solution_latex: solution_latex }
  end
end
