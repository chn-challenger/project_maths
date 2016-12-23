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


  describe '#update_coefs' do

    it "when passed [2, 3] and multiplier of 2 returns [4, 6]" do
      input = %w(2 3)
      response = %w(4 6)
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
        response = "&&-4x-7y&=-74& &(1)&\\\\&&-3x+5y&=6& &(2)&\\\\[15pt]"

        question = described_class.generate_question_with_latex
        expect(question[:question_latex]).to eq response
      end

      it "generates a standard fully formatted solution" do
        response = "&(1)\\times6& -5x+2y&=-14& &(1)&\\\\[5pt]\n&(1)+(2)&\\\n-5x+2y-\\left(7x+2y\\right)&=-14-58\\\n&& -12x&=-72\\\\\n&& x&=\\frac{-72}{-12}\\\\\n&& x&=6\\\\[5pt]\n&\\text{Sub}\\hspace{5pt} x\\hspace{5pt} \\text{into}\\hspace{5pt} (1)& 7\\times6+2y&=58\\\\[5pt]\n&& 42+2y&=58\\\\\n&& 2y&=58-42\\\\\n&& 2y&=16\\\\\n&& y&=\\frac{16}{2}\\\\\n&& y&=8\\\\[5pt]\n&x=6\\hspace{5pt} \\text{and}\\hspace{5pt} y=8& && &&"

        question = described_class.generate_question_with_latex
        expect(question[:solution_latex]).to eq response
      end

    end

    context 'rails formatting' do

      before(:all) do
        srand(12)
      end

      it "generates a question in a rails compatible formatting" do
        response = "question-text$\\\\$\n$\\begin{align*}&&7x+3y&=63& &(1)&\\\\&&-5x+5y&=5& &(2)&\\\\[15pt]\\end{align*}$$\\\\$\n\nsolution-text$\\\\$\n$\\begin{align*}&(1)\\times5& 35x+15y&=315& &(3)&\\\\\n&(2)\\times3& -15x+15y&=15& &(4)&\\\\[15pt]\n&(3)+(4)& 35x+15y-\\left(-15x+15y\\right)&=315-15\\\\\n&& 50x&=300\\\\\n&& x&=\\frac{300}{50}\\\\\n&& x&=6\\\\[15pt]\n&\\text{Sub}\\hspace{5pt} x\\hspace{5pt} \\text{into}\\hspace{5pt} (1)&\\\n-5\\times6+5y&=5\\\\[5pt]\n&& -30+5y&=5\\\\\n&& 5y&=5--30\\\\\n&& 5y&=35\\\\\n&& y&=\\frac{35}{5}\\\\\n&& y&=7\\\\[5pt]\n&x=6\\hspace{5pt} \\text{and}\\hspace{5pt} y=7& && &&\\end{align*}$$\\\\$\n\nquestion-experience$\\\\$\n25$\\\\$\n\nquestion-order-group$\\\\$\n$\\\\$\n\nquestion-level$\\\\$\n1$\\\\$\n\nanswer-label$\\\\$\n$x=$$\\\\$\n\nanswer-value$\\\\$\n6$\\\\$\n\nanswer-hint$\\\\$\nGive integer solution.$\\\\$\n\nanswer-label$\\\\$\n$y=$$\\\\$\n\nanswer-value$\\\\$\n7$\\\\$\n\nanswer-hint$\\\\$\nGive integer solution.$\\\\$\n\n"

        question = described_class.generate_question_with_latex(rails: true)
        expect(question[:rails_question_latex]).to eq response
      end

    end
  end
end
