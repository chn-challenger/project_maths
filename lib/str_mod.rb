require 'clipboard'

input_str = "\\documentclass{article}\n\\usepackage[math]{iwona}\n\\usepackage[fleqn]{amsmath}\n\\usepackage{scrextend}\n\\changefontsizes[16pt]{12pt}\n\\usepackage[a4paper, left=0.7in,right=0.7in,top=1in,bottom=1in]{geometry}\n\\pagenumbering{gobble}\n\\usepackage{fancyhdr}\n\\renewcommand{\\headrulewidth}{0pt}\n\\pagestyle{fancy}\n\\lfoot{PP-UP763904-S\\quad \\textcopyright\\, Joe Zhou, 2016}\n\\rfoot{\\textit{student:}\\quad James Davis}\n\\begin{document}\n\n\\section*{\\centerline{Practice Paper 3 Solutions}}\n\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n1.\\hspace{30pt}5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n2.\\hspace{30pt}5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n3.\\hspace{30pt}5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n4.\\hspace{30pt}5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n5.\\hspace{30pt}5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n6.\\hspace{30pt}5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n7.\\hspace{30pt}5\\frac{1}{2}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n5\\frac{1}{28.\\hspace{30pt}}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\vspace{1 mm}\n\n\\noindent\n\\begin{minipage}[t]{1.0000\\textwidth}\n\\begin{align*}\n5\\frac{1}{29.\\hspace{30pt}}\\times2\\frac{3}{4}=15\\frac{1}{8}\n\\end{align*}\n\\end{minipage}\n\\end{document}"

q = nil

matcher = if q
  '\4\\left(6\\left(x-2\\right)+76\\right)&=496'
  # '\intertext{This is an Age Problem.}'
else
  '\5\frac{1}{2}\times2\frac{3}{4}=15\frac{1}{8}'
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
