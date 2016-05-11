require 'forwardable'
class Expression
  attr_reader :value

  include Enumerable
  extend Forwardable
  def_delegators :@value, :size, :each, :[]

  def initialize(value=[])
    @value = value
  end

  def ==(expression)
    value == expression.value
  end

  def copy
    self.class.new(value.inject([]){|result,element| result << element.copy})
  end

  def expand_to_ms
    ms_exp = ms_klass.new
    value.each do |step|
      step.expand_into_ms(ms_exp)
    end
    ms_exp
  end

  def ms_klass
    MtpFormSumExp
  end
end

class Step
  attr_reader :ops, :val, :dir

  def initialize(ops,val,dir=:rgt)
    @ops = ops
    @val = val
    @dir = dir
  end

  def ==(step)
    ops == step.ops && val = step.val && dir == step.dir
  end

  def expand_into_ms(ms_exp)
    val.expand_into_ms(ms_exp,self)
  end

  def append(step)
    m_form = val.convert_to_m_form
    m_form.value << step
    @val = m_form
  end
end

class NumExp
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def expand_into_ms(ms_exp,step)
    case step.ops
    when nil then ms_exp.value << step
    when :add then ms_exp.value << step
    when :sbt then ms_exp.value << step
    when :mtp then ms_exp.value.each{|mf_step| mf_step.append(step)}
    end
  end

  def convert_to_m_form
    mf_klass.new([step_klass.new(nil,self)])
  end

  def mf_klass
    MtpFormExp
  end

  def step_klass
    Step
  end
end

class MtpFormExp
  attr_reader :value

  def initialize(value=[])
    @value = value
  end

  def ==(expression)
    value == expression.value
  end
end

class MtpFormSumExp
  attr_reader :value

  def initialize(value=[])
    @value = value
  end

  def ==(expression)
    value == expression.value
  end
end


# a = Expression.new()
# p a.ms_klass

# number_1 = NumExp.new(10)
# number_2 = NumExp.new(5)
# step_1 = Step.new(:some_ops,number_1)
# step_2 = Step.new(:mtp,number_2)
# step_1.append(step_2)
# p step_1


#
# class StringExp
#   attr_reader :value
#
#   def initialize(value)
#     @value = value
#   end
# end
#
# class StringStep
#   attr_reader :ops, :val, :dir
#
#   def initialize(ops,val,dir=:rgt)
#     @ops = ops
#     @val = val
#     @di
#   end
#
#   def mtp_num_step(step)
#
#
#   end
#
# end


################################################
#
# NumExp
#
#   def expand_add_into_ms(ms_exp)
#     return a ms_exp
#   end
#
#   def expand_sbt_into_ms(ms_exp)
#     return a ms_exp
#   end
#
#   def expand_mtp_into_ms(ms_exp)
#     return a ms_exp
#   end
#
# StringExp
#
#   def expand_add_into_ms(ms_exp)
#     return a ms_exp
#   end
#
#   def expand_sbt_into_ms(ms_exp)
#     return a ms_exp
#   end
#
#   def expand_mtp_into_ms(ms_exp)
#     return a ms_exp
#   end
#
# Expression
#
#   def expand_to_ms(ms_klass)
#     ms_expression = ms_klass.new(#empty one)
#     steps.each do |step|
#       ms_expression = step.expand_into_ms(ms_expression)
#       #no expand_ has no idea what kind of object each step is, but it doesn't matter
#       #it is a duck type that implements expand_into_ms(ms_expression)
#       #every step class is expected to implement the method.
#       #each of these implementation knows of the return object type,
#       #this type maybe taken off ms_expression.class.new
#     end
#     return ms_expression
#   end
#
# Step
#
#   def expand_into_ms
#     case :add
#       ms_expression = val.expand_add_into_ms(ms_expression)
#       #the step does not know what type of val it holds,
#       #but it knows val will implment expand_add_into_ms(ms_expression)
#       #and return another ms_expression
#       return ms_expression
#     case :sbt
#       ms_expression = val.expand_sbt_into_ms(ms_expression)
#       return ms_expression
#     case :mtp
#       ms_expression = val.expand_mtp_into_ms(ms_expression)
#       return ms_expression
#   end
#
#
#
# ################################################
#
#
# end



# module Operations
#   def add
#     :add
#   end
#
#   def sbt
#     :sbt
#   end
#
#   def mtp
#     :mtp
#   end
# end


# case ops
#
#
# # when nil then val.expand_add_into_ms(ms_exp,self.class)
# #MAYBE this should be moved into each expand_in_ms method for each val
#
# when :add then val.expand_add_into_ms(ms_exp,self.class)
# when :sbt then val.expand_sbt_into_ms(ms_exp,self.class)
# when :mtp then val.expand_mtp_into_ms(ms_exp,self.class)
# end
