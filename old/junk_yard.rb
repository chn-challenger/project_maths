
      # exp_1 = Expression.new([
      #   Step.new(nil,Expression.new([Step.new(nil,2),Step.new(:mtp,'x')])),
      #   Step.new(:sbt,Expression.new([Step.new(nil,3),Step.new(:mtp,'y')])),
      #   Step.new(:add,Expression.new([Step.new(nil,6),Step.new(:mtp,'z')]))
      #   ])
      # step_1 = Step.new(nil,exp_1)
      # step_2 = Step.new(:mtp,Expression.new([Step.new(nil,3),Step.new(:mtp,'a')]))
      # exp_3 = Expression.new([
      #   Step.new(nil,Expression.new([Step.new(nil,4),Step.new(:mtp,'b')])),
      #   Step.new(:mtp,Expression.new([Step.new(nil,'x'),Step.new(:sbt,'y')]))
      #   ])
      # step_3 = Step.new(:sbt,exp_3)
      # step_4 = Step.new(:mtp,Expression.new([Step.new(nil,2),Step.new(:mtp,'c')]))
      # step_5 = Step.new(:div,Expression.new([Step.new(nil,7),Step.new(:mtp,'p')]))
      # example = Expression.new([step_1,step_2,step_3,step_4,step_5])
      # puts example.latex
      # copy = example.copy
      # puts copy.convert_to_rational_sum.latex
      #
      # exp_1 = Expression.new([
      #   Step.new(nil,Expression.new([Step.new(nil,'a'),Step.new(:add,'x')])),
      #   Step.new(:mtp,Expression.new([Step.new(nil,3),Step.new(:sbt,'y')])),
      #   Step.new(:mtp,Expression.new([Step.new(nil,'w'),Step.new(:sbt,'z')]))
      #   ])
      # puts exp_1.latex
      # puts exp_1.convert_to_rational_sum.latex


      # exp_1 = Expression.new([
      #   Step.new(nil,Expression.new([Step.new(nil,'a'),Step.new(:add,'x')])),
      #   Step.new(:div,
      #     Expression.new([
      #       Step.new(:nil,Expression.new([Step.new(nil,3),Step.new(:sbt,'y')])),
      #       Step.new(:div,Expression.new([Step.new(nil,'w'),Step.new(:sbt,'z')]))
      #       ])
      #   )
      #   ])
      # puts exp_1.latex  #bug!!
      # puts exp_1.convert_to_rational_sum.latex


      # step_1 = Step.new(nil,exp_1)
      # step_2 = Step.new(:mtp,Expression.new([Step.new(nil,3),Step.new(:mtp,'a')]))
      # exp_3 = Expression.new([
      #   Step.new(nil,Expression.new([Step.new(nil,4),Step.new(:mtp,'b')])),
      #   Step.new(:mtp,Expression.new([Step.new(nil,'x'),Step.new(:sbt,'y')]))
      #   ])
      # step_3 = Step.new(:sbt,exp_3)
      # step_4 = Step.new(:mtp,Expression.new([Step.new(nil,2),Step.new(:mtp,'c')]))
      # step_5 = Step.new(:div,Expression.new([Step.new(nil,7),Step.new(:mtp,'p'),
      #   Step.new(:sbt,11,:lft),Step.new(:div,Expression.new([Step.new(nil,'f'),Step.new(:add,8)]))]))
      # example = Expression.new([step_1,step_2,step_3,step_4,step_5])
      # puts example.latex
      # copy = example.copy
      # puts 'hi'
      # puts copy.convert_to_rational_sum.latex
      # puts 'world'

      # puts expression.latex




      # def self.build(step_config_array)
      #   steps = _build_first_step(step_config_array.first)
      #   for i in 1...step_config_array.length
      #     if step_config_array[i].is_a?(step_class)
      #       steps << step_config_array[i]
      #     else
      #       step_config_array[i][1] = build(step_config_array[i][1]) if
      #         step_config_array[i][1].is_a?(Array)
      #       steps << step_factory.build(step_config_array[i])
      #     end
      #   end
      #   expression_class.new(steps)
      # end
      #
      # def self._build_first_step(first_step_config)
      #   first_step_config = build(first_step_config) if first_step_config.is_a?(Array)
      #   return [first_step_config] if first_step_config.is_a?(step_class)
      #   [step_factory.build([_first_step_fixed_ops,first_step_config])]
      # end
      #
      # def self._first_step_fixed_ops
      #   nil
      # end
