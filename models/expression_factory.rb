require './models/expression'
require './models/class_name'

include ClassName

module ExpressionFactory
  def self.build(step_config_array)
    steps = _build_first_step(step_config_array.first)
    for i in 1...step_config_array.length
      if step_config_array[i].is_a?(step_class)
        steps << step_config_array[i]
      else
        step_config_array[i][1] = build(step_config_array[i][1]) if
          step_config_array[i][1].is_a?(Array)
        steps << step_factory.build(step_config_array[i])
      end
    end
    expression_class.new(steps)
  end

  def self._build_first_step(first_step_config)
    first_step_config = build(first_step_config) if first_step_config.is_a?(Array)
    return [first_step_config] if first_step_config.is_a?(step_class)
    [step_factory.build([_first_step_fixed_ops,first_step_config])]
  end

  def self._first_step_fixed_ops
    nil
  end
end

module StepFactory
  def self.build(step_config)
    step_config[1] = expression_factory.build(step_config[1]) if
      step_config[1].is_a?(Array)
    direction = step_config[2] || :rgt
    step_class.new(step_config[0],step_config[1],direction)
  end
end
