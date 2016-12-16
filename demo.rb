require './models/linear_equation'
require './models/latex_printer'

# Initialize questions to be printed
@print = LatexPrinter.worksheet(:linear_equation,11,'Leonhard Euler',
  4,{},{questions_per_row:1})

# Write Questions to File
File.open('output.tex', 'w') { |f|
  f.puts @print[:rails_sheet]
}
