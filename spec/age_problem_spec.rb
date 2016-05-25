require './models/age_problem'

describe AgeProblem do
  describe '#initialize/new' do
    let(:age_prob_1){described_class.new(:add,10,5,2)}
    let(:age_prob_2){described_class.new(:mtp,3,10,2)}

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

    it 'initializes with an initial equation with time 1 relation is add' do
      left_side = Expression.new([Step.new(nil,'x'),Step.new(:add,15)])
      right_side = Expression.new([Step.new(nil,'x'),Step.new(:add,5),Step.new(:mtp,2,:lft)])
      expected_equation = Equation.new(left_side,right_side)
      expect(age_prob_1.equation).to eq expected_equation
    end

    it 'initializes with an initial equation with time 1 relation is multiply' do
      left_side = Expression.new([Step.new(nil,'x'),Step.new(:mtp,3,:lft),Step.new(:add,10)])
      right_side = Expression.new([Step.new(nil,'x'),Step.new(:add,10),Step.new(:mtp,2,:lft)])
      expected_equation = Equation.new(left_side,right_side)
      # puts age_prob_2.equation.latex
      expect(age_prob_2.equation).to eq expected_equation
    end
  end

  describe '#generate_add_question_text/generate_add_question' do
    let(:people){[['Adam',:m],['Beth',:f],['John',:m],['Julie',:f],['Ken',:m],
      ['Davina',:f],['Henry',:m],['Sarah',:f]]}
    let(:question){described_class.generate_add_type_question}
    let(:question_text){question.generate_add_question_text(people)}

    it 'generates a type 1 add question' do
      srand(100)
      expected_text = "Adam is twelve years younger than Sarah. In four years time, Sarah will be twice as old as Adam. How old is Adam now?"
      expect(question_text).to eq expected_text
    end

    it 'generates a type 2 add question' do
      srand(111)
      expected_text = "John is twenty three years younger than his father. Ten years from now, his father will be twice as old as him. How old is John now?"
      expect(question_text).to eq expected_text
    end

    it 'generates a type 3 add question' do
      srand(141)
      expected_text = "Julie is twenty nine years younger than her father. Eight years from now, her father will be twice as old as her. How old is Julie now?"
      expect(question_text).to eq expected_text
    end

    it 'generates a type 4 add question' do
      srand(117)
      expected_text = "Davina's daughter is twenty three years younger than Davina. In two years time, Davina will be twice as old as her daughter. How old is Davina's daughter now?"
      expect(question_text).to eq expected_text
    end

    it 'generates a type 5 add question' do
      srand(101)
      expected_text = "Sarah is fifteen years older than Davina. Three years from now, Sarah will be four times as old as Davina. How old is Davina now?"
      expect(question_text).to eq expected_text
    end

    it 'generates a type 6 add question' do
      srand(1337)
      expected_text = "Adam is twenty seven years older than his daughter. In five years time, Adam will be four times as old as his daughter. How old is his daughter now?"
      expect(question_text).to eq expected_text
    end

    it 'generates a type 7 add question' do
      srand(52220)
      expected_text = "Davina is sixty six years older than her granddaughter. Thirteen years from now, Davina will be four times as old as her granddaughter. How old is her granddaughter now?"
      expect(question_text).to eq expected_text
    end

    it 'generates a type 8 add question' do
      srand(115)
      expected_text = "John's father is twenty two years older than John. In sixteen years time, John's father will be twice as old as John. How old is John now?"
      expect(question_text).to eq expected_text
    end

    it 'generates a type 9 add question' do
      srand(120)
      expected_text = "Henry's son is forty three years younger than Henry. One year from now, Henry will be twice as old as his son. How old is Henry's son now?"
      expect(question_text).to eq expected_text
    end
  end

  describe '#generate_mtp_question_text/generate_mtp_question' do
    let(:people){[['Adam',:m],['Beth',:f],['John',:m],['Julie',:f],['Ken',:m],
      ['Davina',:f],['Henry',:m],['Sarah',:f]]}
    let(:question){described_class.generate_mtp_type_question}
    let(:question_text){question.generate_mtp_question_text(people)}

    it 'generates a mtp question eg 1' do
      srand(100)
      expected_text = "Seven years ago, John's father was three times as old as John. Three years from now, John's father will be twice as old as John. How old is John now?"
      expect(question_text).to eq expected_text
    end

    it 'generates a mtp question eg 2' do
      srand(200)
      expected_text = "In eight years time, Sarah's grandmother will be five times as old as Sarah. Fourteen years from now, Sarah's grandmother will be four times as old as Sarah. How old is Sarah now?"
      expect(question_text).to eq expected_text
    end

    it 'generates a mtp question eg 3' do
      srand(300)
      expected_text = "Nine years ago, Davina's father was three times as old as Davina. Ten years from now, Davina's father will be twice as old as Davina. How old is Davina now?"
      expect(question_text).to eq expected_text
    end

    it 'generates a mtp question eg 4' do
      srand(400)
      expected_text = "Fourteen years ago, Henry was three times as old as his son. Seven years from now, Henry will be twice as old as his son. How old is Henry's son now?"
      expect(question_text).to eq expected_text
    end
  end







  describe '#solution/solution_latex' do
    let(:age_prob_1){described_class.new(:add,20,5,3)}
    let(:age_prob_2){described_class.new(:mtp,4,10,2)}

    it 'generates solution to the first example' do
      # latex = AgeProblem._solution_latex(age_prob_2.solution)
      # puts latex
      # p AgeProblem.generate_mtp_type_question.generate_mtp_type_question
      # p AgeProblem.generate_add_type_question
      # problem = AgeProblem.generate_add_type_question
      # p problem
      # p problem.generate_add_question_text
      # expected_latex = "x+15&=2\\left(x+5\\right)\\\\\nx+15&=2x+10\\\\\n15&=2x+10-x\\\\\n15&=x+10\\\\\nx+10&=15\\\\\nx&=15-10\\\\\nx&=5"
      # expect(latex).to eq expected_latex
    end

    # it 'generates solution to the second example' do
    #   latex = AgeProblem._solution_latex(age_prob_2.solution)
    #   puts latex
    #   expected_latex = "x3+10&=2\\left(x+10\\right)\\\\\n3x+10&=2x+20\\\\\n10&=2x+20-3x\\\\\n10&=-1x+20\\\\\n-1x+20&=10\\\\\n-1x&=10-20\\\\\n-1x&=-10"
    #   expect(latex).to eq expected_latex
    # end

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
