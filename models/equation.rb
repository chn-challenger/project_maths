require './models/expression'

class Equation

  attr_accessor :left_side, :right_side, :solution

  def initialize(left_side=Expression.new,right_side=Expression.new,solution={})
    @left_side = left_side
    @right_side = right_side
    @solution = solution
  end

  def ==(equation)
    left_side == equation.left_side && right_side == equation.right_side &&
      solution == equation.solution
  end

  def copy
    new_left_side = left_side.copy
    new_right_side = right_side.copy
    new_solution = solution.dup
    self.class.new(new_left_side, new_right_side, new_solution)
  end

  def latex(with_alignment = true)
    if with_alignment
      left_side.latex + '&=' + right_side.latex
    else
      left_side.latex + '=' + right_side.latex
    end
  end

  def collect_like_terms
    for i in 0..left_side.steps.length-1
      for j in 0..right_side.steps.length-1
        if (left_side.steps[i].exp_valued? && right_side.steps[j].exp_valued?) && left_side.steps[i].val.similar?(right_side.steps[j].val)
          left_value = left_side.steps[i].val.steps.first.val
          left_value *= -1 if left_side.steps[i].ops == :sbt
          right_value = right_side.steps[j].val.steps.first.val
          right_value *= -1 if right_side.steps[j].ops == :sbt
          if left_value <= right_value
            step_to_move = left_side.steps.delete_at(i)
            if step_to_move.ops == nil || step_to_move.ops == :add
              step_to_move.ops = :sbt
            else
              step_to_move.ops = :add
            end
            right_side.steps << step_to_move
          else
            step_to_move = right_side.steps.delete_at(j)
            if step_to_move.ops == nil || step_to_move.ops == :add
              step_to_move.ops = :sbt
            else
              step_to_move.ops = :add
            end
            left_side.steps << step_to_move
          end
          return collect_like_terms
        end
      end
    end
    self
  end

end
