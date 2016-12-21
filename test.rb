
def determine_multiplier(coefs=[], num=0, count=0)
  coefs = [[-10, 4], [-10, 3]]

  coefs[num].each_with_index do |coef, i|
    p coef
    if coef.abs == coefs[num-1][i].abs && coef + coefs[num-1][i] == 0
      puts "Subtract #{coefs[num-1][i]} from #{coef} to get #{coef + coefs[num-1][i]}"
      return
    elsif coef % coefs[num-1][i] == 0
      puts "Multiply #{coefs[num-1]} by #{coef / coefs[num-1][i]}"
      return
    elsif count == 8
      puts "Need to multiply both eq by one of their coefs!"
      return
    else
      int = num == 0 ? 1 : 0
      determine_multiplier([], int, count += 1) if i == coefs[num].size - 1
    end
  end
end

determine_multiplier

# a = 2
#
# case a
# when 3
#   p 'True'
# when % 2 = 0
#   p 'I am divisable by two'
# end
