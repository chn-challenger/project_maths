
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




  #
  #
  # def expand_to_rsum
  #   expanded_steps = []
  #   steps.each do |step|
  #     _nil_or_add_into_rsum(expanded_steps,step) if _nil_or_add?(step)
  #     _mtp_into_rsum(expanded_steps,step) if step.ops == :mtp
  #     _div_into_rsum(expanded_steps,step) if step.ops == :div
  #   end
  #   self.steps = expanded_steps
  #   self.steps.first.ops = nil  #this is to be taken out once nullify first step is written
  #   self._clean_one
  #   return self
  # end
  #
  # def _nil_or_add_into_rsum(expanded_steps,step)
  #   if step.exp_valued?
  #     step.val.expand_to_rsum
  #     step.val.steps.first.ops = :add
  #     step.val.steps.each{|step| expanded_steps << step}
  #   else
  #    expanded_steps << _wrap_into_rational(step)
  #   end
  # end
  #
  # def _wrap_into_rational(step)
  #   rational_config = [[step.val],[[nil,[1]]]]
  #   rational = rational_factory.build(rational_config)
  #   step_factory.build([step.ops,rational])
  # end
  #
  # def _mtp_into_rsum(expanded_steps,step)
  #   if step.exp_valued?
  #     step.val.expand_to_rsum
  #     expanded_rsum = expression_factory.build(expanded_steps).rsum_mtp_rsum(step.val)
  #     expanded_steps.slice!(0..-1)
  #     expanded_rsum.steps.each{|step| expanded_steps << step}
  #   else
  #     expanded_steps.each{|r_step| r_step.val.steps[0].val.steps << step}
  #   end
  # end
  #
  # def _div_into_rsum(expanded_steps,step)
  #   if step.exp_valued?
  #     step.val.expand_to_rsum
  #     step.val.rsum_to_rational
  #     _recipricate(step.val.steps)
  #     step.val.rational_to_rsum
  #     _div_mtp(expanded_steps,step)
  #   else
  #     expanded_steps.each do |r_step|
  #       m_sum_dnator = r_step.val.steps[1].val
  #       init_m_sum_step = step_factory.build([nil,m_sum_dnator])
  #       mtp_step = step_factory.build([:mtp,step.val])
  #       expanded_m_sum = expression_factory.build([init_m_sum_step,mtp_step]).expand
  #       r_step.val.steps[1].val = expanded_m_sum
  #     end
  #   end
  # end
  #
  # def _recipricate(steps)
  #     steps[0].val, steps[1].val = steps[1].val, steps[0].val
  # end
  #
  # def _div_mtp(expanded_steps,step)
  #   expanded_rsum = expression_factory.build(expanded_steps).rsum_mtp_rsum(step.val)
  #   expanded_steps.slice!(0..-1)
  #   expanded_rsum.steps.each do |step|
  #     expanded_steps << step
  #   end
  # end
  #
  # def _clean_one
  #   _mtp_one_step = step_factory.build([:mtp,1])
  #   _nil_one_step = step_factory.build([nil,1])
  #   steps.each do |step|
  #     nrator = step.val.steps.first.val
  #     nrator.steps.delete(_mtp_one_step)
  #     nrator.steps.delete(_nil_one_step)
  #     if nrator.steps.length == 0
  #       nrator.steps << _nil_one_step
  #     end
  #     nrator.steps.first.ops = nil
  #     dnator = step.val.steps.last.val
  #     dnator.steps.each do |d_step|
  #       d_step.val.steps.delete(_mtp_one_step)
  #       d_step.val.steps.delete(_nil_one_step)
  #       if d_step.val.steps.length == 0
  #         d_step.val.steps << _nil_one_step
  #       end
  #       d_step.val.steps.first.ops = nil
  #     end
  #   end
  #   self
  # end



    # def flatten_old_version
    #   _flatten_first_step
    #   steps.each do |step|
    #     step.val.flatten if step.val.is_a?(expression_class)
    #   end
    #   self
    # end
    #
    # def _flatten_first_step_old_version
    #   if steps.first.val.is_a?(expression_class)
    #     first_steps = steps.first.val.steps
    #     self.steps.delete_at(0)
    #     self.steps = first_steps + self.steps
    #   end
    #   _flatten_first_step if steps.first.val.is_a?(expression_class)
    # end



      # def simplify_m_form
      #   return self unless is_m_form?
      #   _combine_m_form_numerical_steps
      #   _bsort_m_form_steps
      #   _standardise_m_form_ops
      # end
      #
      # def _combine_m_form_numerical_steps
      #   numerical_steps = steps.collect_move{|step| step.val.is_a?(Fixnum)}
      #   new_value = numerical_steps.inject(1){|result,step| result *= step.val}
      #   steps.insert(0,Step.new(nil,new_value))
      #   self
      # end
      #
      # def _bsort_m_form_steps
      #   return self if steps.length == 1
      #   copy = self.copy
      #   for i in 0..steps.length-2
      #     if steps[i].val.is_a?(Fixnum)
      #       next
      #     end
      #     if steps[i+1].val.is_a?(Fixnum)
      #       steps[i],steps[i+1] = steps[i+1],steps[i]
      #       next
      #     end
      #     if steps[i].val > steps[i+1].val
      #       steps[i],steps[i+1] = steps[i+1],steps[i]
      #       next
      #     end
      #   end
      #   return self == copy ? self : self._bsort_m_form_steps
      # end
      #
      # def _standardise_m_form_ops
      #   steps.first.ops = nil
      #   for i in 1..steps.length-1
      #     steps[i].ops = :mtp
      #   end
      #   self
      # end
