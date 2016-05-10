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

  def expand
    expanded_steps = []
    steps.each do |step|
      expanded_steps = step.expand_into(expanded_steps)
    end
    expanded_steps
  end
end

class NumExp
  attr_reader :val

  def initialize(val)
    @val = val
  end
end

class NumStep
  attr_reader :ops, :dir

  extend Forwardable
  def_delegators :@val, :val

  def initialize(ops,val,dir=:rgt)
    @ops = ops
    @val = val
    @dir = dir
  end

  # def ==(step)
  #   ops == step.ops && val = step.val && dir = step.dir
  # end

  def expand_into(steps)  #this assumes all directions are right
    return steps << self if ops == :add || ops == :sbt
    if ops == :mtp
      steps.each do |step|
        step = step.multiply_num_step(self)
      end
    end
  end

  def multiply_num_step(step,exp_class=NumExp)
    new_value = val * step.val
    num_exp = exp_class.new(new_value)
    self.class.new(ops,num_exp)
  end

end

class StringExp
  attr_reader :val

  def initialize(val)
    @val = val
  end
end

class StringStep
  attr_reader :ops, :val, :dir

  def initialize(ops,val,dir=:rgt)
    @ops = ops
    @val = val
    @dir = dir
  end
end
