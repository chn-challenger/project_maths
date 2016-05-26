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

  describe '#generate_add_type_question' do
    let(:named_persons){[['Adam',:m],['Beth',:f],['John',:m],['Julie',:f],
      ['Ken',:m],['Davina',:f],['Henry',:m],['Sarah',:f]]}
    let(:older_rels){{gen1:[['father',:m,:rel],['mother',:f,:rel]],gen2:
      [['grandfather',:m,:rel],['grandmother',:f,:rel]]}}
    let(:younger_rels){{gen1:[['son',:m,:rel],['daughter',:f,:rel]],gen2:
      [['grandson',:m,:rel],['granddaughter',:f,:rel]]}}
    let(:question){described_class.generate_add_type_question(named_persons,younger_rels,older_rels)}


    it 'generate add type questions that are consistent eg 1' do
      srand(100)
      lhs = question.time_2_val * (question.answer + question.time_diff)
      rhs = question.answer + question.time_1_val + question.time_diff
      expect(lhs).to eq rhs
    end

    it 'generate add type questions that are consistent eg 2' do
      srand(110)
      lhs = question.time_2_val * (question.answer + question.time_diff)
      rhs = question.answer + question.time_1_val + question.time_diff
      expect(lhs).to eq rhs
    end

    it 'generate add type questions that are consistent eg 3' do
      srand(120)
      lhs = question.time_2_val * (question.answer + question.time_diff)
      rhs = question.answer + question.time_1_val + question.time_diff
      expect(lhs).to eq rhs
    end

    it 'generate add type questions that are consistent eg 4' do
      srand(130)
      lhs = question.time_2_val * (question.answer + question.time_diff)
      rhs = question.answer + question.time_1_val + question.time_diff
      expect(lhs).to eq rhs
    end

    it 'generate add type questions that are consistent eg 4' do
      srand(140)
      lhs = question.time_2_val * (question.answer + question.time_diff)
      rhs = question.answer + question.time_1_val + question.time_diff
      expect(lhs).to eq rhs
    end

    context 'generates an add type question' do
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

  describe '#generate_add_question_text' do
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

    it 'generates question text for add type question eg 2' do
      srand(400)
      expect(question_text).to eq "Sarah is sixty six years younger than her grandmother. Four years from now, her grandmother will be seven times as old as her. How old is Sarah now?"
    end

    it 'generates question text for add type question eg 3' do
      srand(500)
      expect(question_text).to eq "Sarah's mother is twenty one years older than Sarah. Two years from now, Sarah's mother will be eight times as old as Sarah. How old is Sarah now?"
    end

    it 'generates question text for add type question eg 4' do
      srand(600)
      expect(question_text).to eq "Sarah is seventy two years younger than her grandfather. Four years from now, her grandfather will be nine times as old as her. How old is Sarah now?"
    end

    it 'generates question text for add type question eg 5' do
      srand(700)
      expect(question_text).to eq "Davina is eleven years younger than Julie. Two years from now, Julie will be twice as old as Davina. How old is Davina now?"
    end
  end

  describe '#generate_mtp_type_question' do
    let(:named_persons){[['Adam',:m],['Beth',:f],['John',:m],['Julie',:f],
      ['Ken',:m],['Davina',:f],['Henry',:m],['Sarah',:f]]}
    let(:older_rels){{gen1:[['father',:m,:rel],['mother',:f,:rel]],gen2:
      [['grandfather',:m,:rel],['grandmother',:f,:rel]]}}
    let(:younger_rels){{gen1:[['son',:m,:rel],['daughter',:f,:rel]],gen2:
      [['grandson',:m,:rel],['granddaughter',:f,:rel]]}}
    let(:question){described_class.generate_mtp_type_question(named_persons,younger_rels,older_rels)}

    it 'generate mtp type questions that are consistent eg 1' do
      srand(100)
      lhs = question.time_2_val * (question.answer + question.time_diff)
      rhs = question.time_1_val * question.answer + question.time_diff
      expect(lhs).to eq rhs
    end

    it 'generate mtp type questions that are consistent eg 2' do
      srand(110)
      lhs = question.time_2_val * (question.answer + question.time_diff)
      rhs = question.time_1_val * question.answer + question.time_diff
      expect(lhs).to eq rhs
    end

    it 'generate mtp type questions that are consistent eg 3' do
      srand(120)
      lhs = question.time_2_val * (question.answer + question.time_diff)
      rhs = question.time_1_val * question.answer + question.time_diff
      expect(lhs).to eq rhs
    end

    it 'generate mtp type questions that are consistent eg 4' do
      srand(130)
      lhs = question.time_2_val * (question.answer + question.time_diff)
      rhs = question.time_1_val * question.answer + question.time_diff
      expect(lhs).to eq rhs
    end

    context 'generates a mtp type question' do
      before(:each) do
        srand(100)
      end

      it 'with a time 1 relation' do
        expect(question.time_1_rel).to eq :mtp
      end

      it 'with a time 1 value' do
        expect(question.time_1_val).to eq 3
      end

      it 'with a time 1 time 2 difference' do
        expect(question.time_diff).to eq 10
      end

      it 'with a time 2 value' do
        expect(question.time_2_val).to eq 2
      end

      it 'with a answer' do
        expect(question.answer).to eq 10
      end

      it 'with a time line 1' do
        expect(question.time_line_1).to eq 1
      end

      it 'with a time line 2' do
        expect(question.time_line_2).to eq 11
      end

      it 'with a time line 3' do
        expect(question.time_line_3).to eq 0
      end

      it 'with two people' do
        expect(question.persons).to eq [["Henry",:m],["father",:m,:rel]]
      end
    end
  end

  describe '#generate_mtp_question_text' do
    let(:named_persons){[['Adam',:m],['Beth',:f],['John',:m],['Julie',:f],
      ['Ken',:m],['Davina',:f],['Henry',:m],['Sarah',:f]]}
    let(:older_rels){{gen1:[['father',:m,:rel],['mother',:f,:rel]],gen2:
      [['grandfather',:m,:rel],['grandmother',:f,:rel]]}}
    let(:younger_rels){{gen1:[['son',:m,:rel],['daughter',:f,:rel]],gen2:
      [['grandson',:m,:rel],['granddaughter',:f,:rel]]}}
    let(:question){described_class.generate_mtp_type_question(named_persons,younger_rels,older_rels)}
    let(:question_text){question.generate_mtp_question_text}

    it 'generates question text for mtp type question eg 1' do
      srand(300)
      expect(question_text).to eq "Three years from now, John's mother will be three times as old as John. Twenty two years from now, John's mother will be twice as old as John. How old is John now?"
    end

    it 'generates question text for mtp type question eg 2' do
      srand(400)
      expect(question_text).to eq "Fourteen years ago, Davina's mother was three times as old as Davina. Seven years from now, Davina's mother will be twice as old as Davina. How old is Davina now?"
    end

    it 'generates question text for mtp type question eg 3' do
      srand(500)
      expect(question_text).to eq "Eleven years ago, Sarah was three times as old as her daughter. Eight years from now, Sarah will be twice as old as her daughter. How old is her daughter now?"
    end

    it 'generates question text for mtp type question eg 4' do
      srand(600)
      expect(question_text).to eq "In five years time, Julie will be nine times as old as her grandson. In eleven years time, Julie will be five times as old as her grandson. How old is her grandson now?"
    end

    it 'generates question text for mtp type question eg 5' do
      srand(700)
      expect(question_text).to eq "Seventeen years ago, Henry was three times as old as his granddaughter. In eight years time, Henry will be twice as old as his granddaughter. How old is his granddaughter now?"
    end
  end


  describe '#generate_mtp_question_text' do
    let(:named_persons){[['Adam',:m],['Beth',:f],['John',:m],['Julie',:f],
      ['Ken',:m],['Davina',:f],['Henry',:m],['Sarah',:f]]}
    let(:older_rels){{gen1:[['father',:m,:rel],['mother',:f,:rel]],gen2:
      [['grandfather',:m,:rel],['grandmother',:f,:rel]]}}
    let(:younger_rels){{gen1:[['son',:m,:rel],['daughter',:f,:rel]],gen2:
      [['grandson',:m,:rel],['granddaughter',:f,:rel]]}}
    let(:question){described_class.generate_mtp_type_question(named_persons,younger_rels,older_rels)}
    let(:solution_text){question.mtp_type_soln_part_1}
    let(:soln_eqns){question.solve_eqn}

    it 'generates question text for mtp type question eg 1' do
      srand(300)
      # puts solution_text
      puts AgeProblem._solution_latex(soln_eqns)
      # expect(solution_text).to eq "Three years from now, John's mother will be three times as old as John. Twenty two years from now, John's mother will be twice as old as John. How old is John now?"
    end
  end



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
