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
  attr_reader :ops, :val, :dir

  def initialize(ops,val,dir=:rgt)
    @ops = ops
    @val = val
    @dir = dir
  end

end
