require './models/expression'

module ExpressionFactory
  def self.create_step(step_config)
    direction = step_config[2] || :rgt
    step_class.new(step_config[0],step_config[1],direction)
  end

  def self.build(step_config_array)
    steps = _build_first_step(step_config_array.first)
    for i in 1...step_config_array.length
      step_config_array[i][1] = build(step_config_array[i][1]) if
        step_config_array[i][1].is_a?(Array)
      steps << create_step(step_config_array[i])
    end
    expression_class.new(steps)
  end

  def self._build_first_step(first_step_config)
    first_step_config = build(first_step_config) if first_step_config.is_a?(Array)
    [create_step([nil,first_step_config])]
  end

  def self.expression_class
    Expression
  end

  def self.step_class
    Step
  end
end
