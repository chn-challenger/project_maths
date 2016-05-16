
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
      # expected_exp = expression_factory.build([
      #   [nil,[[nil,2],[:mtp,4],[:mtp,'y'],[:mtp,7]]],
      #   [:sbt,[[nil,3],[:mtp,'x'],[:mtp,4],[:mtp,'y'],[:mtp,7]]],
      #   [:sbt,[[nil,5],[:mtp,7]]],
      #   [:sbt,[[nil,6],[:mtp,'z'],[:mtp,7]]],
      #   [:sbt,[[nil,2],[:mtp,4],[:mtp,'y'],[:mtp,8],[:mtp,'w']]],
      #   [:add,[[nil,3],[:mtp,'x'],[:mtp,4],[:mtp,'y'],[:mtp,8],[:mtp,'w']]],
      #   [:add,[[nil,5],[:mtp,8],[:mtp,'w']]],
      #   [:add,[[nil,6],[:mtp,'z'],[:mtp,8],[:mtp,'w']]]
      # ])


      # result = expression_factory.build(steps.first.val.steps)
      # _not_flat? ? expression_factory.build(steps.first.val.steps)._outer_flatten : self



        #
        #
        # def new_latex  #all steps are right-sided, no division
        #   # copy = self.copy.flatten
        #   latex = ''
        #   latexed_exp = expression_factory.build([])
        #   steps.each do |step|
        #     if step.ops == nil
        #       if step.val.is_a?(expression_class)
        #         latex += step.val.new_latex
        #       else
        #         latex += step.val.to_s
        #       end
        #     end
        #
        #     if step.ops == :add
        #       if step.val.is_a?(expression_class)
        #         step_latex = step.val.new_latex
        #         step_latex = _latex_brackets(step_latex) if step.val._add_step_need_bracket?
        #         latex += '+' + step_latex
        #       else
        #         latex += '+' + step.val.to_s
        #       end
        #     end
        #
        #     if step.ops == :sbt
        #       if step.val.is_a?(expression_class)
        #         step_latex = step.val.new_latex
        #         step_latex = _latex_brackets(step_latex) if step.val._add_step_need_bracket?
        #         latex += '-' + step_latex
        #       else
        #         latex += '-' + step.val.to_s
        #       end
        #     end
        #
        #     if step.ops == :mtp
        #       if step.val.is_a?(expression_class)
        #         latex = _latex_brackets(latex) if latexed_exp._step_mtp_need_bracket?
        #         step_latex = step.val.new_latex
        #         step_latex = _latex_brackets(step_latex) if step.val._mtp_step_need_bracket?
        #         latex += step_latex
        #       else
        #         latex = _latex_brackets(latex) if latexed_exp._step_mtp_need_bracket?
        #         latex += step.val.to_s
        #       end
        #     end
        #
        #     latexed_exp.steps << step
        #
        #   end
        #
        #   return latex
        #
        # end
        #
        # def _latex_brackets(latex_string)
        #   "\\left(" + latex_string + "\\right)"
        # end
        #
        # def _add_step_need_bracket?
        #   steps.each do |step|
        #     return true if step.ops == :add || step.ops == :sbt
        #   end
        #   return false
        # end
        #
        # def _step_mtp_need_bracket?
        #   steps.each do |step|
        #     return true if step.ops == :add || step.ops == :sbt
        #   end
        #   return false
        # end
        #
        # def _mtp_step_need_bracket?
        #   steps.each do |step|
        #     return true if step.ops == :add || step.ops == :sbt
        #   end
        #   return false
        # end


          # def flatten
          #   _outer_flatten.steps.each do |step|
          #     step.val = step.val.flatten if step.val.is_a?(expression_class)
          #   end
          #   self
          # end
          #
          # def _not_flat?
          #   steps.length == 1 && steps.first.val.is_a?(expression_class)
          # end
          #
          # def _outer_flatten
          #   if _not_flat?
          #     self.steps = steps.first.val.steps
          #     return self._outer_flatten
          #   end
          #   self
          # end


            # def _outer_flatten
            #   if _not_flat?
            #     self.steps = steps.first.val.steps
            #     return self._outer_flatten
            #   end
            #   self
            # end


            #
            # def new_latex
            #   return '' if steps.length == 0
            #
            #   copy = self.copy.flatten
            #
            #   latexed_exp = expression_factory.build([copy.steps.first])
            #
            #   latex = copy.steps.first.val.to_s #after flatten, first step has to be non-exp valued
            #
            #   for i in 1...copy.steps.length
            #     if copy.steps[i].ops == :add
            #       step_val = copy.steps[i].val
            #       if step_val.is_a?(expression_class)
            #         step_latex = step_val.new_latex
            #         step_latex = _latex_brackets(step_latex) if step_val._add_step_need_bracket?
            #         latex += '+' + step_latex
            #       else
            #         latex += '+' + step_val.to_s
            #       end
            #     end
            #
            #     if copy.steps[i].ops == :sbt
            #       step_val = copy.steps[i].val
            #       if step_val.is_a?(expression_class)
            #         step_latex = step_val.new_latex
            #         step_latex = _latex_brackets(step_latex) if step_val._sbt_step_need_bracket?
            #         latex += '-' + step_latex
            #       else
            #         latex += '-' + step_val.to_s
            #       end
            #     end
            #
            #     if copy.steps[i].ops == :mtp
            #       step_val = copy.steps[i].val
            #       if step_val.is_a?(expression_class)
            #         latex = _latex_brackets(latex) if latexed_exp._step_mtp_need_bracket?
            #         step_latex = step_val.new_latex
            #         step_latex = _latex_brackets(step_latex) if step_val._mtp_step_need_bracket?
            #         latex += step_latex
            #       else
            #         latex = _latex_brackets(latex) if latexed_exp._step_mtp_need_bracket?
            #         latex += step_val.to_s
            #       end
            #     end
            #
            #     if copy.steps[i].ops == :div
            #       step_val = copy.steps[i].val
            #       if step_val.is_a?(expression_class)
            #         step_latex = step_val.new_latex
            #         latex = '\frac{' + latex + '}{' + step_latex + '}'
            #       else
            #         latex = '\frac{' + latex + '}{' + step_val.to_s + '}'
            #       end
            #     end
            #
            #     latexed_exp.steps << copy.steps[i]
            #
            #   end
            #
            #   return latex
            #
            # end
            #
            # def _latex_brackets(latex_string)
            #   "\\left(" + latex_string + "\\right)"
            # end
            #
            # def _add_step_need_bracket?
            #   return false if steps.length <= 1
            #   return (steps.last.ops == :mtp || steps.last.ops == :div) ? false : true
            # end
            #
            # def _sbt_step_need_bracket?
            #   return false if steps.length <= 1
            #   return (steps.last.ops == :mtp || steps.last.ops == :div) ? false : true
            # end
            #
            # def _step_mtp_need_bracket?
            #   return false if steps.length <= 1
            #   return (steps.last.ops == :mtp || steps.last.ops == :div) ? false : true
            # end
            #
            # def _mtp_step_need_bracket?
            #   return false if steps.length <= 1
            #   return (steps.last.ops == :mtp || steps.last.ops == :div) ? false : true
            # end

              # def latex
              #   return '' if steps.length == 0
              #
              #   copy = self.copy.flatten
              #
              #   new_latexed_exp = expression_factory.build([copy.steps.first])
              #
              #   new_latex = copy.steps.first.val.to_s #after flatten, first step has to be non-exp valued
              #
              #   for i in 1...copy.steps.length
              #     if copy.steps[i].ops == :add
              #       step_val = copy.steps[i].val
              #       if step_val.is_a?(expression_class)
              #         step_latex = step_val.latex
              #         step_latex = _latex_brackets(step_latex) if step_val._need_brackets?
              #         new_latex += '+' + step_latex
              #       else
              #         new_latex += '+' + step_val.to_s
              #       end
              #     end
              #
              #     if copy.steps[i].ops == :sbt
              #       step_val = copy.steps[i].val
              #       if step_val.is_a?(expression_class)
              #         step_latex = step_val.latex
              #         step_latex = _latex_brackets(step_latex) if step_val._need_brackets?
              #         new_latex += '-' + step_latex
              #       else
              #         new_latex += '-' + step_val.to_s
              #       end
              #     end
              #
              #     if copy.steps[i].ops == :mtp
              #       step_val = copy.steps[i].val
              #       if step_val.is_a?(expression_class)
              #         new_latex = _latex_brackets(new_latex) if new_latexed_exp._need_brackets?
              #         step_latex = step_val.latex
              #         step_latex = _latex_brackets(step_latex) if step_val._need_brackets?
              #         new_latex += step_latex
              #       else
              #         new_latex = _latex_brackets(new_latex) if new_latexed_exp._need_brackets?
              #         new_latex += step_val.to_s
              #       end
              #     end
              #
              #     if copy.steps[i].ops == :div
              #       step_val = copy.steps[i].val
              #       if step_val.is_a?(expression_class)
              #         step_latex = step_val.latex
              #         new_latex = '\frac{' + new_latex + '}{' + step_latex + '}'
              #       else
              #         new_latex = '\frac{' + new_latex + '}{' + step_val.to_s + '}'
              #       end
              #     end
              #
              #     new_latexed_exp.steps << copy.steps[i]
              #
              #   end
              #
              #   return new_latex
              #
              # end
