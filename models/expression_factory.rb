require './models/expression'

module ExpressionFactory
  def self.build(step_config_array)
    steps = _build_first_step(step_config_array.first)
    for i in 1...step_config_array.length
      step_config_array[i][1] = build(step_config_array[i][1]) if
        step_config_array[i][1].is_a?(Array)
      steps << _step_factory.build(step_config_array[i])
    end
    _expression_class.new(steps)
  end

  def self._build_first_step(first_step_config)
    first_step_config = build(first_step_config) if first_step_config.is_a?(Array)
    [_step_factory.build([nil,first_step_config])]
  end

  def self._expression_class
    Expression
  end

  def self._step_class
    Step
  end

  def self._step_factory
    StepFactory
  end
end

module StepFactory
  def self.build(step_config)
    step_config[1] = _expression_factory.build(step_config[1]) if
      step_config[1].is_a?(Array)
    direction = step_config[2] || :rgt
    _step_class.new(step_config[0],step_config[1],direction)
  end

  def self._step_class
    Step
  end

  def self._expression_factory
    ExpressionFactory
  end
end

#
# module ExpressionFactory
#   def self.build(step_config_array)
#     steps = _build_first_step(step_config_array.first)
#     for i in 1...step_config_array.length
#       step_config_array[i][1] = build(step_config_array[i][1]) if
#         step_config_array[i][1].is_a?(Array)
#       steps << _create_step(step_config_array[i])
#     end
#     _expression_class.new(steps)
#   end
#
#   # def self._create_step(step_config)
#   #   direction = step_config[2] || :rgt
#   #   _step_class.new(step_config[0],step_config[1],direction)
#   # end
#
#   def self._build_first_step(first_step_config)
#     first_step_config = build(first_step_config) if first_step_config.is_a?(Array)
#     # [_create_step([nil,first_step_config])]
#   end
#
#   def self._expression_class
#     Expression
#   end
#
#   def self._step_class
#     Step
#   end
#
#   def self._step_factory
#     StepFactory
#   end
# end
