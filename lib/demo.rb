require './models/linear_equation'
require './models/latex_printer'

# Initialize questions to be printed
@print = LatexPrinter.rails_sheet(:linear_equation, 4, rails: true)

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
