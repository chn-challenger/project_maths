require 'forwardable'
class Expression
  attr_reader :steps

  include Enumerable
  extend Forwardable
  def_delegators :@steps, :size, :each, :[]

  def initialize(steps=[])
    @steps = steps
  end

  def ==(expression)
    steps == expression.steps
  end

  def copy
    self.class.new(steps.inject([]){|result,element| result << element.copy})
  end

  def expand_to_ms(ms_klass)
    ms_exp = ms_klass.new
    steps.each do |step|
      step.expand_into_ms(ms_exp)
    end
    ms_exp
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
    case ops  #this assumes all directions are right
    when :add then val.expand_add_into_ms(ms_exp,self.class)
    when :sbt then val.expand_sbt_into_ms(ms_exp,self.class)
    when :mtp then val.expand_mtp_into_ms(ms_exp,self.class)
    end
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

  def expand_add_into_ms(ms_exp,step_klass)
    ms_exp.steps << step_klass.new(:add,self)
  end

  def expand_mtp_into_ms(ms_exp,step_klass)
    mtp_step = step_klass.new(:mtp,self)
    ms_exp.steps.each do |step|

      # step.val_to_mf  #convert the value of the step to mf class
      step.append(mtp_step) #this ask step to append mtp_step at the end of it
      #'s value expression 's steps array, provided it is actually a ms
      #since self has no idea what kind of thing step is, it is delegating
      #the tasking of append to step, step will in turn delegate the task to
      #its value - since depending on its value class, the append work
      #differently
    end
    #the method has no return value, it also modifies the ms_exp just
    #like expand_add_into_ms
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

  def initialize(value)
    @value = value
  end
end

class MtpFormSumExp
  attr_reader :steps

  def initialize(steps)
    @steps = steps
  end
end

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
