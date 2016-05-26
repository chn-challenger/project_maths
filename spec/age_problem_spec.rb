require './models/age_problem'

describe AgeProblem do
  # describe '#initialize/new' do
  #   let(:age_prob_1){described_class.new(:add,10,5,2)}
  #   let(:age_prob_2){described_class.new(:mtp,3,10,2)}
  #
  #   it 'initializes with a time 1 relation' do
  #     expect(age_prob_1.time_1_rel).to eq :add
  #   end
  #
  #   it 'initializes with a time 1 relational value' do
  #     expect(age_prob_1.time_1_val).to eq 10
  #   end
  #
  #   it 'initializes with a time 1 and time 2 difference in time' do
  #     expect(age_prob_1.time_diff).to eq 5
  #   end
  #
  #   it 'initializes with a time 2 relational value' do
  #     expect(age_prob_1.time_2_val).to eq 2
  #   end
  #
  #   it 'initializes with an initial equation with time 1 relation is add' do
  #     left_side = Expression.new([Step.new(nil,'x'),Step.new(:add,15)])
  #     right_side = Expression.new([Step.new(nil,'x'),Step.new(:add,5),Step.new(:mtp,2,:lft)])
  #     expected_equation = Equation.new(left_side,right_side)
  #     expect(age_prob_1.equation).to eq expected_equation
  #   end
  #
  #   it 'initializes with an initial equation with time 1 relation is multiply' do
  #     left_side = Expression.new([Step.new(nil,'x'),Step.new(:mtp,3,:lft),Step.new(:add,10)])
  #     right_side = Expression.new([Step.new(nil,'x'),Step.new(:add,10),Step.new(:mtp,2,:lft)])
  #     expected_equation = Equation.new(left_side,right_side)
  #     # puts age_prob_2.equation.latex
  #     expect(age_prob_2.equation).to eq expected_equation
  #   end
  # end

  describe '#generate_add_question_text/generate_add_question' do
    let(:named_persons){[['Adam',:m],['Beth',:f],['John',:m],['Julie',:f],
      ['Ken',:m],['Davina',:f],['Henry',:m],['Sarah',:f]]}
    let(:older_rels){{gen1:[['father',:m,:rel],['mother',:f,:rel]],gen2:
      [['grandfather',:m,:rel],['grandmother',:f,:rel]]}}
    let(:younger_rels){{gen1:[['son',:m,:rel],['daughter',:f,:rel]],gen2:
      [['grandson',:m,:rel],['granddaughter',:f,:rel]]}}
    let(:question){described_class.generate_add_type_question(named_persons,younger_rels,older_rels)}
    context 'generates add type question' do
      before(:each) do
        srand(200)
      end

      it 'with a time 1 relation' do
        expect(question.time_1_rel).to eq :add
      end

      it 'with a time 1 value' do
        expect(question.time_1_val).to eq 30
      end

      it 'with a time 1 time 2 difference' do
        expect(question.time_diff).to eq 1
      end

      it 'with a time 2 value' do
        expect(question.time_2_val).to eq 3
      end

      it 'with a answer' do
        expect(question.answer).to eq 14
      end

      it 'with a time line 1' do
        expect(question.time_line_1).to eq 0
      end

      it 'with a time line 2' do
        expect(question.time_line_2).to eq 1
      end

      it 'with a time line 3' do
        expect(question.time_line_3).to eq 0
      end

      it 'with two people' do
        expect(question.persons).to eq [["Ken",:m],["mother",:f,:rel]]
      end
    end
  end

  describe '#generate_add_question_text/generate_add_question' do
    let(:named_persons){[['Adam',:m],['Beth',:f],['John',:m],['Julie',:f],
      ['Ken',:m],['Davina',:f],['Henry',:m],['Sarah',:f]]}
    let(:older_rels){{gen1:[['father',:m,:rel],['mother',:f,:rel]],gen2:
      [['grandfather',:m,:rel],['grandmother',:f,:rel]]}}
    let(:younger_rels){{gen1:[['son',:m,:rel],['daughter',:f,:rel]],gen2:
      [['grandson',:m,:rel],['granddaughter',:f,:rel]]}}
    let(:question){described_class.generate_add_type_question(named_persons,younger_rels,older_rels)}
    let(:question_text){question.generate_add_question_text}

    it 'generates question text for add type question eg 1' do
      srand(300)
      expect(question_text).to eq "Beth is twenty five years older than her daughter. In eleven years time, Beth will be twice as old as her daughter. How old is her daughter now?"
    end

    it 'generates question text for add type question eg 1' do
      srand(400)
      expect(question_text).to eq "Sarah is sixty six years younger than her grandmother. Four years from now, her grandmother will be seven times as old as her. How old is Sarah now?"
    end

    it 'generates question text for add type question eg 1' do
      srand(500)
      expect(question_text).to eq "Sarah's mother is twenty one years older than Sarah. Two years from now, Sarah's mother will be eight times as old as Sarah. How old is Sarah now?"
    end

    it 'generates question text for add type question eg 1' do
      srand(600)
      expect(question_text).to eq "Sarah is seventy two years younger than her grandfather. Four years from now, her grandfather will be nine times as old as her. How old is Sarah now?"
    end

    it 'generates question text for add type question eg 1' do
      srand(700)
      expect(question_text).to eq "Davina is eleven years younger than Julie. Two years from now, Julie will be twice as old as Davina. How old is Davina now?"
    end
  end

  describe '#generate_add_question_text/generate_add_question' do
    let(:named_persons){[['Adam',:m],['Beth',:f],['John',:m],['Julie',:f],
      ['Ken',:m],['Davina',:f],['Henry',:m],['Sarah',:f]]}
    let(:older_rels){{gen1:[['father',:m,:rel],['mother',:f,:rel]],gen2:
      [['grandfather',:m,:rel],['grandmother',:f,:rel]]}}
    let(:younger_rels){{gen1:[['son',:m,:rel],['daughter',:f,:rel]],gen2:
      [['grandson',:m,:rel],['granddaughter',:f,:rel]]}}
    let(:question){described_class.generate_mtp_type_question(named_persons,younger_rels,older_rels)}
    context 'generates add type question' do
      before(:each) do
        srand(200)
      end

      it 'with a time 1 relation' do
        p question
        # expect(question.time_1_rel).to eq :mtp
      end

      # it 'with a time 1 value' do
      #   expect(question.time_1_val).to eq 30
      # end
      #
      # it 'with a time 1 time 2 difference' do
      #   expect(question.time_diff).to eq 1
      # end
      #
      # it 'with a time 2 value' do
      #   expect(question.time_2_val).to eq 3
      # end
      #
      # it 'with a answer' do
      #   expect(question.answer).to eq 14
      # end
      #
      # it 'with a time line 1' do
      #   expect(question.time_line_1).to eq 0
      # end
      #
      # it 'with a time line 2' do
      #   expect(question.time_line_2).to eq 1
      # end
      #
      # it 'with a time line 3' do
      #   expect(question.time_line_3).to eq 0
      # end
      #
      # it 'with two people' do
      #   expect(question.persons).to eq [["Ken",:m],["mother",:f,:rel]]
      # end
    end
  end


  #
  # describe '#generate_mtp_question_text/generate_mtp_question' do
  #   let(:people){[['Adam',:m],['Beth',:f],['John',:m],['Julie',:f],['Ken',:m],
  #     ['Davina',:f],['Henry',:m],['Sarah',:f]]}
  #   let(:question){described_class.generate_mtp_type_question}
  #   let(:question_text){question.generate_mtp_question_text(people)}
  #
  #   it 'generates a mtp question eg 1' do
  #     srand(100)
  #     expected_text = "One year from now, Henry's father will be three times as old as Henry. In eleven years time, Henry's father will be twice as old as Henry. How old is Henry now?"
  #     expect(question_text).to eq expected_text
  #   end
  #
  #   it 'generates a mtp question eg 2' do
  #     srand(200)
  #     expected_text = "Five years ago, Sarah was five times as old as his grandson. One year from now, Sarah will be four times as old as his grandson. How old is his grandson now?"
  #     expect(question_text).to eq expected_text
  #   end
  #
  #   it 'generates a mtp question eg 3' do
  #     srand(300)
  #     expected_text = "Three years from now, John's mother will be three times as old as John. Twenty two years from now, John's mother will be twice as old as John. How old is John now?"
  #     expect(question_text).to eq expected_text
  #   end
  #
  #   it 'generates a mtp question eg 4' do
  #     srand(400)
  #     expected_text = "Fourteen years ago, Davina's mother was three times as old as Davina. Seven years from now, Davina's mother will be twice as old as Davina. How old is Davina now?"
  #     expect(question_text).to eq expected_text
  #   end
  # end







  describe '#solution/solution_latex' do
    # let(:age_prob_1){described_class.new(:add,20,5,3)}
    # let(:age_prob_2){described_class.new(:mtp,4,10,2)}
    let(:people){[['Adam',:m],['Beth',:f],['John',:m],['Julie',:f],['Ken',:m],
      ['Davina',:f],['Henry',:m],['Sarah',:f]]}


    it 'generates solution to the first example' do

      # srand(123)
      #
      # problem = AgeProblem.generate_mtp_type_question
      #
      # text = problem.generate_mtp_question_text(people)
      # p text
      # p problem
      #
    end

    # it 'generates solution to the second example' do
    #   latex = AgeProblem._solution_latex(age_prob_2.solution)
    #   puts latex
    #   expected_latex = "x3+10&=2\\left(x+10\\right)\\\\\n3x+10&=2x+20\\\\\n10&=2x+20-3x\\\\\n10&=-1x+20\\\\\n-1x+20&=10\\\\\n-1x&=10-20\\\\\n-1x&=-10"
    #   expect(latex).to eq expected_latex
    # end

#     &\text{Two years ago}&&&&\text{Three years from now}\\
# &\text{Son}\hspace{10pt}x&&&&\text{Son}\hspace{10pt}x+5\\
# &\text{John}\hspace{10pt}5x&&&&\text{John}\hspace{10pt}5x+5\\
# 		&&\text{John} &= \text{three} \times \text{Son}\\
# 		&&5x + 5 &= 3\left(x+5\right)\\
# 		&&x&= 5\\
# &x = 5 = \text{age of John's son two}\\
# &x + 2 = 5 + 2 = 7 =  \text{age of J}\\
# &\text{John's son is now 7 years old.}


#better model solution

# \begin{minipage}[t]{1.0000\textwidth}
# 	\color{blue}
# 		\begin{align*}
# &\text{Two years ago}&            	&&			 		 &\text{Three years from now}&\\
# &\text{Son}\hspace{10pt}x&		&&					&\text{Son}\hspace{10pt}x+5&\\
# &\text{John}\hspace{10pt}5x& &&			 		 &\text{John}\hspace{10pt}5x+5&\\
# 		&&       \text{John} &= \text{three} \times \text{Son}&\\
# 		&&             5x + 5 &= 3\left(x+5\right)&\\
# 		&&                       x&= 5&\\
# &&  \text{son now} &= \text{son 2 years ago} + 2 \\
# &&\text{son now} &= 5 + 2\\
# &Answer:&\text{age of son now} &= 7
# 		\end{align*}
# 	\end{minipage}


  end



end

    # describe '#solution/solution_latex' do
    #   let(:age_prob_1){described_class.new(:add,10,5,2)}
    #   let(:age_prob_2){described_class.new(:mtp,3,10,2)}
    #
    #   it 'generates solution to the first example' do
    #     puts age_prob_1.equation.latex
        # latex = AgeProblem._solution_latex(age_prob_1.solution)
        # expected_latex = "x+15&=2\\left(x+5\\right)\\\\\nx+15&=2x+10\\\\\n15&=2x+10-x\\\\\n15&=x+10\\\\\nx+10&=15\\\\\nx&=15-10\\\\\nx&=5"
        # expect(latex).to eq expected_latex
      # end
      #
      # it 'generates solution to the second example' do
      #   latex = AgeProblem._solution_latex(age_prob_2.solution)
      #   puts latex
      #   expected_latex = "x3+10&=2\\left(x+10\\right)\\\\\n3x+10&=2x+20\\\\\n10&=2x+20-3x\\\\\n10&=-1x+20\\\\\n-1x+20&=10\\\\\n-1x&=10-20\\\\\n-1x&=-10"
      #   expect(latex).to eq expected_latex
      # end

    # end


  # end


  #
  # describe '#simplify' do
  #   let(:fraction1){described_class.new(3,6,8)}
  #   let(:fraction2){described_class.new(4,12,8)}
  #
  #   context 'make fraction parts into lowest form' do
  #     it 'has new simplified numerator' do
  #       fraction1.simplify
  #       expect(fraction1.numerator).to eq 3
  #     end
  #     it 'has new simplified denominator' do
  #       fraction1.simplify
  #       expect(fraction1.denominator).to eq 4
  #     end
  #   end
  #
  #   context 'make fraction part of a mixed fraction not top-heavy' do
  #     it 'has a new integer part' do
  #       fraction2.simplify
  #       expect(fraction2.integer).to eq 5
  #     end
  #
  #     it 'has a new numerator' do
  #       fraction2.simplify
  #       expect(fraction2.numerator).to eq 1
  #     end
  #
  #     it 'has a new denominator' do
  #       fraction2.simplify
  #       expect(fraction2.denominator).to eq 2
  #     end
  #
  #     it 'is not top-heavy' do
  #       fraction2.simplify
  #       expect(fraction2.numerator <= fraction2.denominator).to eq true
  #     end
  #   end
  # end

# end





#
# it 'generates a type 2 add question' do
#   srand(111)
#   expected_text = "John is twenty three years younger than his father. Ten years from now, his father will be twice as old as him. How old is John now?"
#   expect(question_text).to eq expected_text
# end
#
# it 'generates a type 3 add question' do
#   srand(141)
#   expected_text = "Julie is twenty nine years younger than her father. Eight years from now, her father will be twice as old as her. How old is Julie now?"
#   expect(question_text).to eq expected_text
# end
#
# it 'generates a type 4 add question' do
#   srand(117)
#   expected_text = "Davina's daughter is twenty three years younger than Davina. In two years time, Davina will be twice as old as her daughter. How old is Davina's daughter now?"
#   expect(question_text).to eq expected_text
# end
#
# it 'generates a type 5 add question' do
#   srand(101)
#   expected_text = "Sarah is fifteen years older than Davina. Three years from now, Sarah will be four times as old as Davina. How old is Davina now?"
#   expect(question_text).to eq expected_text
# end
#
# it 'generates a type 6 add question' do
#   srand(1337)
#   expected_text = "Adam is twenty seven years older than his daughter. In five years time, Adam will be four times as old as his daughter. How old is his daughter now?"
#   expect(question_text).to eq expected_text
# end
#
# it 'generates a type 7 add question' do
#   srand(52220)
#   expected_text = "Davina is sixty six years older than her granddaughter. Thirteen years from now, Davina will be four times as old as her granddaughter. How old is her granddaughter now?"
#   expect(question_text).to eq expected_text
# end
#
# it 'generates a type 8 add question' do
#   srand(115)
#   expected_text = "John's father is twenty two years older than John. In sixteen years time, John's father will be twice as old as John. How old is John now?"
#   expect(question_text).to eq expected_text
# end
#
# it 'generates a type 9 add question' do
#   srand(120)
#   expected_text = "Henry's son is forty three years younger than Henry. One year from now, Henry will be twice as old as his son. How old is Henry's son now?"
#   expect(question_text).to eq expected_text
# end
