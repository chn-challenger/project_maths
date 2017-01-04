require './models/latex_printer'

describe LatexPrinter do
  before(:each) do
    srand(100)
  end

  describe '#self.worksheet' do
    context 'generate worksheet for Fraction class' do
      let(:worksheet) { described_class.worksheet(:fraction, 21, 'Robert Hook', 2) }
      let(:question) { '9\frac{3}{5}+12\frac{1}{2}' }
      let(:solution) { '5\frac{1}{2}\times2\frac{3}{4}=15\frac{1}{8}' }

      before do
        allow_any_instance_of(ContentGenerator).to receive(:generate_worksheet_questions).and_return([{ question_latex: question, solution_latex: solution }, { question_latex: question, solution_latex: solution }])
      end

      it 'generates fraction questions sheet' do
        expect(worksheet[:questions_sheet]).to eq "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[20pt]{14pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{FRA-IY377042-Q\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad Robert Hook}\n\\begin{document}\n\\section*{\\centerline{Fraction 21}}\n\n\\noindent\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n1.\\hspace{30pt}\n9\\frac{3}{5}+12\\frac{1}{2}\n\\end{align*}\n\\end{minipage}\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n2.\\hspace{30pt}\n9\\frac{3}{5}+12\\frac{1}{2}\n\\end{align*}\n\\end{minipage}\n\\end{document}"
      end

      it 'generates solution for the fraction questions sheet' do
        expect(worksheet[:solutions_sheet]).to eq "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[16pt]{12pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{FRA-IY377042-S\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad Robert Hook}\n\\begin{document}\n\\section*{\\centerline{Fraction 21 Solutions}}\n\n\\noindent\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n1.\\hspace{30pt}\n5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n2.\\hspace{30pt}\n5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\end{document}"
      end
    end
  end

  context 'generate worksheet for Linear Equation class' do
    let(:worksheet) do
      described_class.worksheet(:linear_equation, 5,
                                'Isaac Newton', 4)
    end
    let!(:question) { '4\\left(6\\left(x-2\\right)+76\\right)&=496' }
    let!(:solution) { '5\frac{1}{2}\times2\frac{3}{4}=15\frac{1}{8}' }

    before do
      allow_any_instance_of(ContentGenerator).to receive(:generate_worksheet_questions).and_return([{ question_latex: question, solution_latex: solution }, { question_latex: question, solution_latex: solution }, { question_latex: question, solution_latex: solution }, { question_latex: question, solution_latex: solution }])
    end

    it 'generates linear equation questions sheet' do
      expect(worksheet[:questions_sheet]).to eq "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[20pt]{14pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{LEQ-IY377042-Q\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad Isaac Newton}\n\\begin{document}\n\\section*{\\centerline{Linear Equation 5}}\n\n\\noindent\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n1.\\hspace{30pt}\n#{question}\n\\end{align*}\n\\end{minipage}\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n2.\\hspace{30pt}\n#{question}\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n3.\\hspace{30pt}\n#{question}\n\\end{align*}\n\\end{minipage}\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n4.\\hspace{30pt}\n#{question}\n\\end{align*}\n\\end{minipage}\n\\end{document}"
    end

    it 'generates solution for the linear equation questions sheet' do
      expect(worksheet[:solutions_sheet]).to eq "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[16pt]{12pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{LEQ-IY377042-S\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad Isaac Newton}\n\\begin{document}\n\\section*{\\centerline{Linear Equation 5 Solutions}}\n\n\\noindent\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n1.\\hspace{30pt}\n#{solution}\n\\end{align*}\n\\end{minipage}\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n2.\\hspace{30pt}\n#{solution}\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n3.\\hspace{30pt}\n#{solution}\n\\end{align*}\n\\end{minipage}\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n4.\\hspace{30pt}\n#{solution}\n\\end{align*}\n\\end{minipage}\n\\end{document}"
    end
  end

  context 'generate rails sheet to be parsed' do
    let(:rails_sheet) do
      described_class.rails_sheet(:linear_equation, 2)
    end
    let(:rails_sheet) do
      described_class.rails_sheet(:simultaneous_equation, 2)
    end

    let!(:question) { '4\\left(6\\left(x-2\\right)+76\\right)&=496' }
    let!(:solution) { '5\frac{1}{2}\times2\frac{3}{4}=15\frac{1}{8}' }

    before do
      Timecop.freeze
      allow_any_instance_of(ContentGenerator).to receive(:generate_worksheet_questions).and_return([{ rails_question_latex: question + solution }, { rails_question_latex: question + solution }])

      allow(LinearEquation).to receive(:latex).and_return({rails_question_latex: question + solution})
    end

    after do
      Timecop.return
    end

    it 'generates standard linear equations rails sheet' do
      expect(rails_sheet).to eq "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[20pt]{14pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{#{Time.now}-Q\\quad \\text copyright\\,\n    Joe Zhou, 2017}\n\n \\begin{document}\n\n #{question}#{solution}#{question}#{solution}\\end{document}"
    end

    it 'generates standard simultaneous equations rails sheet' do
      expect(rails_sheet).to eq "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[20pt]{14pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{#{Time.now}-Q\\quad \\text copyright\\,\n    Joe Zhou, 2017}\n\n \\begin{document}\n\n #{question}#{solution}#{question}#{solution}\\end{document}"
    end

  end

  context 'generate worksheet for simultaneous equation class' do
    let(:worksheet) do
      described_class.worksheet(:simultaneous_equation, 21, 'Robert Hook', 3,
                                {}, questions_per_row: 1)
    end

    let!(:question) { '4\\left(6\\left(x-2\\right)+76\\right)&=496' }
    let!(:solution) { '5\frac{1}{2}\times2\frac{3}{4}=15\frac{1}{8}' }

    before do
      allow_any_instance_of(ContentGenerator).to receive(:generate_worksheet_questions).and_return([{ question_latex: question, solution_latex: solution }, { question_latex: question, solution_latex: solution }, { question_latex: question, solution_latex: solution }])
    end

    it 'generates simultaneous equation questions sheet' do
      expect(worksheet[:questions_sheet]).to eq "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[20pt]{14pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{SMQ-IY377042-Q\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad Robert Hook}\n\\begin{document}\n\\section*{\\centerline{Simultaneous Equation 21}}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n1.\\hspace{30pt}\n4\\left(6\\left(x-2\\right)+76\\right)&=496\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n2.\\hspace{30pt}\n4\\left(6\\left(x-2\\right)+76\\right)&=496\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n3.\\hspace{30pt}\n4\\left(6\\left(x-2\\right)+76\\right)&=496\n\\end{align*}\n\\end{minipage}\n\\end{document}"
    end

    it 'generates simultaneous equation questions sheet' do
      expect(worksheet[:solutions_sheet]).to eq "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[16pt]{12pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{SMQ-IY377042-S\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad Robert Hook}\n\\begin{document}\n\\section*{\\centerline{Simultaneous Equation 21 Solutions}}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n1.\\hspace{30pt}\n5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n2.\\hspace{30pt}\n5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n3.\\hspace{30pt}\n5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\end{document}"
    end

  end


  context 'generate non-standard worksheet for linear equation class' do
    let(:worksheet) do
      described_class.worksheet(:linear_equation, 5,
                                'Isaac Newton', 2, { number_of_steps: 6, multiple_division: true },
                                questions_per_row: 1)
    end

    let!(:question) { '4\\left(6\\left(x-2\\right)+76\\right)&=496' }
    let!(:solution) { '5\frac{1}{2}\times2\frac{3}{4}=15\frac{1}{8}' }

    before do
      allow_any_instance_of(ContentGenerator).to receive(:generate_worksheet_questions).and_return([{ question_latex: question, solution_latex: solution }, { question_latex: question, solution_latex: solution }])
    end

    it 'generates non standard linear equation questions sheet' do
      expect(worksheet[:questions_sheet]).to eq "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[20pt]{14pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{LEQ-IY377042-Q\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad Isaac Newton}\n\\begin{document}\n\\section*{\\centerline{Linear Equation 5}}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n1.\\hspace{30pt}\n4\\left(6\\left(x-2\\right)+76\\right)&=496\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n2.\\hspace{30pt}\n4\\left(6\\left(x-2\\right)+76\\right)&=496\n\\end{align*}\n\\end{minipage}\n\\end{document}"
    end

    it 'generates solution for the non standard linear equation sheet' do
      expect(worksheet[:solutions_sheet]).to eq "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[16pt]{12pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{LEQ-IY377042-S\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad Isaac Newton}\n\\begin{document}\n\\section*{\\centerline{Linear Equation 5 Solutions}}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n1.\\hspace{30pt}\n5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n2.\\hspace{30pt}\n5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\end{document}"
    end
  end

  context 'generate worksheet for Age Problem class' do
    let(:worksheet) do
      described_class.worksheet(:age_problem, 11, 'Leonhard Euler',
                                4, {}, questions_per_row: 1)
    end

    let!(:question) { '\intertext{This is an Age Problem.}' }
    let!(:solution) { '\intertext{This is an Age Problem Solution.}' }

    before do
      allow_any_instance_of(ContentGenerator).to receive(:generate_worksheet_questions).and_return([{ question_latex: question, solution_latex: solution }, { question_latex: question, solution_latex: solution }, { question_latex: question, solution_latex: solution }, { question_latex: question, solution_latex: solution }])
    end

    it 'generates age problem questions sheet' do
      expect(worksheet[:questions_sheet]).to eq "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[20pt]{14pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{AGP-IY377042-Q\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad Leonhard Euler}\n\\begin{document}\n\\section*{\\centerline{Age Problem 11}}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n\\intertext{1.\\hspace{30pt}\nThis is an Age Problem.}\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n\\intertext{2.\\hspace{30pt}\nThis is an Age Problem.}\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n\\intertext{3.\\hspace{30pt}\nThis is an Age Problem.}\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n\\intertext{4.\\hspace{30pt}\nThis is an Age Problem.}\n\\end{align*}\n\\end{minipage}\n\\end{document}"
    end

    it 'generates age problem solutions sheet'  do
      expect(worksheet[:solutions_sheet]).to eq "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[16pt]{12pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{AGP-IY377042-S\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad Leonhard Euler}\n\\begin{document}\n\\section*{\\centerline{Age Problem 11 Solutions}}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n\\intertext{1.\\hspace{30pt}\nThis is an Age Problem Solution.}\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n\\intertext{2.\\hspace{30pt}\nThis is an Age Problem Solution.}\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n\\intertext{3.\\hspace{30pt}\nThis is an Age Problem Solution.}\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n\\intertext{4.\\hspace{30pt}\nThis is an Age Problem Solution.}\n\\end{align*}\n\\end{minipage}\n\\end{document}"

    end
  end

  describe '#self.paper' do
    context 'generate practice paper with questions from each topic' do
      let(:contents) do
        [{ topic: :fraction, number_of_questions: 3, work_space: 100 },
         { topic: :linear_equation },
         { topic: :fraction },
         { topic: :linear_equation, number_of_questions: 2 },
         { topic: :age_problem, number_of_questions: 2, work_space: 160 }]
      end
      let!(:question) { '4\\left(6\\left(x-2\\right)+76\\right)&=496' }
      let!(:solution) { '5\frac{1}{2}\times2\frac{3}{4}=15\frac{1}{8}' }
      let(:paper) { described_class.paper(contents, 3, 'James Davis') }

      before do
        allow_any_instance_of(ContentGenerator).to receive(:generate_worksheet_questions).and_return([{ question: 'Q1', solution: 'S1' }, { question: 'Q1', solution: 'S1' }, { question: 'Q1', solution: 'S1' }])

        allow(AgeProblem).to receive(:latex).and_return(question_latex: question, solution_latex: solution)
        allow(Fraction).to receive(:latex).and_return(question_latex: question, solution_latex: solution)
        allow(LinearEquation).to receive(:latex).and_return(question_latex: question, solution_latex: solution)
      end

      it 'generates practice paper questions sheet' do
        expect(paper[:questions_sheet]).to eq "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[20pt]{14pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{PP-UP763904-Q\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad James Davis}\n\\begin{document}\n\\section*{\\centerline{Practice Paper 3}}\n\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{flalign*}\n1.\\hspace{30pt}4\\left(6\\left(x-2\\right)+76\\right)&=496\\\\[100pt]\n&&&&&\\text{Answer\\quad..............................}\n\\end{flalign*}$\\$\n\\end{minipage}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{flalign*}\n2.\\hspace{30pt}4\\left(6\\left(x-2\\right)+76\\right)&=496\\\\[100pt]\n&&&&&\\text{Answer\\quad..............................}\n\\end{flalign*}$\\$\n\\end{minipage}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{flalign*}\n3.\\hspace{30pt}4\\left(6\\left(x-2\\right)+76\\right)&=496\\\\[100pt]\n&&&&&\\text{Answer\\quad..............................}\n\\end{flalign*}$\\$\n\\end{minipage}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{flalign*}\n4.\\hspace{30pt}4\\left(6\\left(x-2\\right)+76\\right)&=496\\\\[200pt]\n&&&&&\\text{Answer\\quad..............................}\n\\end{flalign*}$\\$\n\\end{minipage}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{flalign*}\n5.\\hspace{30pt}4\\left(6\\left(x-2\\right)+76\\right)&=496\\\\[200pt]\n&&&&&\\text{Answer\\quad..............................}\n\\end{flalign*}$\\$\n\\end{minipage}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{flalign*}\n6.\\hspace{30pt}4\\left(6\\left(x-2\\right)+76\\right)&=496\\\\[200pt]\n&&&&&\\text{Answer\\quad..............................}\n\\end{flalign*}$\\$\n\\end{minipage}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{flalign*}\n7.\\hspace{30pt}4\\left(6\\left(x-2\\right)+76\\right)&=496\\\\[200pt]\n&&&&&\\text{Answer\\quad..............................}\n\\end{flalign*}$\\$\n\\end{minipage}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{flalign*}\n4\\left(6\\le8.\\hspace{30pt}ft(x-2\\right)+76\\right)&=496\\\\[160pt]\n&&&&&\\text{Answer\\quad..............................}\n\\end{flalign*}$\\$\n\\end{minipage}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{flalign*}\n4\\left(6\\le9.\\hspace{30pt}ft(x-2\\right)+76\\right)&=496\\\\[160pt]\n&&&&&\\text{Answer\\quad..............................}\n\\end{flalign*}$\\$\n\\end{minipage}\n\\end{document}"
      end

      it 'generates solution for the practice paper questions sheet' do
        expect(paper[:solutions_sheet]).to eq "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[16pt]{12pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{PP-UP763904-S\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad James Davis}\n\\begin{document}\n\n\\section*{\\centerline{Practice Paper 3 Solutions}}\n\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n1.\\hspace{30pt}5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n2.\\hspace{30pt}5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n3.\\hspace{30pt}5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n4.\\hspace{30pt}5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n5.\\hspace{30pt}5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n6.\\hspace{30pt}5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n7.\\hspace{30pt}5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n5\\frac{1}{28.\\hspace{30pt}}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n5\\frac{1}{29.\\hspace{30pt}}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\end{document}"
      end
    end
  end
end
