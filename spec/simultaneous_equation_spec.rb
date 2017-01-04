require './models/simultaneous_equation'

describe SimultaneousEquation do
  let(:sim_eq) { described_class.new }

  describe '#set_coefficients' do

    it "generated coefficients never have matching gradient or y-intercept" do
      10.times {
        sim_eq.set_coefficients
        m_1 = sim_eq.eq_1_coefs[0]
        m_2 = sim_eq.eq_2_coefs[0]

        expect(m_1).not_to eq m_2
        expect(sim_eq.eq_rhs[0]).not_to eq sim_eq.eq_rhs[1]
      }
    end
  end

  describe '#factor?' do

    it "when passed 2 and 6 returns true" do
      input = [2, 6]
      expect(sim_eq.factor?(input[0], input[1])).to be true
    end

    it "when passed 2 and 7 returns false" do
      input = [2, 7]
      expect(sim_eq.factor?(input[0], input[1])).to be false
    end

  end

  describe '#no_solutions?' do

    it "when passed 2 and 6 returns true" do
      input = [2, 6]
      expect(sim_eq.no_solutions?(input[0], input[1])).to be true
    end

    it "when passed 2 and 7 returns false" do
      input = [2, 7]
      expect(sim_eq.no_solutions?(input[0], input[1])).to be false
    end

    it "when passed 2 and 2 returns true" do
      input = [2, 2]
      expect(sim_eq.no_solutions?(input[0], input[1])).to be true
    end

    it "when passed 6 and 8 returns true" do
      input = [6, 8]
      expect(sim_eq.no_solutions?(input[0], input[1])).to be true
    end

  end

  describe '#update_coefs' do

    it "when passed [2, 3] and multiplier of 2 returns [4, 6]" do
      input = [2, 3]
      response = [4, 6]
      mtp = 2
      expect(sim_eq.update_coefs(input, mtp)).to eq response
    end

  end


  describe '#generate_question_with_latex' do

    context 'standard formatting' do

      before(:all) do
        srand(10)
      end

      it "returns a hash" do
        expect(described_class.generate_question_with_latex).to be_a(Hash)
      end

      it "generates a standard fully formatted question" do
        response = "&&4x-7y&=-13& &&\\\\\n&&-5x-8y&=-34& &&\\\\[15pt]\n"

        question = described_class.generate_question_with_latex
        expect(question[:question_latex]).to eq response
      end

      it "generates a standard fully formatted solution" do
        response = "&&-5x-3y&=-41& &(1)&\\\\\n&&7x-2y&=45& &(2)&\\\\[15pt]\n&(1)\\times2& -10x-6y&=-82& &(3)&\\\\\n&(2)\\times3& 21x-6y&=135& &(4)&\\\\[15pt]\n&(3)-(4)& -10x-6y-\\left(21x-6y\\right)&=-82-135\\\\\n&& -31x&=-217\\\\\n&& x&=\\frac{-217}{-31}\\\\\n&& x&=7\\\\[15pt]\n&\\text{Sub}\\hspace{5pt} x\\hspace{5pt} \\text{into}\\hspace{5pt} (1)&\\\n7\\times7-2y&=45\\\\[5pt]\n&& 49-2y&=45\\\\\n&& 49-45&=2y\\\\\n&& 4&=2y\\\\\n&& \\frac{4}{2}&=y\\\\\n&& 2&=y\\\\[5pt]\n&x=7\\hspace{5pt} \\text{and}\\hspace{5pt} y=2& && &&"

        question = described_class.generate_question_with_latex
        expect(question[:solution_latex]).to eq response
      end

    end

    context 'rails formatting' do

      before(:all) do
        srand(12)
      end

      it "generates a question in a rails compatible formatting" do
        response = "question-text$\\\\$\nSolve the simultaneous equations:$\\\\\\hspace{140pt}\\begin{align*}&&-7x-9y&=-80& &&\\\\\n&&3x-4y&=-5& &&\\\\[15pt]\n\\end{align*}\\\\$$\\\\$\n\nsolution-text$\\\\$\n$\\\\\\begin{align*}&&-7x-9y&=-80& &(1)&\\\\\n&&3x-4y&=-5& &(2)&\\\\[15pt]\n&(1)\\times3& -21x-27y&=-240& &(3)&\\\\\n&(2)\\times7& 21x-28y&=-35& &(4)&\\\\[15pt]\n&(3)+(4)& -21x-27y+\\left(21x-28y\\right)&=-240+-35\\\\\n&& -55y&=-275\\\\\n&& y&=\\frac{-275}{-55}\\\\\n&& y&=5\\\\[15pt]\n&\\text{Sub}\\hspace{5pt} x\\hspace{5pt} \\text{into}\\hspace{5pt} (1)&\\\n3x-4\\times5&=-5\\\\[5pt]\n&& 3x-20&=-5\\\\\n&& 3x&=-5+20\\\\\n&& 3x&=15\\\\\n&& x&=\\frac{15}{3}\\\\\n&& x&=5\\\\[5pt]\n\\end{align*}\\\\$$x=5\\hspace{5pt}$  and $\\hspace{5pt} y=5$$\\\\$\n\nquestion-experience$\\\\$\n25$\\\\$\n\nquestion-order-group$\\\\$\n$\\\\$\n\nquestion-level$\\\\$\n1$\\\\$\n\nanswer-label$\\\\$\n$x=$$\\\\$\n\nanswer-value$\\\\$\n5$\\\\$\n\nanswer-hint$\\\\$\nGive integer solution.$\\\\$\n\nanswer-label$\\\\$\n$y=$$\\\\$\n\nanswer-value$\\\\$\n5$\\\\$\n\nanswer-hint$\\\\$\nGive integer solution.$\\\\$\n\n"

        question = described_class.generate_question_with_latex(rails: true)
        expect(question[:rails_question_latex]).to eq response
      end

    end
  end
end
