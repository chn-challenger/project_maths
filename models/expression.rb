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

  def is_rational?
    _is_fractional? && steps.first.is_at_most_m_form? && steps.last.is_at_most_m_form_sum?
  end

  def is_rational_sum?
    _is_sum? && _steps_are_rational?
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

  def _all_steps_numerical?
    steps.each do |step|
      return false if !step.val.is_a?(Fixnum) && !step.val.is_a?(Float)
    end
    return true
  end

  def is_elementary?
    steps.each{|step| return false unless step.is_elementary?}
    return true
  end

  # def simplify_m_forms_in_sum
  #   if _is_gen_m_form_sum?
  #     steps.each do |step|
  #       step.val = step.val.simplify_m_form if step.val.is_a?(self.class)
  #     end
  #   end
  #   self
  # end
  #
  # def convert_string_value_steps_to_m_forms
  #   return self unless (_is_gen_m_form_sum? || _is_gen_rational_sum?)
  #   steps.each do |step|
  #     if step.val.is_a?(String)
  #       step.val = Expression.new([Step.new(nil,1),Step.new(:mtp,step.val)])
  #     end
  #   end
  #   self
  # end
  #
  # def convert_m_form_to_elementary
  #   steps.each do |step|
  #     if !step.is_a?(Fixnum) && !step.is_a?(String) && step.is_m_form?
  #       if step.val.steps.length == 2 && step.val.steps.first.val == 1 && step.val.steps.last.val.is_a?(String)
  #         step.val = step.val.steps.last.val
  #         next
  #       end
  #       if step.val.steps.length == 1
  #         step.val = step.val.steps.first.val
  #         next
  #       end
  #     end
  #   end
  #   self
  # end
  #
  #



# latest iteration



  def expand
    convert_lft_steps
    expanded_steps = []
    steps.each do |step|
      _expand_nil_or_add_into(expanded_steps,step) if _nil_or_add?(step)
      _expand_sbt_into(expanded_steps,step) if step.ops == :sbt
      _expand_mtp_into(expanded_steps,step) if step.ops == :mtp
    end
    self.steps = expanded_steps
    self.steps.first.ops = nil  #this is to be taken out once nullify first step is written
    return self
  end

  def _expand_nil_or_add_into(expanded_steps,step)
    if step.exp_valued?
      step.val.expand
      step.val.steps.first.ops = :add
      step.val.steps.each{|step| expanded_steps << step}
    else
     expanded_steps << step
    end
  end

  def _nil_or_add?(step)
    step.ops == nil || step.ops == :add
  end

  def _expand_sbt_into(expanded_steps,step)
    if step.val.is_a?(expression_class)
      step.val.expand
      step.val._add_sbt_sign_switch
      step.val.steps.each{|step| expanded_steps << step}
    else
     expanded_steps << step
    end
  end

  def _add_sbt_sign_switch
    switch_hash = {nil=>:sbt,:add=>:sbt,:sbt=>:add}
    steps.each{|step| step.ops = switch_hash[step.ops]}
  end

  def _expand_mtp_into(expanded_steps,step)
    step.mtp_prepare_value_as_ms
    init_ms = expression_factory.build(expanded_steps).copy.steps
    expanded_steps.slice!(0..-1)
    step.val.steps.each do |mtp_step|
      _expand_one_mtp_step_into(expanded_steps,init_ms,mtp_step)
    end
    expanded_steps.first.ops = nil
  end

  def _expand_one_mtp_step_into(expanded_steps,init_ms,mtp_step)
    copy_init_ms = expression_factory.build(init_ms).copy.steps
    copy_init_ms.each{|step| expanded_steps << step.em_mtp_em(mtp_step)}
  end

  def flatten
    _flatten_first_steps_recursively
    _flatten_mid_terms_recursively
  end

  def _flatten_first_steps_recursively
    _flatten_first_step
    steps.each do |step|
      step.val._flatten_first_steps_recursively if step.exp_valued?
    end
    self
  end

  def _flatten_first_step
    if steps.first.exp_valued?
      first_steps = steps.first.val.steps
      self.steps.delete_at(0)
      self.steps = first_steps + self.steps
    end
    _flatten_first_step if steps.first.exp_valued?
  end

  def _flatten_mid_terms_recursively
    steps.each do |step|
      step.val = step.val.steps.first.val if _single_ele_step_exp_valued?(step)
      step.val._flatten_mid_terms_recursively if step.exp_valued?
    end
    self
  end

  def _single_ele_step_exp_valued?(step)
    step.exp_valued? && step.val.steps.length == 1 &&
      !step.val.steps.first.exp_valued?
  end

  def latex
    return '' if steps.length == 0
    convert_lft_steps
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

  def flatex #temporary solution for issue 2
    f_sign = {nil=>'+',:add => '+',:sbt => '-',:mtp => '\times',:div => '\div'}
    if steps.length == 2
      _single_f_latex(steps.first.val) + f_sign[steps.last.ops] +
        _single_f_latex(steps.last.val)
    elsif  steps.length == 1
      _single_f_latex(steps.first.val)
    end
  end

  def _single_f_latex(fraction)
    int_latex = fraction.integer == 0 ? '' : fraction.integer.to_s
    frac_latex = '\frac{' + fraction.numerator.to_s + '}{' +
      fraction.denominator.to_s + '}'
    int_latex + frac_latex
  end #end of temporary solution for issue 2

  def _need_brackets?
    return false if steps.length <= 1
    return (steps.last.ops == :mtp || steps.last.ops == :div) ? false : true
  end

  def _brackets(latex_string)
    "\\left(" + latex_string + "\\right)"
  end

  def _add_sbt_mtp_latex(step,result,curr_exp)
    result = _brackets(result) if _mtp_need_brackets?(step,curr_exp)
    result += '\times' if _mtp_need_times_sign?(step,curr_exp)
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

  def _mtp_need_times_sign?(step,curr_exp)
     step.ops == :mtp && (curr_exp.steps.last.ops == :mtp || curr_exp.steps.last.ops == nil) && step.val.is_a?(integer) && curr_exp.steps.last.val.is_a?(integer)
  end

  def _exp_need_brackets?(step)
    step.exp_valued? && step.val._need_brackets?
  end

  def rsum_mtp_rsum(rsum)
    expanded_steps = []
    rsum.steps.each do |r_step|
      self_copy = self.copy
      self_copy.steps.each do |self_step|
        expanded_steps << self_step.r_mtp_r(r_step)
      end
    end
    self.steps = expanded_steps
    self.steps.first.ops = nil
    return self
  end

  def rsum_to_rational
    if steps.length == 1
      step_1 = step_factory.build([nil,[steps.first.val.steps[0]]])
      step_2 = steps.first.val.steps[1]
      self.steps = [step_1,step_2]
      return self
    end
    result_step = steps.first
    for i in 1...steps.length
      result_step = _add_two_rationals(result_step,steps[i])
    end
    self.steps = result_step.val.steps
    return self
  end

  def _add_two_rationals(r_1,r_2)
    nrator_exp_1, dnator_exp_1 = r_1.val.steps[0].val, r_1.val.steps[1].val
    nrator_exp_2, dnator_exp_2 = r_2.val.steps[0].val, r_2.val.steps[1].val
    result_nrator_exp_conf = [
      [r_1.ops,[[nil,nrator_exp_1],[:mtp,dnator_exp_2]]],
      [r_2.ops,[[nil,nrator_exp_2],[:mtp,dnator_exp_1]]]]
    result_dnator_exp_conf = [[nil,dnator_exp_1],[:mtp,dnator_exp_2]]
    result_nrator = expression_factory.build(result_nrator_exp_conf).expand
    result_dnator = expression_factory.build(result_dnator_exp_conf).expand
    step_factory.build([nil,[[nil,result_nrator],[:div,result_dnator]]])
  end

  def rational_to_rsum
    nrator_steps = steps.first.val.steps
    result_steps = []
    nrator_steps.each do |n_step|
      operation = n_step.ops
      n_step.ops = nil
      result_steps << step_factory.build([operation,[n_step,steps.last.copy]])
    end
    self.steps = result_steps
    return self
  end

  def expand_to_rsum
    expanded_steps = []
    steps.each{|step| _expand_step_into(expanded_steps,step)}
    self.steps = expanded_steps
    self.steps.first.ops = nil
    self._clean_one
  end

  def _expand_step_into(expanded_steps,step)
    if step.exp_valued?
      step.val.expand_to_rsum
      _exp_step_into(expanded_steps,step)
    else
      _ele_step_into(expanded_steps,step)
    end
  end

  def _exp_step_into(expanded_steps,step)
    _exp_add_step_into(expanded_steps,step) if step.ops == nil || step.ops == :add
    _exp_sbt_step_into(expanded_steps,step) if step.ops == :sbt
    _exp_mtp_step_into(expanded_steps,step) if step.ops == :mtp
    _exp_div_step_into(expanded_steps,step) if step.ops == :div
  end

  def _ele_step_into(expanded_steps,step)
    _ele_add_step_into(expanded_steps,step) if step.ops == nil || step.ops == :add
    _ele_sbt_step_into(expanded_steps,step) if step.ops == :sbt
    _ele_mtp_step_into(expanded_steps,step) if step.ops == :mtp
    _ele_div_step_into(expanded_steps,step) if step.ops == :div
  end

  def _exp_add_step_into(expanded_steps,step)
    step.val.steps.first.ops = :add
    step.val.steps.each{|step| expanded_steps << step}
  end

  def _exp_sbt_step_into(expanded_steps,step)
    switch_hash = {nil=>:sbt,:add=>:sbt,:sbt=>:add}
    step.val.steps.each do |step|
      step.ops = switch_hash[step.ops]
      expanded_steps << step
    end
  end

  def _exp_mtp_step_into(expanded_steps,step)
    rsum = expression_factory.build(expanded_steps).rsum_mtp_rsum(step.val)
    expanded_steps.slice!(0..-1)
    rsum.steps.each{|step| expanded_steps << step}
  end

  def _exp_div_step_into(expanded_steps,step)
    step.val.rsum_to_rational
    _recipricate(step.val.steps)
    step.val.rational_to_rsum
    _div_mtp(expanded_steps,step)
  end

  def _ele_add_step_into(expanded_steps,step)
    expanded_steps << _wrap_into_rational(step)
  end

  def _ele_sbt_step_into(expanded_steps,step)
    expanded_steps << _wrap_into_rational(step)
  end

  def _ele_mtp_step_into(expanded_steps,step)
    expanded_steps.each{|r_step| r_step.val.steps[0].val.steps << step}
  end

  def _ele_div_step_into(expanded_steps,step)
    expanded_steps.each do |r_step|
      m_sum_dnator = r_step.val.steps[1].val
      dnator = expression_factory.build([[nil,m_sum_dnator],[:mtp,step.val]])
      r_step.val.steps[1].val = dnator.expand
    end
  end

  def _wrap_into_rational(step)
    rational_config = [[step.val],[[nil,[1]]]]
    rational = rational_factory.build(rational_config)
    step_factory.build([step.ops,rational])
  end

  def _recipricate(steps)
      steps[0].val, steps[1].val = steps[1].val, steps[0].val
  end

  def _div_mtp(expanded_steps,step)
    expanded_rsum = expression_factory.build(expanded_steps).rsum_mtp_rsum(step.val)
    expanded_steps.slice!(0..-1)
    expanded_rsum.steps.each do |step|
      expanded_steps << step
    end
  end

  def _clean_one
    steps.each do |step|
      nrator = step.val.steps.first.val
      nrator._clean_nrator
      dnator = step.val.steps.last.val
      dnator._clean_dnator
    end
    self
  end

  def _clean_nrator
    steps.delete(_mtp_one_step)
    steps.delete(_nil_one_step)
    steps << _nil_one_step if steps.length == 0
    steps.first.ops = nil
  end

  def _clean_dnator
    steps.each do |d_step|
      d_step.val.steps.delete(_mtp_one_step)
      d_step.val.steps.delete(_nil_one_step)
      d_step.val.steps << _nil_one_step if d_step.val.steps.length == 0
      d_step.val.steps.first.ops = nil
    end
  end

  def _mtp_one_step
    step_factory.build([:mtp,1])
  end

  def _nil_one_step
    step_factory.build([nil,1])
  end

  def modify_add_mtp_dir_to_rgt
    steps.each do |step|
      step.val.modify_add_mtp_dir_to_rgt if step.exp_valued?
      if step.dir == :lft && (step.ops == :add || step.ops == :mtp)
        step.dir = :rgt
      end
    end
    self
  end

  def convert_lft_steps
    converted_steps = []
    steps.each do |step|
      step.val = step.val.convert_lft_steps if step.exp_valued?
      if step.dir == :lft
        converted_steps = [step_factory.build([nil,step.val]),
          step_factory.build([step.ops,expression_factory.build(converted_steps)])]
      else
        converted_steps << step
      end
    end
    self.steps = converted_steps
    self.flatten
  end

  def simplify_a_m_form
    _combine_m_form_numerical_steps
    copy = self.copy._bsort_m_form_steps
    self.steps = copy.steps
    _standardise_m_form_ops
  end

  def _combine_m_form_numerical_steps
    numerical_steps = steps.collect_move{|step| step.val.is_a?(integer)}
    new_value = numerical_steps.inject(1){|result,step| result *= step.val}
    steps.insert(0,step_factory.build([nil,new_value])) unless new_value == 1
    self
  end

  def _bsort_m_form_steps
    return self if steps.length == 1
    copy = self.copy
    for i in 0..steps.length-2
      if _swap_steps?(steps[i],steps[i+1])
        steps[i],steps[i+1] = steps[i+1],steps[i]
      end
    end
    return self == copy ? self : self._bsort_m_form_steps
  end

  def _swap_steps?(step_1,step_2)
    step_1.val.is_a?(integer) == false &&
    (step_2.val.is_a?(integer) || step_1.val > step_2.val)
  end

  def _standardise_m_form_ops
    steps.first.ops = nil
    for i in 1..steps.length-1
      steps[i].ops = :mtp
    end
    self
  end

  def simplify_all_m_forms
    return simplify_a_m_form if is_m_form?
    steps.each do |step|
      if step.exp_valued?
        if step.val.is_m_form?
          step.val.simplify_a_m_form
        else
          step.val.simplify_all_m_forms
        end
      end
    end
    self
  end

  def similar?(expression)
    self_copy = self.copy
    if self_copy.steps.first.val.is_a?(string)
      self_copy.steps.first.ops = :mtp
      self_copy.steps.insert(0,_nil_one_step)
    end
    exp_copy = expression.copy
    if exp_copy.steps.first.val.is_a?(string)
      exp_copy.steps.first.ops = :mtp
      exp_copy.steps.insert(0,_nil_one_step)
    end
    return false if !self_copy.is_m_form? || !exp_copy.is_m_form?
    return false if self_copy.steps.length != exp_copy.steps.length
    for i in 1..self_copy.steps.length - 1
      return false if self_copy.steps[i] != exp_copy.steps[i]
    end
    return true
    #REFACTOR CHALLENGE!
  end

  #There is another type of more generic simplify method where it searchs for
  #consecutive terms that can be simplified such as 2x + mess + 3x which is
  #not an m-sum but never the less is 5x + mess.  For now we complete the more
  #restrictive version, which should shed light on the more generic version

  def simplify_a_m_sum
    result_steps = []
    m_form_steps = _wrap_into_mforms(steps)
    while m_form_steps.length > 0
      curr_step = m_form_steps.delete_at(0)
      similar_steps = _select_similar_steps(m_form_steps,curr_step)
      combined_step_array = _combine_similar_steps(similar_steps)
      result_steps = result_steps + combined_step_array
    end
    self.steps = result_steps
    if steps.length > 0
      self.steps.first.val.steps.first.val *= -1 if self.steps.first.ops == :sbt
      self.steps.first.ops = nil
    end
    self
  end

  def _wrap_into_mforms(steps)
    steps.inject([]) do |m_steps,step|
      if step.exp_valued?
        m_steps << step
      else
        m_steps << step_factory.build([step.ops,[[nil,step.val]]])
      end
    end
  end

  def _select_similar_steps(m_form_steps,curr_step)
    similar_steps = m_form_steps.collect_move do |step|
      step.val.similar?(curr_step.val)
    end
    similar_steps << curr_step
    similar_steps
  end

  def _combine_similar_steps(similar_steps)
    coefficient = 0
    similar_steps.each do |step|
      if step.val.steps.first.val.is_a?(integer)
        coefficient += step.val.steps.first.val if step.ops == nil || step.ops == :add
        coefficient -= step.val.steps.first.val if step.ops == :sbt
      else
        coefficient += 1 if step.ops == nil || step.ops == :add
        coefficient -= 1 if step.ops == :sbt
      end
    end
    return [] if coefficient == 0
    operation = :add if coefficient > 0
    operation = :sbt if coefficient < 0
    if similar_steps.first.val.steps.first.val.is_a?(integer)
      similar_steps.first.val.steps.first.val = coefficient.abs
    else
      similar_steps.first.val.steps.first.ops = :mtp
      coef_step = step_factory.build([nil,coefficient.abs])
      similar_steps.first.val.steps.insert(0,coef_step)
    end
    similar_steps.first.ops = operation
    [similar_steps.first]
    #ANOTHER WONDERFUL REFACTORING EXERCISE!
  end

  def simplify_all_m_sums
    return self.simplify_a_m_sum if is_m_form_sum?
    steps.each do |step|
      if step.exp_valued?
        if step.val.is_m_form_sum?
          step.val.simplify_a_m_sum
        else
          step.val.simplify_all_m_sums
        end
      end
    end
    self
  end

  def expand_n_simplify #any exp without :div
    convert_lft_steps
    expand
    simplify_all_m_forms
    simplify_all_m_sums
    _remove_m_form_one_coef
    flatten
    self.steps.first.ops = nil
    self
  end

  def _remove_m_form_one_coef #expects an m-form-sum
    steps.each do |step|
      if step.exp_valued? && step.val.steps.first.val == 1
        step.val.steps.delete_at(0)
        step.val.steps.first.ops = nil
      end
    end
    self
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

  #assumptions - there is ONE step with 'x' inside it, could just be 'x'
  #or more likely and expression containing 'x'
  # - the other steps are numerical elementary
  # - the 'x' step has to be step_1 or step_2
  # - there may be many steps after the 'x' step
  def standardise_linear_exp
    # flatten
    # steps[0].val, steps[1].val = steps[1].val, steps[0].val
    # steps[1].dir = :lft
    # _convert_mtp_steps_to_lft


    fail_safe_counter = 1
    while steps.first.val.is_a?(string) == false && fail_safe_counter < 100
      if _str_var_in_step?(steps[0])
        if steps[0].exp_valued?
          steps[0].val.standardise_linear_exp
          flatten
        else
          #do nothing as first step must be (nil,'x')
          #first step is eg  (x2)
          flatten
        end
      end
      if _str_var_in_step?(steps[1])
        if steps[1].exp_valued?
          steps[1].val.standardise_linear_exp

          steps[0].val, steps[1].val = steps[1].val, steps[0].val
          steps[1].dir = :lft

          flatten
        else
          steps[0].val, steps[1].val = steps[1].val, steps[0].val
          steps[1].dir = :lft
        end
      end

      fail_safe_counter += 1
    end

    _convert_mtp_steps_to_lft

    #should only have left mtp steps for the moment - convert at the end
  end

  def _str_var_in_step?(step)
    if step.exp_valued?
      step.val.steps.each do |stp|
        return true if _str_var_in_step?(stp)
      end
    else
      return true if step.val.is_a?(string)
    end
    return false
  end


  def _convert_mtp_steps_to_lft
    steps.each do |step|
      step.val._convert_mtp_steps_to_lft if step.exp_valued?
      step.dir = :lft if step.dir == :rgt && step.ops == :mtp
    end
    self
  end



end
