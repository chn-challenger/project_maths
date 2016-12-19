require './models/fraction'
require './models/serial'
require './models/linear_equation'
require './models/age_problem'
require './models/equation'
require './models/question_generator'
require './models/topics'

include SerialNumber
include ContentGenerator
include Topics

class LatexPrinter

  FUTURE_NOTES = "\\usepackage{lastpage}\\pagestyle{fancy}  and get rid of \\pagenumbering{gobble}  also add  \\cfoot{\\thepage\ of \\pageref{LastPage}}  to get page numbers"

  TOPICS = {
    linear_equation:{work_sheet_title:'Linear Equation',prefix:'LEQ',
      class_name:LinearEquation},
    fraction:{work_sheet_title:'Fraction',prefix:'FRA',
      class_name:Fraction},
    age_problem:{work_sheet_title:'Age Problem',prefix:'AGP',
      class_name:AgeProblem,skip_align:true,text_start:true}
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

  def self._begin_align
    "\\begin{align*}\n"
  end

  def self._end_align
    "\\end{align*}\n"
  end

  def self._begin_falign
    "\\begin{flalign*}\n"
  end

  def self._end_falign
    "\\end{flalign*}$\\$\n"
  end

  def self._begin_minipage(layout)
    minipage_width = '%.4f' % (1.to_f / layout[:questions_per_row])
    "\\begin{minipage}[t]{#{minipage_width}\\textwidth}\n"
  end

  def self._end_minipage
    "\\end{minipage}\n"
  end

  def self.worksheet_content_latex(questions,topic,layout={})
    layout[:questions_per_row] ||= 2
    topic_class = topics[topic][:class_name]
    number_of_questions = questions.length
    current_question_number = 1
    result_latex = {question_content:'',solution_content:'', rails_content: ''}
    while current_question_number <= number_of_questions
      if current_question_number % layout[:questions_per_row] == 1 ||
        layout[:questions_per_row] == 1
        if current_question_number != 1
          result_latex[:question_content] += "\\vspace{10 mm}\n\n"
          result_latex[:solution_content] += "\\vspace{10 mm}\n\n"
        end
        result_latex[:question_content] += "\\noindent\n"
        result_latex[:solution_content] += "\\noindent\n"
      end
      current_question = questions[current_question_number-1]
      current_question_latex = topic_class.latex(current_question)
      question_number = current_question_number.to_s + ".\\hspace{30pt}" + "\n"
      insert_index = topics[topic][:text_start]? 11 : 0

      question_latex = current_question_latex[:question_latex].dup.
        insert(insert_index,question_number)

      result_latex[:question_content] += _begin_minipage(layout) +
        _begin_align + question_latex + "\n" + _end_align + _end_minipage

      solution_latex = current_question_latex[:solution_latex].dup.
        insert(insert_index,question_number)

      result_latex[:solution_content] += _begin_minipage(layout) +
        _begin_align + solution_latex + "\n" + _end_align + _end_minipage

      current_question_number += 1
    end
    result_latex
  end

  def self.rails_sheet_latex(questions, topic, parameters={})
    topic_class = topics[topic][:class_name]
    number_of_questions = questions.length
    current_question_number = 1
    result_latex = ' '

    while current_question_number <= number_of_questions
      current_question = questions[current_question_number-1]
      current_question_latex = topic_class.latex(current_question, parameters)
      rails_question_latex = current_question_latex[:rails_question_latex]
      result_latex += rails_question_latex
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
      current_question_latex = topics[current_topic][:class_name].
        latex(current_question)
      question_number = current_question_number.to_s + ".\\hspace{30pt}"
      insert_index = topics[current_topic][:text_start]? 11 : 0
      question_latex = current_question_latex[:question_latex].dup.
        insert(insert_index,question_number)
      result_latex[:question_content] += _begin_minipage(layout) +
        _begin_falign + question_latex + "\\\\[#{work_space}pt]\n" + '&'*5 +
        "\\text{Answer\\quad" + "."*30 + "}\n" + _end_falign + _end_minipage
      solution_latex = current_question_latex[:solution_latex].dup.
        insert(insert_index,question_number)
      result_latex[:solution_content] += _begin_minipage(layout) +
        _begin_align + solution_latex + "\n" + _end_align + _end_minipage
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
    result[:questions][:start] += "\\section*{\\centerline{#{title} #{paper_number}}}\n\n"
    result[:questions][:end] = "\\end{document}"
    result[:solutions][:start] = SOLUTION_HEADERS
    result[:solutions][:start] += "\\lfoot{#{topic_prefix}-#{serial}-S\\quad \\textc"\
      "opyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad"\
      " #{student}}\n\\begin{document}\n\n"
    result[:solutions][:start] += "\\section*{\\centerline{#{title} #{paper_number} Solutions}}\n\n"
    result[:solutions][:end] = "\\end{document}"
    result
  end

  def self.worksheet_ends(topic,sheet_number,student)
    title,topic_prefix = topics[topic][:work_sheet_title],topics[topic][:prefix]
    result = {questions:{},solutions:{}}
    serial = generate_serial
    result[:questions][:start] = HEADERS
    result[:questions][:start] += "\\lfoot{#{topic_prefix}-#{serial}-Q\\quad \\textc"\
      "opyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad"\
      " #{student}}\n\\begin{document}\n"
    result[:questions][:start] += "\\section*{\\centerline{#{title} #{sheet_number}}}\n\n"
    result[:questions][:end] = "\\end{document}"
    result[:solutions][:start] = SOLUTION_HEADERS
    result[:solutions][:start] += "\\lfoot{#{topic_prefix}-#{serial}-S\\quad \\textc"\
      "opyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad"\
      " #{student}}\n\\begin{document}\n"
    result[:solutions][:start] += "\\section*{\\centerline{#{title} #{sheet_number} Solutions}}\n\n"
    result[:solutions][:end] = "\\end{document}"
    result
  end

  def self.rails_ends
    rails = {questions:{},solutions:{}}
    rails[:questions][:start] = HEADERS
    rails[:questions][:start] += "\\lfoot{#{Time.now}-Q\\quad \\text copyright\\,
    Joe Zhou, 2016}\n\n \\begin{document}\n\n"
    rails[:questions][:end] = "\\end{document}"
    rails
  end

  def self.paper(contents,paper_number,student,layout={})
    questions = generate_paper_questions(contents)
    content_latex = self.paper_content_latex(questions,layout)
    worksheet_ends = self.paper_ends(paper_number,student)
    questions_sheet = decorate_sheet(:questions, content_latex[:question_content], worksheet_ends)
    solutions_sheet = decorate_sheet(:solutions, content_latex[:solution_content], worksheet_ends)
    {questions_sheet:questions_sheet,solutions_sheet:solutions_sheet}
  end

  def self.decorate_sheet(type_sym, latex_content, tex_wrappers)
    tex_wrappers[type_sym][:start] + latex_content + tex_wrappers[type_sym][:end]
  end

  def self.worksheet(topic,sheet_number,student,number_of_questions,parameters={},layout_format={})
    questions = generate_worksheet_questions(number_of_questions,
      topics[topic][:class_name],parameters)
    content_latex = self.worksheet_content_latex(questions,topic,layout_format)
    worksheet_ends = self.worksheet_ends(topic,sheet_number,student)
    questions_sheet = decorate_sheet(:questions, content_latex[:question_content], worksheet_ends)
    solutions_sheet = decorate_sheet(:solutions, content_latex[:solution_content], worksheet_ends)
    {questions_sheet: questions_sheet, solutions_sheet: solutions_sheet}
  end

  def self.rails_sheet(topic,number_of_questions,parameters={})
    questions = generate_worksheet_questions(number_of_questions,
      topics[topic][:class_name],parameters)
    rails_tex_ends = rails_ends
    content_latex = self.rails_sheet_latex(questions,topic, parameters)

    decorate_sheet(:questions, content_latex, rails_tex_ends)
  end

end
