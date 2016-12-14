require './models/latex_printer'

describe LatexPrinter do
  describe '#create' do
    context 'generate worksheet for Age Problem class' do
      # let(:worksheet){described_class.worksheet(:age_problem,11,'Leonhard Euler',
      #   4,{},{questions_per_row:1})}
      #
      # let(:worksheet2){described_class.worksheet(:age_problem,3,'Any',
      #   4,{},{questions_per_row:1})}
      # let(:worksheet2){described_class.worksheet(:fraction,6,'Any',12)}
      # let(:worksheet2){described_class.worksheet(:linear_equation,3,
        # 'Any',3,{number_of_steps:7,multiple_division:true,continued_fraction:true,solution_max:-10,solution_min:-15},
        # {questions_per_row:1})}

      it 'generates age problem questions sheet' do
        srand(213)
        # puts worksheet2[:questions_sheet]
        # puts worksheet2[:solutions_sheet]
        LatexPrinter.create_worksheet(:linear_equation,1,'Wang Shuo',20,{number_of_steps:5,solution_max:15,solution_min:4},{questions_per_row:2})
        srand(1)
        LatexPrinter.create_worksheet(:linear_equation,2,'Wang Shuo',20,{number_of_steps:7,multiple_division:true,continued_fraction:true,solution_max:15,solution_min:4},{questions_per_row:2})
        # expect(worksheet[:questions_sheet]).to eq "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[20pt]{14pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{AGP-XH029932-Q\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad Leonhard Euler}\n\\begin{document}\n\\section*{\\centerline{Age Problem 11}}\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n\\intertext{1.\\hspace{30pt}Ten years from now, John's grandfather will be seven times as old as John. Twenty two years from now, John's grandfather will be four times as old as John. How old is John now?}\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n\\intertext{2.\\hspace{30pt}Six years from now, Ken will be three times as old as his son. Twenty five years from now, Ken will be twice as old as his son. How old is his son now?}\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n\\intertext{3.\\hspace{30pt}Twelve years from now, Henry's grandmother will be four times as old as Henry. Twenty one years from now, Henry's grandmother will be three times as old as Henry. How old is Henry now?}\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n\\intertext{4.\\hspace{30pt}One year ago, Ken was seven times as old as his niece. In two years time, Ken will be five times as old as his niece. How old is his niece now?}\n\\end{align*}\n\\end{minipage}\n\\end{document}"
      end

    end

  end
end
