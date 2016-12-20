require 'clipboard'

input_str = "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[20pt]{14pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{2016-12-20 10:32:41 +0000-Q\\quad \\text copyright\\,\n    Joe Zhou, 2016}\n\n \\begin{document}\n\n \#{question}5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\#{question}5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\\end{document}"

q = nil

matcher = if q
            '4\\left(6\\left(x-2\\right)+76\\right)&=496'
          # '\intertext{This is an Age Problem.}'
          else
            '5\frac{1}{2}\times2\frac{3}{4}=15\frac{1}{8}'
          # '\intertext{This is an Age Problem Solution.}'
end

sub_str = if q
            '#{question}'
          else
            '#{solution}'
end

p result = input_str.gsub(matcher, sub_str)

# Clipboard.copy(result.to_s)
system "echo 'results copied to clipboard'"
