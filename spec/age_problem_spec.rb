require './models/age_problem'

describe AgeProblem do
  describe '#initialize/new' do
    let(:age_prob_1){described_class.new(:add,10,5,2,5,0,5,1,[['Jack',:m],['David',:m]])}

    it 'initializes with a time 1 relation' do
      expect(age_prob_1.time_1_rel).to eq :add
    end

    it 'initializes with a time 1 relational value' do
      expect(age_prob_1.time_1_val).to eq 10
    end

    it 'initializes with a time 1 and time 2 difference in time' do
      expect(age_prob_1.time_diff).to eq 5
    end

    it 'initializes with a time 2 relational value' do
      expect(age_prob_1.time_2_val).to eq 2
    end

    it 'initializes with the answer' do
      expect(age_prob_1.answer).to eq 5
    end

    it 'initializes with a time line 1 value' do
      expect(age_prob_1.time_line_1).to eq 0
    end

    it 'initializes with a time line 2 value' do
      expect(age_prob_1.time_line_2).to eq 5
    end

    it 'initializes with a time line 3 value' do
      expect(age_prob_1.time_line_3).to eq 1
    end

    it 'initializes with an array of two persons' do
      expect(age_prob_1.persons).to eq [['Jack',:m],['David',:m]]
    end
  end

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
      expect(question_text).to eq "Sarah is thirty five years older than her daughter. Eight years from now, Sarah will be twice as old as her daughter. How old is her daughter now?"
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

  describe '#add_type_soln' do
    let(:named_persons){[['Adam',:m],['Beth',:f],['John',:m],['Julie',:f],
      ['Ken',:m],['Davina',:f],['Henry',:m],['Sarah',:f]]}
    let(:older_rels){{gen1:[['father',:m,:rel],['mother',:f,:rel]],gen2:
      [['grandfather',:m,:rel],['grandmother',:f,:rel]]}}
    let(:younger_rels){{gen1:[['son',:m,:rel],['daughter',:f,:rel]],gen2:
      [['grandson',:m,:rel],['granddaughter',:f,:rel]]}}
    let(:question){described_class.generate_add_type_question(named_persons,younger_rels,older_rels)}
    let(:solution_latex){question.add_type_soln}

    it 'generates solution latex for add type question eg 1' do
      srand(400)
      expect(solution_latex).to eq "&\\text{Now}&&&&\\text{4 years from now}&\\\\\n&\\text{Sarah}\\hspace{10pt}x&&&&\\text{Sarah}\\hspace{10pt}x+4&\\\\\n&\\text{grandmother}\\hspace{10pt}x + 66&&&&\\text{grandmother}\\hspace{10pt}x + 66 + 4&\\\\\n&&\\text{grandmother} &= \\text{7} \\times \\text{Sarah}&\\\\\n&&x+70&=7\\left(x+4\\right)&\\\\\n&&x+70&=7x+28&\\\\\n&&70-28&=7x-x&\\\\\n&&42&=6x&\\\\\n&&\\frac{42}{6}&=x&\\\\\n&&7&=x&\\\\\n&Answer:&\\text{Sarah now} &= 7"
    end

    it 'generates solution latex for add type question eg 2' do
      srand(410)
      expect(solution_latex).to eq "&\\text{Now}&&&&\\text{3 years from now}&\\\\\n&\\text{Davina}\\hspace{10pt}x&&&&\\text{Davina}\\hspace{10pt}x+3&\\\\\n&\\text{grandfather}\\hspace{10pt}x + 50&&&&\\text{grandfather}\\hspace{10pt}x + 50 + 3&\\\\\n&&\\text{grandfather} &= \\text{3} \\times \\text{Davina}&\\\\\n&&x+53&=3\\left(x+3\\right)&\\\\\n&&x+53&=3x+9&\\\\\n&&53-9&=3x-x&\\\\\n&&44&=2x&\\\\\n&&\\frac{44}{2}&=x&\\\\\n&&22&=x&\\\\\n&Answer:&\\text{Davina now} &= 22"
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

  describe '#mtp_type_soln' do
    let(:named_persons){[['Adam',:m],['Beth',:f],['John',:m],['Julie',:f],
      ['Ken',:m],['Davina',:f],['Henry',:m],['Sarah',:f]]}
    let(:older_rels){{gen1:[['father',:m,:rel],['mother',:f,:rel]],gen2:
      [['grandfather',:m,:rel],['grandmother',:f,:rel]]}}
    let(:younger_rels){{gen1:[['son',:m,:rel],['daughter',:f,:rel]],gen2:
      [['grandson',:m,:rel],['granddaughter',:f,:rel]]}}
    let(:question){described_class.generate_mtp_type_question(named_persons,younger_rels,older_rels)}
    let(:solution_latex){question.mtp_type_soln}

    it 'generates solution latex for mtp type question eg 1' do
      srand(400)
      expect(solution_latex).to eq "&\\text{14 years ago}&&&&\\text{7 years from now}&\\\\\n&\\text{Davina}\\hspace{10pt}x&&&&\\text{Davina}\\hspace{10pt}x+21&\\\\\n&\\text{mother}\\hspace{10pt}3x&&&&\\text{mother}\\hspace{10pt}3x+21&\\\\\n&&\\text{mother} &= \\text{2} \\times \\text{Davina}&\\\\\n&&3x+21&=2\\left(x+21\\right)&\\\\\n&&3x+21&=2x+42&\\\\\n&&3x-2x&=42-21&\\\\\n&&x&=21&\\\\\n&&\\text{Davina now} &= \\text{Davina 14 years ago} + 14\\\\\n&&\\text{Davina now} &= 21 + 14\\\\\n&Answer:&\\text{Davina now} &= 35"
    end

    it 'generates solution latex for mtp type question eg 2' do
      srand(410)
      expect(solution_latex).to eq "&\\text{10 years ago}&&&&\\text{22 years from now}&\\\\\n&\\text{Adam}\\hspace{10pt}x&&&&\\text{Adam}\\hspace{10pt}x+32&\\\\\n&\\text{grandmother}\\hspace{10pt}4x&&&&\\text{grandmother}\\hspace{10pt}4x+32&\\\\\n&&\\text{grandmother} &= \\text{2} \\times \\text{Adam}&\\\\\n&&4x+32&=2\\left(x+32\\right)&\\\\\n&&4x+32&=2x+64&\\\\\n&&4x-2x&=64-32&\\\\\n&&2x&=32&\\\\\n&&x&=\\frac{32}{2}&\\\\\n&&x&=16&\\\\\n&&\\text{Adam now} &= \\text{Adam 10 years ago} + 10\\\\\n&&\\text{Adam now} &= 16 + 10\\\\\n&Answer:&\\text{Adam now} &= 26"
    end
  end

  describe '#self.generate_question/self.latex' do
    it 'generates an add type question/solution latex' do
      srand(300)
      question = described_class.generate_question
      latex = described_class.latex(question)
      expect(latex[:solution_latex]).to eq "Beth is twenty five years older than her daughter. In eleven years time, Beth will be twice as old as her daughter. How old is her daughter now?\n\\begin{align*}\n&\\text{Now}&&&&\\text{11 years from now}&\\\\\n&\\text{daughter}\\hspace{10pt}x&&&&\\text{daughter}\\hspace{10pt}x+11&\\\\\n&\\text{Beth}\\hspace{10pt}x + 25&&&&\\text{Beth}\\hspace{10pt}x + 25 + 11&\\\\\n&&\\text{Beth} &= \\text{2} \\times \\text{daughter}&\\\\\n&&x+36&=2\\left(x+11\\right)&\\\\\n&&x+36&=2x+22&\\\\\n&&36-22&=2x-x&\\\\\n&&14&=x&\\\\\n&Answer:&\\text{daughter now} &= 14\n\\end{align*}\n"
    end

    it 'generates a mtp type question/solution latex' do
      srand(100)
      question = described_class.generate_question
      latex = described_class.latex(question)
      expect(latex[:solution_latex]).to eq "In ten years time, John's grandfather will be seven times as old as John. Twenty two years from now, John's grandfather will be four times as old as John. How old is John now?\n\\begin{align*}\n&\\text{10 years from now}&&&&\\text{22 years from now}&\\\\\n&\\text{John}\\hspace{10pt}x&&&&\\text{John}\\hspace{10pt}x+12&\\\\\n&\\text{grandfather}\\hspace{10pt}7x&&&&\\text{grandfather}\\hspace{10pt}7x+12&\\\\\n&&\\text{grandfather} &= \\text{4} \\times \\text{John}&\\\\\n&&7x+12&=4\\left(x+12\\right)&\\\\\n&&7x+12&=4x+48&\\\\\n&&7x-4x&=48-12&\\\\\n&&3x&=36&\\\\\n&&x&=\\frac{36}{3}&\\\\\n&&x&=12&\\\\\n&&\\text{John now} &= \\text{John 10 years from now} - 10\\\\\n&&\\text{John now} &= 12 - 10\\\\\n&Answer:&\\text{John now} &= 2\n\\end{align*}\n"
    end
  end
end
