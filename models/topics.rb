module Topics
  def topics
    {
      linear_equation: { work_sheet_title: 'Linear Equation', prefix: 'LEQ',
                         class_name: LinearEquation },
      fraction: { work_sheet_title: 'Fraction', prefix: 'FRA',
                  class_name: Fraction },
      age_problem: { work_sheet_title: 'Age Problem', prefix: 'AGP',
                     class_name: AgeProblem, skip_align: true, text_start: true }
    }
  end
end
