require './generators/age_problem'

# describe AgeProblem do
#   describe '#initialize/new' do
#     let(:age_prob_1){described_class.new(:add,10,5,2)}
#     let(:age_prob_2){described_class.new(:mtp,3,10,2)}
#
#     it 'initializes with a time 1 relation' do
#       expect(age_prob_1.time_1_rel).to eq :add
#     end
#
#     it 'initializes with a time 1 relational value' do
#       expect(age_prob_1.time_1_val).to eq 10
#     end
#
#     it 'initializes with a time 1 and time 2 difference in time' do
#       expect(age_prob_1.time_diff).to eq 5
#     end
#
#     it 'initializes with a time 2 relational value' do
#       expect(age_prob_1.time_2_val).to eq 2
#     end
#
#     it 'initializes with an initial equation with time 1 relation is add' do
#       left_side = Expression.new([Step.new(nil,'x'),Step.new(:add,15)])
#       right_side = Expression.new([Step.new(nil,'x'),Step.new(:add,5),Step.new(:mtp,2)])
#       expected_equation = Equation.new(left_side,right_side)
#       expect(age_prob_1.equation).to eq expected_equation
#     end
#
#     it 'initializes with an initial equation with time 1 relation is multiply' do
#       left_side = Expression.new([Step.new(nil,'x'),Step.new(:mtp,3),Step.new(:add,10)])
#       right_side = Expression.new([Step.new(nil,'x'),Step.new(:add,10),Step.new(:mtp,2)])
#       expected_equation = Equation.new(left_side,right_side)
#       expect(age_prob_2.equation).to eq expected_equation
#     end
#
#     describe '#solution/solution_latex' do
#       let(:age_prob_1){described_class.new(:add,10,5,2)}
#       let(:age_prob_2){described_class.new(:mtp,3,10,2)}
#
#       it 'generates solution to the first example' do
#         latex = AgeProblem._solution_latex(age_prob_1.solution)
#         expected_latex = "x+15&=2\\left(x+5\\right)\\\\\nx+15&=2x+10\\\\\n15&=2x+10-x\\\\\n15&=x+10\\\\\nx+10&=15\\\\\nx&=15-10\\\\\nx&=5"
#         expect(latex).to eq expected_latex
#       end
#
#       it 'generates solution to the second example' do
#         latex = AgeProblem._solution_latex(age_prob_2.solution)
#         puts latex
#         expected_latex = "x3+10&=2\\left(x+10\\right)\\\\\n3x+10&=2x+20\\\\\n10&=2x+20-3x\\\\\n10&=-1x+20\\\\\n-1x+20&=10\\\\\n-1x&=10-20\\\\\n-1x&=-10"
#         expect(latex).to eq expected_latex
#       end
#
#     end
#
#
#   end


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
