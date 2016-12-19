require './models/fraction'

describe Fraction do
  describe '#initialize/new' do
    let(:fraction) { described_class.new(2, 3, 4) }

    it 'initializes with a integer part' do
      expect(fraction.integer).to eq 2
    end
    it 'initializes with a denominator' do
      expect(fraction.numerator).to eq 3
    end
    it 'initializes with a numerator' do
      expect(fraction.denominator).to eq 4
    end
  end

  describe '#simplify' do
    let(:fraction1) { described_class.new(3, 6, 8) }
    let(:fraction2) { described_class.new(4, 12, 8) }

    context 'make fraction parts into lowest form' do
      it 'has new simplified numerator' do
        fraction1.simplify
        expect(fraction1.numerator).to eq 3
      end
      it 'has new simplified denominator' do
        fraction1.simplify
        expect(fraction1.denominator).to eq 4
      end
    end

    context 'make fraction part of a mixed fraction not top-heavy' do
      it 'has a new integer part' do
        fraction2.simplify
        expect(fraction2.integer).to eq 5
      end

      it 'has a new numerator' do
        fraction2.simplify
        expect(fraction2.numerator).to eq 1
      end

      it 'has a new denominator' do
        fraction2.simplify
        expect(fraction2.denominator).to eq 2
      end

      it 'is not top-heavy' do
        fraction2.simplify
        expect(fraction2.numerator <= fraction2.denominator).to eq true
      end
    end
  end

  describe '#==' do
    let(:fraction1) { described_class.new(2, 5, 8) }
    let(:fraction2) { described_class.new(2, 5, 8) }

    it 'two fractions to be equal if they have the same parts' do
      expect(fraction1 == fraction2).to be true
    end
  end

  describe '#>' do
    let(:fraction1) { described_class.new(3, 5, 8) }
    let(:fraction2) { described_class.new(2, 5, 8) }
    let(:fraction3) { described_class.new(0, 35, 8) }
    let(:fraction4) { described_class.new(1, 26, 16) }

    it 'is true when fraction is greater than another fraction' do
      expect(fraction1 > fraction2).to be true
    end

    it 'returns false when the two fractions are equal' do
      expect(fraction2 > fraction4).to be false
    end

    it 'can compare mixed and top-heavy fractions' do
      expect(fraction1 > fraction3).to be false
    end
  end

  describe '#<' do
    let(:fraction1) { described_class.new(3, 5, 8) }
    let(:fraction2) { described_class.new(2, 5, 8) }
    let(:fraction3) { described_class.new(0, 35, 8) }
    let(:fraction4) { described_class.new(1, 26, 16) }

    it 'is false when fraction is greater than another fraction' do
      expect(fraction1 < fraction2).to be false
    end

    it 'returns false when the two fractions are equal' do
      expect(fraction2 < fraction4).to be false
    end

    it 'can compare mixed and top-heavy fractions' do
      expect(fraction1 < fraction3).to be true
    end
  end

  describe '#same_value?' do
    let(:fraction1) { described_class.new(2, 5, 8) }
    let(:fraction2) { described_class.new(1, 26, 16) }

    it 'two fractions to be equal if they have the same simplified parts' do
      expect(fraction1.same_value?(fraction2)).to eq true
    end
  end

  describe '#mixed_to_topheavy' do
    let(:fraction1) { described_class.new(2, 5, 8) }
    let(:fraction2) { described_class.new(2, 5, 8) }

    it 'changes a mixed fraction into a top-heavy fraction' do
      new_fraction = fraction1.mixed_to_topheavy
      expect(new_fraction.integer).to eq 0
    end

    it 'does not change the original fraction' do
      fraction1.mixed_to_topheavy
      expect(fraction1.integer).to eq 2
    end

    it 'the changed mixed fraction has the same value as before' do
      fraction1.mixed_to_topheavy
      expect(fraction1.same_value?(fraction2)).to eq true
    end
  end

  describe '#topheavy_to_mixed' do
    let(:fraction1) { described_class.new(0, 21, 8) }
    let(:fraction2) { described_class.new(0, 21, 8) }

    it 'changes a top-heavy fraction into a mixed fraction' do
      new_fraction = fraction1.topheavy_to_mixed
      expect(new_fraction.integer).to eq 2
    end

    it 'does not change the original fraction' do
      fraction1.topheavy_to_mixed
      expect(fraction1.integer).to eq 0
    end

    it 'the changed top-heavy fraction has the same value as before' do
      fraction1.topheavy_to_mixed
      expect(fraction1.same_value?(fraction2)).to eq true
    end
  end

  describe '#+' do
    let(:fraction1) { described_class.new(2, 5, 8) }
    let(:fraction2) { described_class.new(4, 5, 6) }
    let(:result_fraction) { described_class.new(7, 11, 24) }

    it 'adds a fraction to another fraction resulting in a new fraction' do
      expect(fraction1 + fraction2).to eq result_fraction
    end
  end

  describe '#-' do
    let(:fraction1) { described_class.new(5, 4, 9) }
    let(:fraction2) { described_class.new(2, 2, 3) }
    let(:result_fraction) { described_class.new(2, 7, 9) }

    it 'subtracts a fraction from another fraction resulting in a new fraction' do
      expect(fraction1 - fraction2).to eq result_fraction
    end
  end

  describe '#*' do
    let(:fraction1) { described_class.new(3, 2, 3) }
    let(:fraction2) { described_class.new(2, 3, 4) }
    let(:result_fraction) { described_class.new(10, 1, 12) }

    it 'multiply a fraction to another fraction resulting in a new fraction' do
      expect(fraction1 * fraction2).to eq result_fraction
    end
  end

  describe '#/' do
    let(:fraction1) { described_class.new(3, 2, 3) }
    let(:fraction2) { described_class.new(2, 3, 4) }
    let(:result_fraction) { described_class.new(1, 1, 3) }

    it 'divide a fraction from another fraction resulting in a new fraction' do
      expect(fraction1 / fraction2).to eq result_fraction
    end
  end

  describe '#random' do
    shared_context 'a random fraction' do
      before(:all) do
        srand(100)
        @fraction = Fraction.random
      end
    end

    include_context 'a random fraction'

    it 'has a random integer part' do
      expect(@fraction.integer).to eq 8
    end

    it 'has a random numerator' do
      expect(@fraction.numerator).to eq 2
    end

    it 'has a random denominator' do
      expect(@fraction.denominator).to eq 5
    end

    it 'has is a proper fraction' do
      expect(@fraction.numerator < @fraction.denominator).to be true
    end
  end

  describe '#self.generate/self.latex' do
    context 'generate addition question and solution' do
      shared_context 'addition question' do
        before(:all) do
          srand(102)
          @question = Fraction.generate_question
          @question_latex = Fraction.latex(@question)
        end
      end

      include_context 'addition question'

      it 'generates addition question' do
        expected_question_latex = '3\\frac{3}{4}+2\\frac{9}{11}'
        expect(@question_latex[:question_latex]).to eq expected_question_latex
      end

      it 'generates solution for the addition question' do
        expected_solution_latex = '3\\frac{3}{4}+2\\frac{9}{11}=6\\frac{25}{44}'
        expect(@question_latex[:solution_latex]).to eq expected_solution_latex
      end
    end

    context 'generate subtraction question and solution' do
      shared_context 'subtraction question' do
        before(:all) do
          srand(104)
          @question = Fraction.generate_question
          @question_latex = Fraction.latex(@question)
        end
      end

      include_context 'subtraction question'

      it 'generates subtraction question' do
        expected_question_latex = '8\\frac{1}{2}-1\\frac{7}{11}'
        expect(@question_latex[:question_latex]).to eq expected_question_latex
      end

      it 'generates solution for the subtraction question' do
        expected_solution_latex = '8\\frac{1}{2}-1\\frac{7}{11}=6\\frac{19}{22}'
        expect(@question_latex[:solution_latex]).to eq expected_solution_latex
      end
    end

    context 'generate multiplication question and solution' do
      shared_context 'multiplication question' do
        before(:all) do
          srand(124)
          @question = Fraction.generate_question
          @question_latex = Fraction.latex(@question)
        end
      end

      include_context 'multiplication question'

      it 'generates multiplication question' do
        expected_question_latex = '1\\frac{1}{3}\\times11\\frac{1}{2}'
        expect(@question_latex[:question_latex]).to eq expected_question_latex
      end

      it 'generates solution for the multiplication question' do
        expected_solution_latex = '1\\frac{1}{3}\\times11\\frac{1}{2}=15\\frac{1}{3}'
        expect(@question_latex[:solution_latex]).to eq expected_solution_latex
      end
    end

    context 'generate division question and solution' do
      shared_context 'division question' do
        before(:all) do
          srand(122)
          @question = Fraction.generate_question
          @question_latex = Fraction.latex(@question)
        end
      end

      include_context 'division question'

      it 'generates division question' do
        expected_question_latex = '7\\frac{1}{2}\\div6\\frac{1}{2}'
        expect(@question_latex[:question_latex]).to eq expected_question_latex
      end

      it 'generates solution for the division question' do
        expected_solution_latex = '7\\frac{1}{2}\\div6\\frac{1}{2}=1\\frac{2}{13}'
        expect(@question_latex[:solution_latex]).to eq expected_solution_latex
      end
    end

    context 'generate question and solution with non-default parameters' do
      shared_context 'question' do
        before(:all) do
          srand(127)
          @question = Fraction.generate_question(max_integer_value: 100, max_fraction_value: 50)
          @question_latex = Fraction.latex(@question)
        end
      end

      include_context 'question'

      it 'generates question with non-default parameters' do
        expected_question_latex = '60\\frac{29}{36}-30\\frac{4}{11}'
        expect(@question_latex[:question_latex]).to eq expected_question_latex
      end

      it 'generates solution for the question with non-default parameters' do
        expected_solution_latex = '60\\frac{29}{36}-30\\frac{4}{11}=30\\frac{175}{396}'
        expect(@question_latex[:solution_latex]).to eq expected_solution_latex
      end
    end
  end

  #
  # describe '#question' do
  #   context 'it can generates random fraction addition questions' do
  #     shared_context 'example addition question' do
  #       before(:all) do
  #         srand(100)
  #         @question = Fraction.question
  #       end
  #     end
  #
  #     include_context 'example addition question'
  #
  #     it 'has operator of addition' do
  #       expect(@question[:operation]).to eq 'add'
  #     end
  #
  #     it 'generates a fraction for the addition' do
  #       expect(@question[:fraction1]).to eq Fraction.new(8,2,5)
  #     end
  #
  #     it 'generates another fraction for the addition' do
  #       expect(@question[:fraction2]).to eq Fraction.new(7,8,9)
  #     end
  #
  #     it 'generates solution to the question' do
  #       expect(@question[:solution]).to eq Fraction.new(16,13,45)
  #     end
  #   end
  #
  #   context 'it can generates random fraction subtraction questions' do
  #     shared_context 'example subtraction question' do
  #       before(:all) do
  #         srand(200)
  #         @question = Fraction.question('subtract')
  #       end
  #     end
  #
  #     include_context 'example subtraction question'
  #
  #     it 'has operator of subtraction' do
  #       expect(@question[:operation]).to eq 'subtract'
  #     end
  #
  #     it 'generates a fraction for the subtraction' do
  #       expect(@question[:fraction1]).to eq Fraction.new(10,1,2)
  #     end
  #
  #     it 'generates another fraction for the subtraction' do
  #       expect(@question[:fraction2]).to eq Fraction.new(4,5,9)
  #     end
  #
  #     it 'generates solution to the question' do
  #       expect(@question[:solution]).to eq Fraction.new(5,17,18)
  #     end
  #   end
  #
  #   context 'it can generates random fraction multiplication questions' do
  #     shared_context 'example multiplication question' do
  #       before(:all) do
  #         srand(300)
  #         @question = Fraction.question('multiply')
  #       end
  #     end
  #
  #     include_context 'example multiplication question'
  #
  #     it 'has operator of multiply' do
  #       expect(@question[:operation]).to eq 'multiply'
  #     end
  #
  #     it 'generates a fraction for the multiplication' do
  #       expect(@question[:fraction1]).to eq Fraction.new(1,2,3)
  #     end
  #
  #     it 'generates another fraction for the multiplication' do
  #       expect(@question[:fraction2]).to eq Fraction.new(2,1,2)
  #     end
  #
  #     it 'generates solution to the question' do
  #       expect(@question[:solution]).to eq Fraction.new(4,1,6)
  #     end
  #   end
  #
  #   context 'it can generates random fraction division questions' do
  #     shared_context 'example division question' do
  #       before(:all) do
  #         srand(400)
  #         @question = Fraction.question('divide')
  #       end
  #     end
  #
  #     include_context 'example division question'
  #
  #     it 'has operator of divide' do
  #       expect(@question[:operation]).to eq 'divide'
  #     end
  #
  #     it 'generates a fraction for the division' do
  #       expect(@question[:fraction1]).to eq Fraction.new(4,1,4)
  #     end
  #
  #     it 'generates another fraction for the division' do
  #       expect(@question[:fraction2]).to eq Fraction.new(4,4,5)
  #     end
  #
  #     it 'generates solution to the question' do
  #       expect(@question[:solution]).to eq Fraction.new(0,85,96)
  #     end
  #   end
  # end
  #
  # describe '#worksheet_questions' do
  #   it 'generate fraction addition questions for a worksheet' do
  #     srand(100)
  #     questions = Fraction.worksheet_questions(2)
  #     expected_questions = []
  #     question1 = {operation:'add',fraction1:Fraction.new(8,2,5),
  #       fraction2:Fraction.new(7,8,9),solution:Fraction.new(16,13,45)}
  #     question2 = {operation:'add',fraction1:Fraction.new(0,1,2),
  #       fraction2:Fraction.new(5,3,4),solution:Fraction.new(6,1,4)}
  #     expected_questions << question1
  #     expected_questions << question2
  #     expect(questions).to eq expected_questions
  #   end
  #
  #   it 'generate addition and subtraction fraction questions for a worksheet' do
  #     srand(200)
  #     questions = Fraction.worksheet_questions(3,['add','subtract'])
  #     expected_questions = []
  #     question1 = {operation:'add',fraction1:Fraction.new(9,1,2),
  #       fraction2:Fraction.new(4,5,9),solution:Fraction.new(14,1,18)}
  #     question2 = {operation:'subtract',fraction1:Fraction.new(9,3,8),
  #       fraction2:Fraction.new(8,2,3),solution:Fraction.new(0,17,24)}
  #     question3 = {operation:'subtract',fraction1:Fraction.new(9,1,3),
  #       fraction2:Fraction.new(7,1,7),solution:Fraction.new(2,4,21)}
  #     expected_questions << question1
  #     expected_questions << question2
  #     expected_questions << question3
  #     expect(questions).to eq expected_questions
  #   end
  #
  #   it 'generate multiplication and division fraction questions for a worksheet' do
  #     srand(200)
  #     questions = Fraction.worksheet_questions(3,['multiply','divide'],0,8)
  #     expected_questions = []
  #     question1 = {operation:'multiply',fraction1:Fraction.new(0,1,3),
  #       fraction2:Fraction.new(0,1,2),solution:Fraction.new(0,1,6)}
  #     question2 = {operation:'divide',fraction1:Fraction.new(0,1,3),
  #       fraction2:Fraction.new(0,2,5),solution:Fraction.new(0,5,6)}
  #     question3 = {operation:'divide',fraction1:Fraction.new(0,3,5),
  #       fraction2:Fraction.new(0,1,4),solution:Fraction.new(2,2,5)}
  #     expected_questions << question1
  #     expected_questions << question2
  #     expected_questions << question3
  #     expect(questions).to eq expected_questions
  #   end
  # end
end
