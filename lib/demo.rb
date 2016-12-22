# require './models/linear_equation'
require './models/latex_printer'
require 'timeout'
#
# # Initialize questions to be printed
# @print = LatexPrinter.rails_sheet(:linear_equation, 4, rails: true)
#
# # Write Questions to File
# File.open('output.tex', 'w') do |f|
#   f.puts @print
# end

# def test(name)
#   hash = {name.to_sym => 'Yep'}
#   yield(hash)
#   hash
# end
#
# p test('Rails') { |hash| hash[:Rails] << ' Hey'}

require './models/simultaneous_equation'

eq = SimultaneousEquation.new
p "==========================="
# p eq.update_coefs([[2, 3], [4, 5]], [2, 3])
Timeout::timeout(1, NoMethodError) {
eq._generate_question()
}
# p eq.ops


# p eq.equation_1.latex
# p eq.equation_2.latex
p "==========================="

# require './models/fraction'
#
# fraction = LatexPrinter.worksheet(:fraction, 21, 'Robert Hook', 2)
#
# p fraction
