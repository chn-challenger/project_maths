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
    step_class.new(step_config[0], step_config[1], direction)
  end
end

module MtpFormFactory
  def self.build(config_array)
    steps = config_array.inject([]) { |r, e| r << step_factory.build([:mtp, e]) }
    steps.first.ops = nil
    expression_factory.build(steps)
  end
end

module MtpFormSumFactory
  def self.build(config_array)
    steps = []
    config_array.each do |array|
      m_form_exp = mform_factory.build(array[1])
      steps << step_factory.build([array[0], m_form_exp])
    end
    expression_factory.build(steps)
  end
end

module RationalFactory
  def self.build(config_array)
    numerator_exp = mform_factory.build(config_array[0])
    denominator_exp = msum_factory.build(config_array[1])
    expression_factory.build([[nil, numerator_exp], [:div, denominator_exp]])
  end
end

module RationalSumFactory
  def self.build(config_array)
    expression_factory.build(config_array.inject([]) do |steps, array|
      steps << step_factory.build([array[0], rational_factory.build(array[1])])
    end)
  end
end
