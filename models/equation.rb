require './models/expression'
require 'timeout'

class Equation
  attr_accessor :left_side, :right_side, :solution

  def initialize(left_side = Expression.new, right_side = Expression.new, solution = {})
    @left_side = left_side
    @right_side = right_side
    @solution = solution
  end

  def ==(equation)
    left_side == equation.left_side && right_side == equation.right_side &&
      solution == equation.solution
  end

  def copy
    new_left_side = Timeout.timeout(1, NoMethodError) { left_side.copy }
    new_right_side = Timeout.timeout(1, NoMethodError) { right_side.copy }
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
    for i in 0..left_side.steps.length - 1
      for j in 0..right_side.steps.length - 1
        next unless (left_side.steps[i].exp_valued? && right_side.steps[j].exp_valued?) && left_side.steps[i].val.similar?(right_side.steps[j].val)
        left_value = left_side.steps[i].val.steps.first.val
        left_value *= -1 if left_side.steps[i].ops == :sbt
        right_value = right_side.steps[j].val.steps.first.val
        right_value *= -1 if right_side.steps[j].ops == :sbt
        if left_value <= right_value
          step_to_move = left_side.steps.delete_at(i)
          step_to_move.ops = if step_to_move.ops.nil? || step_to_move.ops == :add
                               :sbt
                             else
                               :add
                             end
          right_side.steps << step_to_move
        else
          step_to_move = right_side.steps.delete_at(j)
          step_to_move.ops = if step_to_move.ops.nil? || step_to_move.ops == :add
                               :sbt
                             else
                               :add
                             end
          left_side.steps << step_to_move
        end
        return collect_like_terms
      end
    end
    self
    # A side from the obvious refactors, this method does not NEED recursion
    # And refactoring OUT recurssion will for large equations improve performance
  end

  def _standardise_m_sums
    left_side.simplify_all_m_sums
    right_side.simplify_all_m_sums
    self
  end

  def _age_problem_expand
    left_side.expand.simplify_all_m_forms
    right_side.expand.simplify_all_m_forms
    self
  end

  def flatten
    left_side.flatten
    right_side.flatten
    self
  end

  def _remove_m_form_one_coef
    left_side._remove_m_form_one_coef
    right_side._remove_m_form_one_coef
    self
  end

  def _age_problem_simplify_m_sums
    # left_side.simplify_all_m_sums._remove_m_form_one_coef
    # right_side.simplify_all_m_sums._remove_m_form_one_coef
    left_side.simplify_all_m_sums
    right_side.simplify_all_m_sums

    self
  end

  def standardise_linear_equation
    left_side.flatten
    right_side.flatten
    left_side.standardise_linear_exp if left_side.steps.length > 1
    right_side.standardise_linear_exp if right_side.steps.length > 1
    self
  end

  def same_change(step)
    left_side.steps << step
    right_side.steps << step
  end

end
