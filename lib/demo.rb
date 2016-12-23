# require './models/linear_equation'
require './models/latex_printer'
require './models/simultaneous_equation'
require 'timeout'
#
# Initialize questions to be printed
@print = LatexPrinter.rails_sheet(:simultaneous_equation, 4, rails: true)
#
# Write Questions to File
File.open('output.tex', 'w') do |f|
  f.puts @print
end

# def test(name)
#   hash = {name.to_sym => 'Yep'}
#   yield(hash)
#   hash
# end
#
# p test('Rails') { |hash| hash[:Rails] << ' Hey'}

# eq = SimultaneousEquation.new
p "==========================="
# p eq.update_coefs([[2, 3], [4, 5]], [2, 3])
# qs = nil
# # Timeout::timeout(4, NoMethodError) {
# qs = eq.generate_question_with_latex
# # }
# puts qs[:question_latex]
# puts qs[:solution_latex]


# p eq.equation_1.latex
# p eq.equation_2.latex
p "==========================="

# require './models/fraction'
#
# sim_eq = LatexPrinter.worksheet(:simultaneous_equation, 21, 'Robert Hook', 3, {}, questions_per_row: 1)
# #
# p sim_eq[:questions_sheet]
# puts sim_eq[:solutions_sheet]
