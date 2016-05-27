require './models/latex_printer'

describe LatexPrinter do

  describe '#self.worksheet' do
    context 'generate worksheet for fraction class' do
      shared_context 'fraction sheet' do
        before(:all) do
          srand(100)
          @worksheet = LatexPrinter.worksheet(:fraction,21,'Robert Hook',2)
        end
      end

      include_context 'fraction sheet'

      it 'generates fraction questions sheet' do
        expected_questions_sheet = "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[20pt]{14pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{FRA-RQ840962-Q\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad Robert Hook}\n\\begin{document}\n\\section*{\\centerline{Fraction 21}}\n\\noindent\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n1.\\hspace{30pt}9\\frac{3}{5}+12\\frac{1}{2}\n\\end{align*}\n\\end{minipage}\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n2.\\hspace{30pt}5\\frac{1}{2}\\times2\\frac{3}{4}\n\\end{align*}\n\\end{minipage}\n\\end{document}"
        expect(@worksheet[:questions_sheet]).to eq expected_questions_sheet
      end

      it 'generates solution for the fraction questions sheet' do
        expected_solutions_sheet = "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[16pt]{12pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{FRA-RQ840962-S\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad Robert Hook}\n\\begin{document}\n\\section*{\\centerline{Fraction 21 Solutions}}\n\\noindent\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n1.\\hspace{30pt}9\\frac{3}{5}+12\\frac{1}{2}=22\\frac{1}{10}\n\\end{align*}\n\\end{minipage}\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n2.\\hspace{30pt}5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\end{document}"
        expect(@worksheet[:solutions_sheet]).to eq expected_solutions_sheet
      end
    end

    context 'generate worksheet for linear equation class' do
      shared_context 'linear equation sheet' do
        before(:all) do
          srand(100)
          @worksheet = LatexPrinter.worksheet(:linear_equation,5,'Isaac Newton',4)
          @worksheet2 = LatexPrinter.worksheet(:linear_equation,3,'Isaac Newton',8)
        end
      end

      include_context 'linear equation sheet'

      it 'generates linear equation questions sheet' do
        expected_questions_sheet = "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[20pt]{14pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{LEQ-YO107620-Q\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad Isaac Newton}\n\\begin{document}\n\\section*{\\centerline{Linear Equation 5}}\n\\noindent\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n1.\\hspace{30pt}4\\left(6\\left(x-2\\right)+76\\right)&=496\n\\end{align*}\n\\end{minipage}\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n2.\\hspace{30pt}4\\left(2\\left(x+70\\right)-95\\right)&=204\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n3.\\hspace{30pt}5\\left(16-\\frac{x}{3}\\right)-49&=21\n\\end{align*}\n\\end{minipage}\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n4.\\hspace{30pt}5\\left(9x-18\\right)+63&=108\n\\end{align*}\n\\end{minipage}\n\\end{document}"
        expect(@worksheet[:questions_sheet]).to eq expected_questions_sheet
      end

      it 'generates solution for the linear equation questions sheet' do
        expected_solutions_sheet = "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[16pt]{12pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{LEQ-YO107620-S\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad Isaac Newton}\n\\begin{document}\n\\section*{\\centerline{Linear Equation 5 Solutions}}\n\\noindent\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n1.\\hspace{30pt}4\\left(6\\left(x-2\\right)+76\\right)&=496\\\\\n6\\left(x-2\\right)+76&=\\frac{496}{4}\\\\\n6\\left(x-2\\right)+76&=124\\\\\n6\\left(x-2\\right)&=124-76\\\\\n6\\left(x-2\\right)&=48\\\\\nx-2&=\\frac{48}{6}\\\\\nx-2&=8\\\\\nx&=8+2\\\\\nx&=10\n\\end{align*}\n\\end{minipage}\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n2.\\hspace{30pt}4\\left(2\\left(x+70\\right)-95\\right)&=204\\\\\n2\\left(x+70\\right)-95&=\\frac{204}{4}\\\\\n2\\left(x+70\\right)-95&=51\\\\\n2\\left(x+70\\right)&=51+95\\\\\n2\\left(x+70\\right)&=146\\\\\nx+70&=\\frac{146}{2}\\\\\nx+70&=73\\\\\nx&=73-70\\\\\nx&=3\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n3.\\hspace{30pt}5\\left(16-\\frac{x}{3}\\right)-49&=21\\\\\n5\\left(16-\\frac{x}{3}\\right)&=21+49\\\\\n5\\left(16-\\frac{x}{3}\\right)&=70\\\\\n16-\\frac{x}{3}&=\\frac{70}{5}\\\\\n16-\\frac{x}{3}&=14\\\\\n16-14&=\\frac{x}{3}\\\\\n2&=\\frac{x}{3}\\\\\n2\\times3&=x\\\\\n6&=x\n\\end{align*}\n\\end{minipage}\n\\begin{minipage}[t]{0.5000\\textwidth}\n\\begin{align*}\n4.\\hspace{30pt}5\\left(9x-18\\right)+63&=108\\\\\n5\\left(9x-18\\right)&=108-63\\\\\n5\\left(9x-18\\right)&=45\\\\\n9x-18&=\\frac{45}{5}\\\\\n9x-18&=9\\\\\n9x&=9+18\\\\\n9x&=27\\\\\nx&=\\frac{27}{9}\\\\\nx&=3\n\\end{align*}\n\\end{minipage}\n\\end{document}"
        expect(@worksheet[:solutions_sheet]).to eq expected_solutions_sheet
      end
    end

    context 'generate non-standard worksheet for linear equation class' do
      shared_context 'non-standard linear equation sheet' do
        before(:all) do
          srand(100)
          @worksheet = LatexPrinter.worksheet(:linear_equation,5,'Isaac Newton',
            2,{number_of_steps:6,multiple_division:true},{questions_per_row:1})
          @worksheet2 = LatexPrinter.worksheet(:linear_equation,11,'Thomas Eddison',
            4,{number_of_steps:7,multiple_division:true},{questions_per_row:1})
        end
      end

      include_context 'non-standard linear equation sheet'

      it 'generates linear equation questions sheet' do
        expected_questions_sheet = "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[20pt]{14pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{LEQ-HN620825-Q\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad Isaac Newton}\n\\begin{document}\n\\section*{\\centerline{Linear Equation 5}}\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n1.\\hspace{30pt}\\frac{68}{530-4\\left(6\\left(x-2\\right)+76\\right)}&=2\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n2.\\hspace{30pt}57+\\frac{219}{5\\left(\\frac{36}{x}-2\\right)+63}&=60\n\\end{align*}\n\\end{minipage}\n\\end{document}"
        expect(@worksheet[:questions_sheet]).to eq expected_questions_sheet
      end

      it 'generates solution for the non-standard linear equation questions sheet' do
        expected_solutions_sheet = "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[16pt]{12pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{LEQ-HN620825-S\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad Isaac Newton}\n\\begin{document}\n\\section*{\\centerline{Linear Equation 5 Solutions}}\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n1.\\hspace{30pt}\\frac{68}{530-4\\left(6\\left(x-2\\right)+76\\right)}&=2\\\\\n\\frac{68}{2}&=530-4\\left(6\\left(x-2\\right)+76\\right)\\\\\n34&=530-4\\left(6\\left(x-2\\right)+76\\right)\\\\\n4\\left(6\\left(x-2\\right)+76\\right)&=530-34\\\\\n4\\left(6\\left(x-2\\right)+76\\right)&=496\\\\\n6\\left(x-2\\right)+76&=\\frac{496}{4}\\\\\n6\\left(x-2\\right)+76&=124\\\\\n6\\left(x-2\\right)&=124-76\\\\\n6\\left(x-2\\right)&=48\\\\\nx-2&=\\frac{48}{6}\\\\\nx-2&=8\\\\\nx&=8+2\\\\\nx&=10\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n2.\\hspace{30pt}57+\\frac{219}{5\\left(\\frac{36}{x}-2\\right)+63}&=60\\\\\n\\frac{219}{5\\left(\\frac{36}{x}-2\\right)+63}&=60-57\\\\\n\\frac{219}{5\\left(\\frac{36}{x}-2\\right)+63}&=3\\\\\n\\frac{219}{3}&=5\\left(\\frac{36}{x}-2\\right)+63\\\\\n73&=5\\left(\\frac{36}{x}-2\\right)+63\\\\\n73-63&=5\\left(\\frac{36}{x}-2\\right)\\\\\n10&=5\\left(\\frac{36}{x}-2\\right)\\\\\n\\frac{10}{5}&=\\frac{36}{x}-2\\\\\n2&=\\frac{36}{x}-2\\\\\n2+2&=\\frac{36}{x}\\\\\n4&=\\frac{36}{x}\\\\\nx&=\\frac{36}{4}\\\\\nx&=9\n\\end{align*}\n\\end{minipage}\n\\end{document}"
        expect(@worksheet[:solutions_sheet]).to eq expected_solutions_sheet
      end
    end

    context 'generate worksheet for Age Problem class' do
      let(:worksheet){described_class.worksheet(:age_problem,11,'Leonhard Euler',
        4,{},{questions_per_row:1})}
      before(:each) do
        srand(100)
      end

      it 'generates age problem questions sheet' do
        expect(worksheet[:questions_sheet]).to eq "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[20pt]{14pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{AGP-XH029932-Q\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad Leonhard Euler}\n\\begin{document}\n\\section*{\\centerline{Age Problem 11}}\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n\\intertext{1.\\hspace{30pt}Ten years from now, John's grandfather will be seven times as old as John. Twenty two years from now, John's grandfather will be four times as old as John. How old is John now?}\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n\\intertext{2.\\hspace{30pt}Six years from now, Ken will be three times as old as his son. Twenty five years from now, Ken will be twice as old as his son. How old is his son now?}\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n\\intertext{3.\\hspace{30pt}Twelve years from now, Henry's grandmother will be four times as old as Henry. Twenty one years from now, Henry's grandmother will be three times as old as Henry. How old is Henry now?}\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n\\intertext{4.\\hspace{30pt}One year ago, Ken was seven times as old as his niece. In two years time, Ken will be five times as old as his niece. How old is his niece now?}\n\\end{align*}\n\\end{minipage}\n\\end{document}"
      end

      it 'generates age problem solutions sheet'  do
        expect(worksheet[:solutions_sheet]).to eq "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[16pt]{12pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{AGP-XH029932-S\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad Leonhard Euler}\n\\begin{document}\n\\section*{\\centerline{Age Problem 11 Solutions}}\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n\\intertext{1.\\hspace{30pt}Ten years from now, John's grandfather will be seven times as old as John. Twenty two years from now, John's grandfather will be four times as old as John. How old is John now?}&\\text{10 years from now}&&&&\\text{22 years from now}&\\\\\n&\\text{John}\\hspace{10pt}x&&&&\\text{John}\\hspace{10pt}x+12&\\\\\n&\\text{grandfather}\\hspace{10pt}7x&&&&\\text{grandfather}\\hspace{10pt}7x+12&\\\\\n&&\\text{grandfather} &= \\text{4} \\times \\text{John}&\\\\\n&&7x+12&=4\\left(x+12\\right)&\\\\\n&&7x+12&=4x+48&\\\\\n&&7x-4x&=48-12&\\\\\n&&3x&=36&\\\\\n&&x&=\\frac{36}{3}&\\\\\n&&x&=12&\\\\\n&&\\text{John now} &= \\text{John 10 years from now} - 10\\\\\n&&\\text{John now} &= 12 - 10\\\\\n&Answer:&\\text{John now} &= 2\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n\\intertext{2.\\hspace{30pt}Six years from now, Ken will be three times as old as his son. Twenty five years from now, Ken will be twice as old as his son. How old is his son now?}&\\text{6 years from now}&&&&\\text{25 years from now}&\\\\\n&\\text{son}\\hspace{10pt}x&&&&\\text{son}\\hspace{10pt}x+19&\\\\\n&\\text{Ken}\\hspace{10pt}3x&&&&\\text{Ken}\\hspace{10pt}3x+19&\\\\\n&&\\text{Ken} &= \\text{2} \\times \\text{son}&\\\\\n&&3x+19&=2\\left(x+19\\right)&\\\\\n&&3x+19&=2x+38&\\\\\n&&3x-2x&=38-19&\\\\\n&&x&=19&\\\\\n&&\\text{son now} &= \\text{son 6 years from now} - 6\\\\\n&&\\text{son now} &= 19 - 6\\\\\n&Answer:&\\text{son now} &= 13\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n\\intertext{3.\\hspace{30pt}Twelve years from now, Henry's grandmother will be four times as old as Henry. Twenty one years from now, Henry's grandmother will be three times as old as Henry. How old is Henry now?}&\\text{12 years from now}&&&&\\text{21 years from now}&\\\\\n&\\text{Henry}\\hspace{10pt}x&&&&\\text{Henry}\\hspace{10pt}x+9&\\\\\n&\\text{grandmother}\\hspace{10pt}4x&&&&\\text{grandmother}\\hspace{10pt}4x+9&\\\\\n&&\\text{grandmother} &= \\text{3} \\times \\text{Henry}&\\\\\n&&4x+9&=3\\left(x+9\\right)&\\\\\n&&4x+9&=3x+27&\\\\\n&&4x-3x&=27-9&\\\\\n&&x&=18&\\\\\n&&\\text{Henry now} &= \\text{Henry 12 years from now} - 12\\\\\n&&\\text{Henry now} &= 18 - 12\\\\\n&Answer:&\\text{Henry now} &= 6\n\\end{align*}\n\\end{minipage}\n\\vspace{10 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n\\intertext{4.\\hspace{30pt}One year ago, Ken was seven times as old as his niece. In two years time, Ken will be five times as old as his niece. How old is his niece now?}&\\text{1 year ago}&&&&\\text{2 years from now}&\\\\\n&\\text{niece}\\hspace{10pt}x&&&&\\text{niece}\\hspace{10pt}x+3&\\\\\n&\\text{Ken}\\hspace{10pt}7x&&&&\\text{Ken}\\hspace{10pt}7x+3&\\\\\n&&\\text{Ken} &= \\text{5} \\times \\text{niece}&\\\\\n&&7x+3&=5\\left(x+3\\right)&\\\\\n&&7x+3&=5x+15&\\\\\n&&7x-5x&=15-3&\\\\\n&&2x&=12&\\\\\n&&x&=\\frac{12}{2}&\\\\\n&&x&=6&\\\\\n&&\\text{niece now} &= \\text{niece 1 year ago} + 1\\\\\n&&\\text{niece now} &= 6 + 1\\\\\n&Answer:&\\text{niece now} &= 7\n\\end{align*}\n\\end{minipage}\n\\end{document}"
      end
    end

  end
  #
  # describe '#self.paper' do
  #   context 'generate practice paper with questions from fractions and linear equations' do
  #     shared_context 'practice paper 1' do
  #       before(:all) do
  #         srand(100)
  #         @contents = [{topic: :fraction,number_of_questions:3,work_space:100},
  #           {topic: :linear_equation},
  #           {topic: :fraction},
  #           {topic: :linear_equation,number_of_questions:2}
  #         ]
  #         @paper = LatexPrinter.paper(@contents,3,'James Davis')
  #         @contents2 = [{topic: :fraction,number_of_questions:3,work_space:100},
  #           {topic: :linear_equation,number_of_questions:1},
  #           {topic: :fraction},
  #           {topic: :linear_equation,number_of_questions:2},
  #           {topic: :linear_equation,number_of_questions:1},
  #           {topic: :fraction}
  #         ]
  #         @paper2 = LatexPrinter.paper(@contents2,3,'James Davis')
  #       end
  #     end
  #
  #     include_context 'practice paper 1'
  #
  #     it 'generates practice paper questions sheet' do
  #       expected_questions_sheet = "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[20pt]{14pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{PP-VE283509-Q\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad James Davis}\n\\begin{document}\n\\section*{\\centerline{Practice Paper 3}}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{flalign*}\n1.\\hspace{30pt}9\\frac{3}{5}+12\\frac{1}{2}\\\\[100pt]\n&&&&&\\text{Answer\\quad..............................}\n\\end{flalign*}\n\\end{minipage}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{flalign*}\n2.\\hspace{30pt}5\\frac{1}{2}\\times2\\frac{3}{4}\\\\[100pt]\n&&&&&\\text{Answer\\quad..............................}\n\\end{flalign*}\n\\end{minipage}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{flalign*}\n3.\\hspace{30pt}\\frac{7}{11}-\\frac{1}{2}\\\\[100pt]\n&&&&&\\text{Answer\\quad..............................}\n\\end{flalign*}\n\\end{minipage}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{flalign*}\n4.\\hspace{30pt}69+\\frac{6x-15}{3}&=72\\\\[200pt]\n&&&&&\\text{Answer\\quad..............................}\n\\end{flalign*}\n\\end{minipage}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{flalign*}\n5.\\hspace{30pt}7\\frac{2}{3}\\div7\\frac{1}{9}\\\\[200pt]\n&&&&&\\text{Answer\\quad..............................}\n\\end{flalign*}\n\\end{minipage}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{flalign*}\n6.\\hspace{30pt}10\\left(\\frac{20}{x}+63\\right)+40&=720\\\\[200pt]\n&&&&&\\text{Answer\\quad..............................}\n\\end{flalign*}\n\\end{minipage}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{flalign*}\n7.\\hspace{30pt}\\frac{1800}{7\\left(66+x\\right)+82}&=3\\\\[200pt]\n&&&&&\\text{Answer\\quad..............................}\n\\end{flalign*}\n\\end{minipage}\n\\end{document}"
  #       expect(@paper[:questions_sheet]).to eq expected_questions_sheet
  #     end
  #
  #     it 'generates solution for the practice paper questions sheet' do
  #
  #       expected_solutions_sheet = "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[16pt]{12pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{PP-VE283509-S\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad James Davis}\n\\begin{document}\n\\section*{\\centerline{Practice Paper 3 Solutions}}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n1.\\hspace{30pt}9\\frac{3}{5}+12\\frac{1}{2}=22\\frac{1}{10}\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n2.\\hspace{30pt}5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n3.\\hspace{30pt}\\frac{7}{11}-\\frac{1}{2}=\\frac{3}{22}\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n4.\\hspace{30pt}69+\\frac{6x-15}{3}&=72\\\\\n\\frac{6x-15}{3}&=72-69\\\\\n\\frac{6x-15}{3}&=3\\\\\n6x-15&=3\\times3\\\\\n6x-15&=9\\\\\n6x&=9+15\\\\\n6x&=24\\\\\nx&=\\frac{24}{6}\\\\\nx&=4\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n5.\\hspace{30pt}7\\frac{2}{3}\\div7\\frac{1}{9}=1\\frac{5}{64}\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n6.\\hspace{30pt}10\\left(\\frac{20}{x}+63\\right)+40&=720\\\\\n10\\left(\\frac{20}{x}+63\\right)&=720-40\\\\\n10\\left(\\frac{20}{x}+63\\right)&=680\\\\\n\\frac{20}{x}+63&=\\frac{680}{10}\\\\\n\\frac{20}{x}+63&=68\\\\\n\\frac{20}{x}&=68-63\\\\\n\\frac{20}{x}&=5\\\\\n\\frac{20}{5}&=x\\\\\n4&=x\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n7.\\hspace{30pt}\\frac{1800}{7\\left(66+x\\right)+82}&=3\\\\\n\\frac{1800}{3}&=7\\left(66+x\\right)+82\\\\\n600&=7\\left(66+x\\right)+82\\\\\n600-82&=7\\left(66+x\\right)\\\\\n518&=7\\left(66+x\\right)\\\\\n\\frac{518}{7}&=66+x\\\\\n74&=66+x\\\\\n74-66&=x\\\\\n8&=x\n\\end{align*}\n\\end{minipage}\n\\end{document}"
  #       # puts @paper2[:solutions_sheet]
  #       # puts @paper2[:questions_sheet]
  #       expect(@paper[:solutions_sheet]).to eq expected_solutions_sheet
  #     end
  #   end
  #
  # end

end
