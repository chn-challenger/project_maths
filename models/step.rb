require './models/expression'
require './models/fraction'

class Step

  attr_accessor :ops, :val, :dir

  DIGITS = ['0','1','2','3','4','5','6','7','8','9']

  def initialize(operation=nil,value=nil,orientation=:rgt)
    @ops = operation
    @val = value
    @dir = orientation
  end

  def ==(step)
    return false if step.is_a?(self.class) == false
    (ops == step.ops) && (val == step.val) && (dir == step.dir)
  end

  def copy
    copy_val = val.dup if val.is_a?(String)
    copy_val = val if val.is_a?(Fixnum)
    copy_val = val.copy if val.is_a?(Expression)
    self.class.new(ops,copy_val,dir)
  end

  def is_elementary?
    val.is_a?(String) || val.is_a?(Fixnum) || val.is_a?(Fraction)
  end

  def is_m_form?
    is_elementary? ? false : val.is_m_form?
  end

  def is_rational?
    is_elementary? ? false : val.is_rational?
  end

  def _is_gen_rational?
    is_elementary? ? false : val._is_gen_rational?
  end

  def is_m_form_sum?
    is_elementary? ? false : val.is_m_form_sum?
  end

  def _is_gen_m_form_sum?
    is_elementary? ? false : val._is_gen_m_form_sum?
  end

  def is_rational_sum?
    is_elementary? ? false : val.is_rational_sum?
  end

  def _is_gen_rational_sum?
    is_elementary? ? false : val._is_gen_rational_sum?
  end

  def is_at_most_m_form?
    is_elementary? || is_m_form?
  end

  def is_at_most_rational?
    is_elementary? || is_m_form? || is_rational?
  end

  def _is_at_most_gen_rational?
    is_elementary? || is_m_form? || _is_gen_rational?
  end

  def is_at_most_m_form_sum?
    is_elementary? || is_m_form? || is_m_form_sum?
  end

  def elementary_to_m_form
    self.class.new(ops,Expression.new([self.class.new(nil,self.val)]))
  end

  def at_most_m_form_to_m_form_sum
    return is_m_form_sum? ?
      self : self.class.new(ops,Expression.new([self.class.new(nil,val)]))
  end

  def result_sign(step)
    _together_negative?(step) ? :sbt : :add
  end

  def _is_add?
    ops == nil || ops == :add
  end

  def _together_negative?(step)
    (ops == :sbt && step._is_add?) || (self._is_add? && step.ops == :sbt)
  end

  def e_or_m_step_to_m_step
    return is_elementary? ? elementary_to_m_form  : self
  end

  def at_most_m_step_mtp_at_most_m_step(step)
    e_or_m_step_to_m_step._m_step_mtp_m_step(step.e_or_m_step_to_m_step)
  end

  def _m_step_mtp_m_step(m_step)
    new_steps = m_step.val.steps.collect do |step|
      self.class.new(:mtp,step.val)
    end
    self.class.new(ops,Expression.new(self.val.steps + new_steps))
  end

  def at_most_m_sum_mtp_at_most_m_sum(step)
    at_most_m_form_to_m_form_sum.val.m_sum_mtp_m_sum(
      step.at_most_m_form_to_m_form_sum.val)
  end

  def to_rational
    self.val = (self.is_elementary? || self.is_m_form?) ?
      Expression.new([self.class.new(nil,val),self.class.new(:div,1)]) : self.val
    self
  end

  def r_step_mtp_r_step(r_step)
    numerator_step = to_rational.val.steps.first.at_most_m_step_mtp_at_most_m_step(
      r_step.to_rational.val.steps.first)
    numerator_step.ops = nil
    denominator_exp = val.steps.last.at_most_m_sum_mtp_at_most_m_sum(r_step.val.steps.last)
    denominator_step = self.class.new(:div,denominator_exp)
    self.class.new(ops,Expression.new([numerator_step,denominator_step]))
  end

  def step_mtp_step(step)
    return (is_at_most_m_form? && step.is_at_most_m_form?) ?
      at_most_m_step_mtp_at_most_m_step(step) : r_step_mtp_r_step(step)
  end

  def _prepare_both_rational_steps(step)
    self.to_rational
    step.to_rational
    self.val.steps[1].ops = :mtp
    step.val.steps[1].ops = :mtp
  end

  def _rational_add_rational_numerator(step)
    step_1 = self.class.new(nil,Expression.new([val.steps[0],step.val.steps[1]]).convert_to_rational_sum)
    step_2 = self.class.new(step.ops,Expression.new([step.val.steps[0],val.steps[1]]).convert_to_rational_sum)
    final_exp = Expression.new([step_1,step_2]).convert_to_rational_sum
    self.class.new(nil,final_exp)
  end

  def _rational_add_rational_denominator(step)
    val.steps[1].ops = nil
    step.val.steps[1].ops = :mtp
    final_denominator_exp = Expression.new([val.steps[1],step.val.steps[1]]).convert_to_rational_sum
    self.class.new(:div,final_denominator_exp)
  end

  def at_most_rational_add_at_most_rational(step)
    _prepare_both_rational_steps(step)
    numerator = _rational_add_rational_numerator(step)
    denominator = _rational_add_rational_denominator(step)
    self.class.new(nil,Expression.new([numerator,denominator]))
  end

  def nil_step_latex
    if is_elementary?
      return val.to_s if val.is_a?(Fixnum) || val.is_a?(String)
      if val.is_a?(Fraction)
        # latex = val.integer == 0 ? "" : val.integer.to_s
        # return latex + '\frac{' + val.numerator.to_s + '}{' +
        #   val.denominator.to_s + '}' if val.is_a?(Fraction)
        int_part = val.integer == 0 ? "" : val.integer.to_s
        frac_part = val.numerator == 0 ? "" : '\frac{' + val.numerator.to_s + '}{' + val.denominator.to_s + '}'
        return (int_part == '' && frac_part == '') ? '0' : int_part + frac_part
      end
    end
    return val.to_s if is_elementary?
    return val.m_form_latex if is_m_form?
    return val.m_form_sum_latex if is_m_form_sum?
    return val.rational_latex if is_rational?
    return val.latex
  end

  def is_proper_sum?
    !is_elementary? && val._is_sum? && val.steps.length >= 2
  end

  def is_non_standard?
    !_is_at_most_gen_rational? && !_is_gen_m_form_sum?
  end

  def add_or_sbt_rgt_step_latex
    return _latex_add_sbt + _surround_brackets(nil_step_latex) if
      (is_proper_sum? || is_non_standard?) && !(val.steps.last._is_mtp_or_div?)
    return _latex_add_sbt + nil_step_latex
  end

  def _is_mtp_or_div?
    ops == :mtp || ops == :div
  end

  def add_or_sbt_lft_step_latex(current_latex,previous_steps)
    if _left_add_sbt_need_brackets?(previous_steps)
      nil_step_latex + _latex_add_sbt + _surround_brackets(current_latex)
    else
      nil_step_latex + _latex_add_sbt + current_latex
    end
  end

  def mtp_step_latex(current_latex,previous_steps)
    new_latex = nil_step_latex
    prev_steps_exp = Expression.new(previous_steps)
    if is_at_most_m_form? && !prev_steps_exp.is_m_form? &&
      !(prev_steps_exp._is_gen_m_form_sum? && previous_steps.length == 1)
      direction = :lft
    else
      direction = dir
    end
    if !is_elementary? && !is_m_form? && !_is_gen_rational? &&
      !((_is_gen_m_form_sum? || _is_gen_rational_sum?) && val.steps.length == 1)
      new_latex = _surround_brackets(new_latex)
      bracket_on_new = true
    end
    if !prev_steps_exp.is_m_form? &&
      !(prev_steps_exp._is_gen_m_form_sum? && previous_steps.length == 1)
      current_latex = _surround_brackets(current_latex)
      bracket_on_current = true
    end
    if direction == :lft
      if (!bracket_on_new && !bracket_on_current &&
        DIGITS.include?(new_latex[-1]) && DIGITS.include?(current_latex[0])) ||
        (val.is_a?(Fraction) && previous_steps.last.val.is_a?(Fraction))
          new_latex + '\times' + current_latex
      else
        new_latex + current_latex
      end
    else
      if !bracket_on_new && !bracket_on_current &&
        DIGITS.include?(current_latex[-1]) && DIGITS.include?(new_latex[0]) ||
        (val.is_a?(Fraction) && previous_steps.last.val.is_a?(Fraction))
          current_latex + '\times' + new_latex
      else
        current_latex + new_latex
      end
    end
  end

  def div_step_latex(current_latex,previous_steps)
    if val.is_a?(Fraction) && previous_steps.last.val.is_a?(Fraction)
      if dir == :lft
        nil_step_latex + '\div' + current_latex
      else
        current_latex + '\div' + nil_step_latex
      end
    else
      if dir == :lft
        '\frac{' + nil_step_latex + '}{' + current_latex + '}'
      else
        '\frac{' + current_latex + '}{' + nil_step_latex + '}'
      end
    end
  end

  def _left_add_sbt_need_brackets?(previous_steps)
    prev_steps_exp = Expression.new(previous_steps)
    !prev_steps_exp.is_m_form? && !prev_steps_exp._is_gen_rational? &&
      !(prev_steps_exp._is_gen_m_form_sum? && previous_steps.length == 1) &&
      !(prev_steps_exp._is_gen_rational_sum? && previous_steps.length == 1) &&
      !(previous_steps.last.ops == :mtp || previous_steps.last.ops == :div)
  end

  def _latex_add_sbt
    return '+' if ops == :add
    return '-' if ops == :sbt
  end

  def _surround_brackets(current_latex)
    '\left(' + current_latex + '\right)'
  end

  def reverse_step
    return self.class.new(:sbt,val) if ops == :add || ops == nil
    return self.class.new(:div,val) if ops == :mtp
    return self.class.new(:mtp,val) if ops == :div && dir == :rgt
    return self.class.new(:add,val) if ops == :sbt && dir == :rgt
    return self.copy if ops == :div && dir == :lft
    return self.copy if ops == :sbt && dir == :lft
  end


end
