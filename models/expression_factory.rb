require './models/expression'

module ExpressionFactory
  def self.create_step(step_config)
    direction = step_config[2] || :rgt
    Step.new(step_config[0],step_config[1],direction)
  end

  def self.build(step_config_array)
    steps = step_config_array.inject([]) do |result,step_config|
      step_config[1] = build(step_config[1]) if step_config[1].is_a?(Array)
      result << create_step(step_config)
    end
    Expression.new(steps)
  end
end
