# require './models/linear_equation'
# require './models/latex_printer'
require './models/simultaneous_equation'
require 'timeout'
#
# Initialize questions to be printed
# @print = LatexPrinter.rails_sheet(:simultaneous_equation, 4, rails: true)
# #
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

# eq = SimultaneousEquation.new
p "==========================="
qs = nil
Timeout::timeout(1, NoMethodError) {
qs = SimultaneousEquation.generate_question_with_latex
}
puts qs[:question_latex]
puts qs[:solution_latex]

# def tester(num=1)
#   return recur(num) if num < 5
#   # return if num < 5
#   p 'I am executing T_T'
# end
# ms = [@eq_1_coefs[0], @eq_2_coefs[0]]
# cs = [@eq_1_coefs[1], coef]
#
#
# lcm_ms = ms[0].lcm(ms[1])
# lcm_cs = cs[0].lcm(cs[1])
#
# if lcm_ms < lcm_cs
#
# else
#
# end


#
# def recur(num= 1)
#   num += 1
#   return tester(num) if num < 5
#   p "My #{num} run"
# end
#
# recur



# p eq.equation_1.latex
# p eq.equation_2.latex
p "==========================="

# require './models/fraction'
#
# sim_eq = LatexPrinter.worksheet(:simultaneous_equation, 21, 'Robert Hook', 3, {}, questions_per_row: 1)
# #
# p sim_eq[:questions_sheet]
# puts sim_eq[:solutions_sheet]
