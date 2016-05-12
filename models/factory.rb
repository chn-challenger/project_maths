require './models/expression'
require './models/class_name'

include ClassName

module ExpressionFactory
  def self.build(step_config_array)
    steps = []
    step_config_array.each do |step_config|
      if step_config.is_a?(step_class)
        steps << step_config
      else
        step_config[1] = build(step_config[1]) if step_config[1].is_a?(Array)
        steps << step_factory.build(step_config)
      end
    end
    expression_class.new(steps)
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
