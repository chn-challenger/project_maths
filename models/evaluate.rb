module Evaluate
  # def evaluate(starting_value,steps)
  #   result = starting_value
  #   steps.each do |step|
  #     result = _evaluate_one_step(result,step)
  #   end
  #   return result
  # end

  def evaluate(steps)
    result = steps.first.val

    for i in 1..steps.length - 1
      result = _evaluate_one_step(result, steps[i])
    end

    result
  end

  private

  def _evaluate_one_step(starting_value, step)
    return nil if starting_value.nil? || step.val.nil?
    return starting_value + step.val if step.ops == :add
    return starting_value * step.val if step.ops == :mtp
    return starting_value - step.val if step.ops == :sbt && step.dir == :rgt
    return starting_value / step.val if step.ops == :div && step.dir == :rgt
    return step.val - starting_value if step.ops == :sbt && step.dir == :lft
    return step.val / starting_value if step.ops == :div && step.dir == :lft
  end
end
