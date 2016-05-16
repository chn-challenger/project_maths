require './models/step'
require './models/evaluate'
require './models/fraction'
require './models/array_extension'
require './models/factory'

include Evaluate

class Expression

  attr_accessor :steps

  def initialize(steps=[])
    @steps = steps
  end

  def ==(expression)
    return false if expression.is_a?(self.class) == false
    steps == expression.steps
  end

  def copy
    self.class.new(steps.inject([]){|result,element| result << element.copy})
  end

  def is_m_form?
    _steps_are_elementary? && _steps_are_multiply? && !_is_empty?
  end

  def is_m_form_sum?
    _is_sum? && _steps_are_at_most_m_form?
  end

  def _is_gen_m_form_sum?
    _is_gen_sum? && _steps_are_at_most_m_form?
  end

  def is_rational?
    _is_fractional? && steps.first.is_at_most_m_form? && steps.last.is_at_most_m_form_sum?
  end

  def _is_gen_rational?
    _is_fractional? && steps.first.is_at_most_m_form? &&
      (steps.last.is_at_most_m_form? || steps.last._is_gen_m_form_sum?)
  end

  def is_rational_sum?
    _is_sum? && _steps_are_rational?
  end

  def _is_gen_rational_sum?
    _is_gen_sum? && _steps_are_gen_rational?
  end

  def convert_lft_add_mtp_steps
    steps.each do |step|
      step.val.convert_lft_add_mtp_steps unless step.is_elementary?
      step.dir = :rgt if step.dir == :lft && (step.ops == :add || step.ops == :mtp)
    end
    self
  end

  def convert_lft_sbt_div_steps
    converted_exp = self.class.new
    steps.each do |step|
      step.val = step.val.convert_lft_sbt_div_steps unless step.is_elementary?
      if step.dir == :lft && (step.ops == :sbt || step.ops == :div)
        converted_exp = self.class.new([Step.new(nil,step.val),
          Step.new(step.ops,converted_exp)])
      else
        converted_exp.steps << step
      end
    end
    converted_exp
  end

  def similar?(expression)
    return false if !self.is_m_form? || !expression.is_m_form?
    return false if self.steps.length != expression.steps.length
    for i in 1..steps.length - 1
      return false if self.steps[i] != expression.steps[i]
    end
    return true
  end

  def m_sum_mtp_m_sum(m_sum_exp)
    result_steps = []
    m_sum_exp.steps.each do |term|
      steps.each do |step|
        operator = step.result_sign(term)
        new_step = step.at_most_m_step_mtp_at_most_m_step(term)
        new_step.ops = operator
        result_steps << new_step
      end
    end
    self.class.new(result_steps)._nullify_first_step_ops
  end

  def r_sum_mtp_r_sum(r_sum_exp)
    result_steps = []
    r_sum_exp.steps.each do |term|
      steps.each do |step|
        operator = step.result_sign(term)
        new_step = step.step_mtp_step(term)
        new_step.ops = operator
        result_steps << new_step
      end
    end
    self.class.new(result_steps)._nullify_first_step_ops
  end

  def _nullify_first_step_ops
    return self if steps.length == 0
    steps.first.ops = nil
    self
  end

  def _sum_expression_sign_swap
    steps.first.ops = :sbt
    for i in 1..steps.length - 1
      steps[i].ops = (steps[i].ops == :add)? :sbt : :add
    end
    self
  end

  def _convert_lft_ops
    self.convert_lft_add_mtp_steps.convert_lft_sbt_div_steps
  end

  def _is_fractional?
    steps.length == 2 && steps.last.ops == :div && steps.last.dir == :rgt
  end

  def _is_empty?
    steps.length == 0
  end

  def _steps_are_elementary?
    steps.each { |step| return false unless step.is_elementary? }
    return true
  end

  def _steps_are_multiply?
    for i in 1..steps.length - 1
      return false if steps[i].ops != :mtp
    end
    return true
  end

  def _is_sum?
    for i in 1..steps.length - 1
      return false if steps[i].ops == :mtp || steps[i].ops == :div ||
        steps[i].ops == nil || steps[i].dir == :lft
    end
    return true
  end

  def _is_gen_sum?
    for i in 1..steps.length - 1
      return false if steps[i].ops == :mtp || steps[i].ops == :div ||
        steps[i].ops == nil
    end
    return true
  end

  def _steps_are_at_most_m_form?
    for i in 0..steps.length - 1
      return false if !steps[i].is_elementary? && !steps[i].val.is_m_form?
    end
    return true
  end

  def _steps_are_rational?
    for i in 0..steps.length - 1
      return false if !steps[i].is_elementary? && !steps[i].val.is_m_form? &&
        !steps[i].val.is_rational?
    end
    return true
  end

  def _steps_are_gen_rational?
    for i in 0..steps.length - 1
      return false if !steps[i].is_elementary? && !steps[i].val.is_m_form? &&
        !steps[i].val._is_gen_rational?
    end
    return true
  end

  def m_form_latex
    steps.inject("") do |result,step|
        result += _consecutive_numerical_steps?(step) ? step.val.to_s + '\times' : step.val.to_s
    end
  end

  def _consecutive_numerical_steps?(step)
    step.val.is_a?(Fixnum) && !steps[(steps.index(step)+1)].nil? &&
      steps[(steps.index(step)+1)].val.is_a?(Fixnum)
  end

  def m_form_sum_latex
    steps.inject("") do |result,step|
      case step.ops
        when :add then result += '+'
        when :sbt then result += '-'
      end
      result += _is_elementary?(step) ? step.val.to_s : step.val.m_form_latex
    end
  end

  def _is_elementary?(step)
    step.val.is_a?(String) || step.val.is_a?(Fixnum)
  end

  def rational_latex
    numerator = _is_elementary?(steps.first) ? steps.first.val.to_s :
      steps.first.val.m_form_latex
    denominator = _is_elementary?(steps.last) ? steps.last.val.to_s :
      steps.last.val._to_at_most_m_form_sum_latex
    '\frac{' + numerator + '}{' + denominator + '}'
  end

  def _to_at_most_m_form_sum_latex
    is_m_form_sum? ? m_form_sum_latex : m_form_latex
  end

  # def latex
  #   current_latex = ""
  #   previous_steps = []
  #   steps.each do |step|
  #       current_latex += step.nil_step_latex if step.ops == nil
  #       current_latex += step.add_or_sbt_rgt_step_latex if
  #         (step.ops == :add || step.ops == :sbt) && step.dir == :rgt
  #       current_latex = step.add_or_sbt_lft_step_latex(current_latex,previous_steps) if
  #         (step.ops == :add || step.ops == :sbt) && step.dir == :lft
  #       current_latex = step.mtp_step_latex(current_latex,previous_steps) if step.ops == :mtp
  #       current_latex = step.div_step_latex(current_latex,previous_steps) if step.ops == :div
  #       previous_steps << step
  #   end
  #   current_latex
  # end

  def _all_steps_numerical?
    steps.each do |step|
      return false if !step.val.is_a?(Fixnum) && !step.val.is_a?(Float)
    end
    return true
  end

  def simplify_m_form
    return self unless is_m_form?
    _combine_m_form_numerical_steps
    _bsort_m_form_steps
    _standardise_m_form_ops
  end

  def _combine_m_form_numerical_steps
    numerical_steps = steps.collect_move{|step| step.val.is_a?(Fixnum)}
    new_value = numerical_steps.inject(1){|result,step| result *= step.val}
    steps.insert(0,Step.new(nil,new_value))
    self
  end

  def _bsort_m_form_steps
    return self if steps.length == 1
    copy = self.copy
    for i in 0..steps.length-2
      if steps[i].val.is_a?(Fixnum)
        next
      end
      if steps[i+1].val.is_a?(Fixnum)
        steps[i],steps[i+1] = steps[i+1],steps[i]
        next
      end
      if steps[i].val > steps[i+1].val
        steps[i],steps[i+1] = steps[i+1],steps[i]
        next
      end
    end
    return self == copy ? self : self._bsort_m_form_steps
  end

  def _standardise_m_form_ops
    steps.first.ops = nil
    for i in 1..steps.length-1
      steps[i].ops = :mtp
    end
    self
  end

  def simplify_m_forms_in_sum
    if _is_gen_m_form_sum?
      steps.each do |step|
        step.val = step.val.simplify_m_form if step.val.is_a?(self.class)
      end
    end
    self
  end

  def convert_string_value_steps_to_m_forms
    return self unless (_is_gen_m_form_sum? || _is_gen_rational_sum?)
    steps.each do |step|
      if step.val.is_a?(String)
        step.val = Expression.new([Step.new(nil,1),Step.new(:mtp,step.val)])
      end
    end
    self
  end

  def convert_m_form_to_elementary
    steps.each do |step|
      if !step.is_a?(Fixnum) && !step.is_a?(String) && step.is_m_form?
        if step.val.steps.length == 2 && step.val.steps.first.val == 1 && step.val.steps.last.val.is_a?(String)
          step.val = step.val.steps.last.val
          next
        end
        if step.val.steps.length == 1
          step.val = step.val.steps.first.val
          next
        end
      end
    end
    self
  end

  def simplify
    return self unless _is_sum?

    convert_string_value_steps_to_m_forms

    simplify_m_forms_in_sum

    result_steps = []

    while steps.length > 0
      comparison_step = steps.delete_at(0)

      if steps != []
        similar_steps = steps.collect_move do |step|
          if comparison_step.val.is_a?(Expression) && step.val.is_a?(Expression)
            comparison_step.val.similar?(step.val)
          elsif comparison_step.val.is_a?(Fixnum) && step.val.is_a?(Fixnum)
            true
          elsif comparison_step.val.is_a?(String) && step.val.is_a?(String)
            if comparison_step.val == step.val
              comparison_step = comparison_step.to_m_form
              step = step.to_m_form
              true
            else
              false
            end
          elsif !comparison_step.val.is_a?(Expression) && !step.val.is_a?(Expression)
            false
          else
            false
          end
        end
      else
        similar_steps = []
      end

      similar_steps = [comparison_step] + similar_steps

      value = 0
      similar_steps.each do |step|
        if step.ops == nil || step.ops == :add
          if step.val.is_a?(Expression)
            value += step.val.steps.first.val
          else
            value += step.val
          end
        else
          if step.val.is_a?(Expression)
            value -= step.val.steps.first.val
          else
            value -= step.val
          end
        end
      end

      equivalent_step = comparison_step.copy

      if value > 0
        equivalent_step.ops = :add
        if equivalent_step.val.is_a?(Expression)
          equivalent_step.val.steps.first.val = value
        else
          equivalent_step.val = value
        end
        result_steps << equivalent_step
      end

      if value < 0
        equivalent_step.ops = :sbt
        if equivalent_step.val.is_a?(Expression)
          equivalent_step.val.steps.first.val = value * -1
        else
          equivalent_step.val = value * -1
        end
        result_steps << equivalent_step
      end

    end

    if result_steps.length == 0
      return self.class.new([Step.new(nil,0)])
    end

    if result_steps.first.ops == :sbt
      result_steps.first.ops = nil
      if result_steps.first.val.is_a?(Expression)
        result_steps.first.val.steps.first.val *= -1
      else
        result_steps.first.val *= -1
      end
    else
      result_steps.first.ops = nil
    end

    self.class.new(result_steps).convert_m_form_to_elementary
  end

  def first_two_steps_swap
    return self if steps.length == 0
    if steps.length == 1
      if steps.first.val.is_a?(Expression)
        self.steps = steps[0].val.steps
        return self
      else
        return self
      end
    end
    steps[0].val, steps[1].val = steps[1].val, steps[0].val
    steps[1].dir = steps[1].dir == :rgt ? :lft : :rgt
    if steps[0].val.is_a?(Expression)
      step_0 = steps.delete_at(0)
      self.steps = step_0.val.steps + steps
      return self
    else
      return self
    end
  end

  def is_elementary?
    steps.each{|step| return false unless step.is_elementary?}
    return true
  end



  def standardise_linear_expression
    continue = true
    counter = 1
    while continue && counter < 100
      if steps[0].val.is_a?(Expression)
        if steps[0].val.is_flat?
          steps[0].val.first_two_steps_swap
        end
      end

      if steps.length > 1 && steps[1].val.is_a?(String)
        first_two_steps_swap
      end

      if steps[0].val.is_a?(String)
        continue = false
      end

      counter += 1
    end
    self
  end




  def expand
    expanded_steps = []
    steps.each do |step|
      _expand_nil_or_add_into(expanded_steps,step) if _nil_or_add?(step.ops)
      _expand_sbt_into(expanded_steps,step) if step.ops == :sbt
      _expand_mtp_into(expanded_steps,step) if step.ops == :mtp
    end
    self.steps = expanded_steps
    self.steps.first.ops = nil  #this is to be taken out once nullify first step is written
    return self
  end

  def _expand_nil_or_add_into(expanded_steps,step)
    if step.val.is_a?(expression_class)
      step.val.expand
      step.val.steps.first.ops = :add
      step.val.steps.each{|step| expanded_steps << step}
    else
     expanded_steps << step
    end
  end

  def _nil_or_add?(ops)
    ops == nil || ops == :add
  end

  def _expand_sbt_into(expanded_steps,step)
    if step.val.is_a?(expression_class)
      step.val.expand._add_sbt_sign_switch
      step.val.steps.each{|step| expanded_steps << step}
    else
     expanded_steps << step
    end
  end

  def _add_sbt_sign_switch
    switch_hash = {nil =>:sbt,:add =>:sbt,:sbt=>:add}
    steps.each{|step| step.ops = switch_hash[step.ops]}
    return self
  end

  def _expand_mtp_into(expanded_steps,step)
    step.mtp_prepare_value_as_ms
    copy = expression_factory.build(expanded_steps).copy.steps
    expanded_steps.slice!(0..-1)
    step.val.steps.each{|mtp_step| _expand_one_mtp_step_into(expanded_steps,copy,mtp_step)}
    expanded_steps.first.ops = nil
  end

  def _expand_one_mtp_step_into(expanded_steps,init_ms_steps,mtp_step)
    copy = expression_factory.build(init_ms_steps).copy.steps
    copy.each{|step| expanded_steps << step.em_mtp_em(mtp_step)}
  end


  def flatten
    _flatten_first_step
    steps.each do |step|
      step.val.flatten if step.val.is_a?(expression_class)
    end
    self
  end

  def _flatten_first_step
    if steps.first.val.is_a?(expression_class)
      first_steps = steps.first.val.steps
      self.steps.delete_at(0)
      self.steps = first_steps + self.steps
    end
    _flatten_first_step if steps.first.val.is_a?(expression_class)
  end

  def latex
    return '' if steps.length == 0
    copy = self.copy.flatten
    curr_exp = expression_factory.build([copy.steps.first])
    result = copy.steps.first.val.to_s
    for i in 1...copy.steps.length
      step = copy.steps[i]
      result = _add_sbt_mtp_latex(step,result,curr_exp) if step.ops == :add
      result = _add_sbt_mtp_latex(step,result,curr_exp) if step.ops == :sbt
      result = _add_sbt_mtp_latex(step,result,curr_exp) if step.ops == :mtp
      result = _div_latex(step,result) if step.ops == :div
      curr_exp.steps << copy.steps[i]
    end
    result
  end

  def _need_brackets?
    return false if steps.length <= 1
    return (steps.last.ops == :mtp || steps.last.ops == :div) ? false : true
  end

  def _brackets(latex_string)
    "\\left(" + latex_string + "\\right)"
  end

  def _add_sbt_mtp_latex(step,result,curr_exp)
    result = _brackets(result) if _mtp_need_brackets?(step,curr_exp)
    step_latex = step.exp_valued? ? step.val.latex : step.val.to_s
    step_latex = _brackets(step_latex) if _exp_need_brackets?(step)
    result + _ops_latex[step.ops] + step_latex
  end

  def _div_latex(step,result)
    step_latex = step.exp_valued? ? step.val.latex : step.val.to_s
    '\frac{' + result + '}{' + step_latex + '}'
  end

  def _ops_latex
    {:add => '+',:sbt => '-',:mtp => ''}
  end

  def _mtp_need_brackets?(step,curr_exp)
    step.ops == :mtp && curr_exp._need_brackets?
  end

  def _exp_need_brackets?(step)
    step.exp_valued? && step.val._need_brackets?
  end






end
