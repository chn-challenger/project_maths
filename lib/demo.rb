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
Timeout::timeout(2, NoMethodError) {
qs = SimultaneousEquation.generate_question_with_latex
}
# ts = SimultaneousEquation.new
# ts.set_gradients
# ts.set_y_coefficients
# p ts.eq_1_coefs
# p ts.eq_2_coefs
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

# def set_gradients
#   coefs = [sample_coef, sample_coef]
#
#   if no_solutions?(coefs[0], coefs[1])
#     set_gradients
#   else
#     @eq_1_coefs << coefs.pop
#     @eq_2_coefs << coefs.pop
#   end
# end
#
# def set_y_coefficients
#   @eq_1_coefs << sample_coef
#   level_1_coef
#   level_2_coef
#   level_3_coef
# end
#
# def sample_coef
#   @coef_set.shuffle!.sample
# end
#
# def select_coefficient
#   set_gradients
#   set_y_coefficients
# end
#
# def level_1_coef
#   return if @parameters[:difficulty] != 1
#   @eq_2_coefs << @eq_1_coefs[1]
# end
#
# def level_2_coef(i=1)
#   return if @parameters[:difficulty] != 2
#   coef = sample_coef
#   return level_2_coef(i) if coef.abs == @eq_1_coefs[1].abs
#   if !factor?(@eq_1_coefs[1], coef)
#     level_2_coef(i)
#   else
#     @eq_2_coefs << coef
#   end
# end
#
# def level_3_coef
#   return if @parameters[:difficulty] != 3
#   return select_coefficient(coef * 1.5) if factor?(@eq_1_coefs[1], coef)
#   @eq_2_coefs << coef.round
# end




# p eq.equation_1.latex
# p eq.equation_2.latex
p "==========================="

# require './models/fraction'
#
# sim_eq = LatexPrinter.worksheet(:simultaneous_equation, 21, 'Robert Hook', 3, {}, questions_per_row: 1)
# #
# p sim_eq[:questions_sheet]
# puts sim_eq[:solutions_sheet]
