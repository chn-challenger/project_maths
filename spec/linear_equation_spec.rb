require './models/linear_equation'

describe LinearEquation do
  describe '#generate/question_latex' do
    context 'generates a one step question' do
      shared_context 'one step question' do
        before(:all) do
          srand(122)
          @question = LinearEquation.generate_question({number_of_steps:1})
          @question_latex = LinearEquation.latex(@question)
        end
      end

      include_context 'one step question'

      it 'generates one step question' do
        expected_question_latex = "25+x&=33"
        expect(@question_latex[:question_latex]).to eq expected_question_latex
      end

      it 'generates solution for the one step question' do
        expected_solution_latex = "25+x&=33\\\\\nx&=33-25\\\\\nx&=8"
        expect(@question_latex[:solution_latex]).to eq expected_solution_latex
      end
    end

    context 'generates a standard four step question' do
      shared_context 'standard four step question' do
        before(:all) do
          srand(122)
          @question = LinearEquation.generate_question()
          @question_latex = LinearEquation.latex(@question)
        end
      end

      include_context 'standard four step question'

      it 'generates standard four step question' do
        expected_question_latex = "8\\left(\\frac{264}{25+x}+41\\right)&=392"
        expect(@question_latex[:question_latex]).to eq expected_question_latex
      end

      it 'generates solution for the standard four step question' do
        expected_solution_latex = "8\\left(\\frac{264}{25+x}+41\\right)&=392\\"\
          "\\\n\\frac{264}{25+x}+41&=\\frac{392}{8}\\\\\n\\frac{264}{25+x}+41&"\
          "=49\\\\\n\\frac{264}{25+x}&=49-41\\\\\n\\frac{264}{25+x}&=8\\\\\n\\"\
          "frac{264}{8}&=25+x\\\\\n33&=25+x\\\\\n33-25&=x\\\\\n8&=x"
        expect(@question_latex[:solution_latex]).to eq expected_solution_latex
      end
    end

    context 'generates a five step question' do
      shared_context 'five step question' do
        before(:all) do
          srand(122)
          @question = LinearEquation.generate_question({number_of_steps:5})
          @question_latex = LinearEquation.latex(@question)
        end
      end

      include_context 'five step question'

      it 'generates five step question' do
        expected_question_latex = "8\\left(\\frac{264}{25+x}+41\\right)+61&=453"
        expect(@question_latex[:question_latex]).to eq expected_question_latex
      end

      it 'generates solution for the five step question' do
        expected_solution_latex = "8\\left(\\frac{264}{25+x}+41\\right)+61&=45"\
        "3\\\\\n8\\left(\\frac{264}{25+x}+41\\right)&=453-61\\\\\n8\\left(\\fr"\
        "ac{264}{25+x}+41\\right)&=392\\\\\n\\frac{264}{25+x}+41&=\\frac{392}{"\
        "8}\\\\\n\\frac{264}{25+x}+41&=49\\\\\n\\frac{264}{25+x}&=49-41\\\\\n"\
        "\\frac{264}{25+x}&=8\\\\\n\\frac{264}{8}&=25+x\\\\\n33&=25+x\\\\\n33-"\
        "25&=x\\\\\n8&=x"
        expect(@question_latex[:solution_latex]).to eq expected_solution_latex
      end
    end
  end





end
