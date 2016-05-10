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
      ms_exp = step.expand_into_ms(ms_exp)
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
    when :add then val.expand_add_into_ms(ms_exp)
    when :sbt then val.expand_sbt_into_ms(ms_exp)
    when :mtp then val.expand_mtp_into_ms(ms_exp)
    end
  end
end

class NumExp
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def mtp_num_exp(num_exp)
    new_value = value * num_exp.value
    self.class.new(new_value)
  end
end



class StringExp
  attr_reader :value

  def initialize(value)
    @value = value
  end
end

class StringStep
  attr_reader :ops, :val, :dir

  def initialize(ops,val,dir=:rgt)
    @ops = ops
    @val = val
    @dir = dir
  end

  def mtp_num_step(step)


  end

end


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
