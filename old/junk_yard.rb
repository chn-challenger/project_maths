
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
