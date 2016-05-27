require './models/linear_equation'
require './models/age_problem'
require './models/topics'

include Topics

module ContentGenerator
  def generate_worksheet_questions(number_of_questions=10,klass=Fraction,parameters={})
    questions = []
    number_of_questions.times {questions << klass.generate_question(parameters)}
    questions
  end

  def generate_paper_questions(contents=[])
    questions = []
    contents.each do |content|
      content[:parameters] ||= {}
      content[:number_of_questions] ||= 1
      content[:work_space] ||= 200
      content[:number_of_questions].times do
        question = topics[content[:topic]][:class_name].generate_question(content[:parameters])
        questions << {question:question,topic:content[:topic],work_space:content[:work_space]}
      end
    end
    questions
  end
end
