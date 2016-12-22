def operation(coef_1, coef_2, op, mtp=nil)
  if op == :sbt
    return coef_1 - coef_2
  elsif op == :add
    return coef_1 + coef_2
  elsif op == :mtp
    coef_1.collect { |e| e * mtp }
  end
end

def determine_multiplier(coefs=[], num=0, count=0)
  coefs = [[-9, 2], [-7, 4]] if coefs.empty?
  ops = {}

  coefs[num].each_with_index do |coef, i|
    if coef.abs == coefs[num-1][i].abs
      if coef + coefs[num-1][i] == 0
        ops = { operation: :add, multiplier: nil }
      else
        ops = { operation: :sbt, multiplier: nil }
      end
      puts "#{ops[:operation]} #{coefs[num-1][i]} from #{coef} to get #{operation(coef, coefs[num-1][i], ops[:operation])}"
      return
    elsif coef.abs % coefs[num-1][i].abs == 0
      mtp = coef[-1] / coefs[num-1][-1]
      res = operation([-9, 2],nil, :mtp, mtp)

      puts "Multiply #{coefs[num-1]} by #{coef[-1] / coefs[num-1][-1]} to get #{res} and "

      determine_multiplier([res, [-7, 4]], num, 0)
      return
    elsif coefs[num-1][i].abs % coef.abs == 0
      mtp = coefs[num-1][-1] / coef

      res = operation([-9, 2],nil, :mtp, mtp)

      puts "Multiply #{coefs[num]} by #{coefs[num-1][-1] / coef} to get #{res} and "

      determine_multiplier([res, [-7, 4]], num, 0)
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
