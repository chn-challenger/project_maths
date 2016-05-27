require './models/expression'
require './models/fraction'
require './models/factory'


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

  def is_m_form_sum?
    is_elementary? ? false : val.is_m_form_sum?
  end

  def is_rational_sum?
    is_elementary? ? false : val.is_rational_sum?
  end

  def is_at_most_m_form?
    is_elementary? || is_m_form?
  end

  def is_at_most_rational?
    is_elementary? || is_m_form? || is_rational?
  end

  def is_at_most_m_form_sum?
    is_elementary? || is_m_form? || is_m_form_sum?
  end

  def reverse_step
    return self.class.new(:sbt,val) if ops == :add || ops == nil
    return self.class.new(:div,val) if ops == :mtp
    return self.class.new(:mtp,val) if ops == :div && dir == :rgt
    return self.class.new(:add,val) if ops == :sbt && dir == :rgt
    return self.copy if ops == :div && dir == :lft
    return self.copy if ops == :sbt && dir == :lft
  end

  def em_mtp_em(step)
    sign = _sign(step)
    self_copy, step_copy = self.copy, step.copy
    value_config = self_copy._e_mtp_e(step_copy) if _e_and_e?(step)
    value_config = self_copy._e_mtp_m(step_copy) if _e_and_m?(step)
    value_config = self_copy._m_mtp_e(step_copy) if _m_and_e?(step)
    value_config = self_copy._m_mtp_m(step_copy) if _m_and_m?(step)
    step_factory.build([sign,value_config])
  end

  def _sign(step)
    ops == step.ops || (ops == nil && step.ops == :add) ||
      (ops == :add && step.ops == nil) || (ops == :add && step.ops == :mtp) ||
      (ops == nil && step.ops == :mtp) ? :add : :sbt
  end

  def _e_and_e?(step)
    !val.is_a?(expression_class) && !step.val.is_a?(expression_class)
  end

  def _e_mtp_e(step)
    self.ops, step.ops = nil, :mtp
    [self,step]
  end

  def _e_and_m?(step)
    !val.is_a?(expression_class) && step.val.is_a?(expression_class)
  end

  def _e_mtp_m(step)
    self.ops, step.val.steps.first.ops = nil, :mtp
    value_config = [self] + step.val.steps
  end

  def _m_and_e?(step)
    val.is_a?(expression_class) && !step.val.is_a?(expression_class)
  end

  def _m_mtp_e(step)
    step.ops, self.val.steps.first.ops = :mtp, nil
    value_config = self.val.steps + [step]
  end

  def _m_and_m?(step)
    val.is_a?(expression_class) && step.val.is_a?(expression_class)
  end

  def _m_mtp_m(step)
    step.val.steps.first.ops = :mtp
    value_config = self.val.steps + step.val.steps
  end

  def mtp_prepare_value_as_ms  #not really it is an m-form
    copy = self.copy
    if val.is_a?(expression_class)
      val.expand
    else
      copy.ops = nil
      self.val = expression_factory.build([copy])
    end
    self
  end

  def exp_valued?
    val.is_a?(expression_class)
  end

  def r_mtp_r(r_step)
    nrator_1, nrator_2 = self.val.steps[0], r_step.val.steps[0]
    nrator = expression_factory.build(nrator_1._m_mtp_m(nrator_2))
    dnator_1, dnator_2 = self.val.steps[1].val, r_step.val.steps[1].val
    dnator = expression_factory.build([[nil,dnator_1],[:mtp,dnator_2]]).expand
    step_factory.build([_sign(r_step),[[nil,nrator],[:div,dnator]]])
  end

  def _wrap_ele_to_mform
    self.val = expression_factory.build([[nil,val]])
    self
  end




end
