# require './models/linear_equation'
require './models/latex_printer'
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
eq._generate_question()


# p eq.equation_1.latex
# p eq.equation_2.latex
p "==========================="

# require './models/fraction'
#
# fraction = LatexPrinter.worksheet(:fraction, 21, 'Robert Hook', 2)
#
# p fraction
