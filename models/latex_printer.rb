require './models/fraction'
require './models/serial'
require './models/linear_equation'
require './models/equation'
require './models/question_generator'
include SerialNumber
include ContentGenerator

class LatexPrinter

  FUTURE_NOTES = "\\usepackage{lastpage}\\pagestyle{fancy}  and get rid of \\pagenumbering{gobble}  also add  \\cfoot{\\thepage\ of \\pageref{LastPage}}  to get page numbers"

  TOPICS = {
    linear_equation:{work_sheet_title:'Linear Equation',prefix:'LEQ',
      class_name:LinearEquation},
    fraction:{work_sheet_title:'Fraction',prefix:'FRA',
      class_name:Fraction}
    }

  HEADERS = "\\documentclass{article}\n"\
    "\\usepackage[math]{iwona}\n"\
    "\\usepackage[fleqn]{amsmath}\n"\
    "\\usepackage{scrextend}\n"\
    "\\changefontsizes[20pt]{14pt}\n"\
    "\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n"\
    "\\pagenumbering{gobble}\n"\
    "\\usepackage{fancyhdr}\n"\
    "\\renewcommand{\\headrulewidth}{0pt}\n"\
    "\\pagestyle{fancy}\n"
  SOLUTION_HEADERS = "\\documentclass{article}\n"\
    "\\usepackage[math]{iwona}\n"\
    "\\usepackage[fleqn]{amsmath}\n"\
    "\\usepackage{scrextend}\n"\
    "\\changefontsizes[16pt]{12pt}\n"\
    "\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n"\
    "\\pagenumbering{gobble}\n"\
    "\\usepackage{fancyhdr}\n"\
    "\\renewcommand{\\headrulewidth}{0pt}\n"\
    "\\pagestyle{fancy}\n"
  END_MINIPAGE_ALIGN = "\\end{align*}\n"\
      "\\end{minipage}\n"
  END_MINIPAGE_FLALIGN = "\\end{flalign*}\n"\
      "\\end{minipage}\n"


  def self._begin_align(topic)
    TOPICS[topic][:skip_align] ? '' : "\\begin{align*}\n"
  end

  def self._end_align(topic)
    TOPICS[topic][:skip_align] ? '' : "\\end{align*}\n"
  end

  def self._begin_minipage(layout)
    minipage_width = '%.4f' % (1.to_f / layout[:questions_per_row])
    # "\\begin{minipage}[t]{#{minipage_width}\\textwidth}\n\\begin{align*}\n"
    "\\begin{minipage}[t]{#{minipage_width}\\textwidth}\n"
  end

  def self._end_minipage
    "\\end{minipage}\n"
  end

  def self._begin_minipage_flalign(layout)
    minipage_width = '%.4f' % (1.to_f / layout[:questions_per_row])
    "\\begin{minipage}[t]{#{minipage_width}\\textwidth}\n\\begin{flalign*}\n"
  end

  def self.worksheet_content_latex(questions,topic,layout={})
    layout[:questions_per_row] ||= 2
    topic_class = TOPICS[topic][:class_name]
    number_of_questions = questions.length
    current_question_number = 1
    result_latex = {question_content:'',solution_content:''}
    while current_question_number <= number_of_questions
      if current_question_number % layout[:questions_per_row] == 1 ||
        layout[:questions_per_row] == 1
        result_latex[:question_content] += "\\vspace{10 mm}\n\n\\noindent\n"
        result_latex[:solution_content] += "\\vspace{10 mm}\n\n\\noindent\n"
      end
      current_question = questions[current_question_number-1]
      current_question_latex = topic_class.latex(current_question)
      result_latex[:question_content] += self._begin_minipage(layout) + self._begin_align(topic) + current_question_number.to_s +
        ".\\hspace{30pt}"  + current_question_latex[:question_latex] + "\n" + self._end_align(topic) + self._end_minipage
      result_latex[:solution_content] += self._begin_minipage(layout) + self._begin_align(topic) + current_question_number.to_s +
        ".\\hspace{30pt}"  + current_question_latex[:solution_latex] + "\n" + self._end_align(topic) + self._end_minipage
      current_question_number += 1
    end
    result_latex
  end

  def self.paper_content_latex(questions,layout={})
    layout[:questions_per_row] ||= 1
    number_of_questions = questions.length
    current_question_number = 1
    result_latex = {question_content:'',solution_content:''}
    while current_question_number <= number_of_questions
      if current_question_number % layout[:questions_per_row] == 1 ||
        layout[:questions_per_row] == 1
        result_latex[:question_content] += "\n\\noindent\n"
        result_latex[:solution_content] += "\\vspace{1 mm}\n\n\\noindent\n"
      end
      current_question = questions[current_question_number-1][:question]
      current_topic = questions[current_question_number-1][:topic]
      work_space = questions[current_question_number-1][:work_space]

      current_class = TOPICS[current_topic][:class_name]
      current_question_latex = current_class.latex(current_question)
      result_latex[:question_content] += self._begin_minipage_flalign(layout) + current_question_number.to_s +
        ".\\hspace{30pt}"  + current_question_latex[:question_latex] +
        "\\\\[#{work_space}pt]\n" + '&'*5 + "\\text{Answer\\quad" + "."*30 + "}\n" + END_MINIPAGE_FLALIGN
      result_latex[:solution_content] += self._begin_minipage(layout) + current_question_number.to_s +
        ".\\hspace{30pt}"  + current_question_latex[:solution_latex] + "\n" + self._end_minipage
      current_question_number += 1
    end
    result_latex
  end

  def self.paper_ends(paper_number,student)
    title = 'Practice Paper'
    topic_prefix = 'PP'
    result = {questions:{},solutions:{}}
    serial = generate_serial
    result[:questions][:start] = HEADERS
    result[:questions][:start] += "\\lfoot{#{topic_prefix}-#{serial}-Q\\quad \\textc"\
      "opyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad"\
      " #{student}}\n\\begin{document}\n"
    result[:questions][:start] += "\\section*{\\centerline{#{title} #{paper_number}}}\n"
    result[:questions][:end] = "\\end{document}"
    result[:solutions][:start] = SOLUTION_HEADERS
    result[:solutions][:start] += "\\lfoot{#{topic_prefix}-#{serial}-S\\quad \\textc"\
      "opyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad"\
      " #{student}}\n\\begin{document}\n"
    result[:solutions][:start] += "\\section*{\\centerline{#{title} #{paper_number} Solutions}}\n"
    result[:solutions][:end] = "\\end{document}"
    result
  end

  def self.worksheet_ends(topic,sheet_number,student)
    title,topic_prefix = TOPICS[topic][:work_sheet_title],TOPICS[topic][:prefix]
    result = {questions:{},solutions:{}}
    serial = generate_serial
    result[:questions][:start] = HEADERS
    result[:questions][:start] += "\\lfoot{#{topic_prefix}-#{serial}-Q\\quad \\textc"\
      "opyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad"\
      " #{student}}\n\\begin{document}\n"
    result[:questions][:start] += "\\section*{\\centerline{#{title} #{sheet_number}}}\n"
    result[:questions][:end] = "\\end{document}"
    result[:solutions][:start] = SOLUTION_HEADERS
    result[:solutions][:start] += "\\lfoot{#{topic_prefix}-#{serial}-S\\quad \\textc"\
      "opyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad"\
      " #{student}}\n\\begin{document}\n"
    result[:solutions][:start] += "\\section*{\\centerline{#{title} #{sheet_number} Solutions}}\n"
    result[:solutions][:end] = "\\end{document}"
    result
  end

  def self.paper(contents,paper_number,student,layout={})
    questions = generate_paper_questions(contents)
    content_latex = self.paper_content_latex(questions,layout)
    worksheet_ends = self.paper_ends(paper_number,student)
    questions_sheet = worksheet_ends[:questions][:start] + content_latex[:question_content] + worksheet_ends[:questions][:end]
    solutions_sheet = worksheet_ends[:solutions][:start] + content_latex[:solution_content] + worksheet_ends[:solutions][:end]
    {questions_sheet:questions_sheet,solutions_sheet:solutions_sheet}
  end

  def self.worksheet(topic,sheet_number,student,number_of_questions,parameters={},layout_format={})
    questions = generate_worksheet_questions(number_of_questions,
      TOPICS[topic][:class_name],parameters)
    content_latex = self.worksheet_content_latex(questions,topic,layout_format)
    worksheet_ends = self.worksheet_ends(topic,sheet_number,student)
    questions_sheet = worksheet_ends[:questions][:start] + content_latex[:question_content] + worksheet_ends[:questions][:end]
    solutions_sheet = worksheet_ends[:solutions][:start] + content_latex[:solution_content] + worksheet_ends[:solutions][:end]
    {questions_sheet:questions_sheet,solutions_sheet:solutions_sheet}
  end

end
