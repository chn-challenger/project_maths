module EnglishNumber
  def small_english_number(num, with_and = false)
    the_number = ''
    the_number == 'zero' if num == 0
    ones = %w(one two three four five six seven eight nine ten)
    teens = %w(eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen)
    tens = %w(ten twenty thirty forty fifty sixty seventy eighty ninety)

    if num > 99
      current = (num / 100).to_i
      the_number = ones[current - 1] + ' hundred '
      the_number += 'and ' if with_and == true
      num -= current * 100
    end
    if num > 0 && num <= 10
      the_number += ones[num - 1]
    elsif num >= 11 && num <= 19
      the_number += teens[num - 11]
    elsif num >= 20 && num <= 99
      if num % 10 == 0
        the_number += tens[(num / 10).to_i - 1]
      else
        the_number = the_number + tens[(num / 10).to_i - 1] + ' ' + ones[(num % 10).to_i - 1]
      end
    end
    the_number
  end

  def english(num, with_and = false)
    return 'zero' if num == 0
    left = num
    current = 0
    the_number = ''
    large_units = [' quindecillion ', ' quattuordecillion ', ' tredecillion ', ' duodecillion ',
                   ' undecillion ', ' decillion ', ' nonillion ', ' octillion ', ' septillion ',
                   ' sextillion ', ' quintillion ', ' quadrillion ', ' trillion ', ' billion ',
                   ' million ', ' thousand ', '']
    for i in 0..large_units.length - 1
      power_index = 3 * (large_units.length - 1 - i)
      next unless left.to_s.length > power_index
      current = (left / (10**power_index)).to_i
      left -= current * (10**power_index)
      if with_and == true
        the_number += (small_english_number(current, true) + large_units[i])
      else
        the_number += (small_english_number(current) + large_units[i])
      end
      the_number += 'and ' if with_and == true && i != large_units.length - 1
    end
    the_number.slice!(-1) if the_number[-1] == ' '
    the_number
  end

  def english_years(num)
    num == 1 ? english(num) + ' year' : english(num) + ' years'
  end

  def english_times(num)
    return ' ' if num == 1
    return 'twice ' if num == 2
    return english(num) + ' times ' if num > 2
  end
end
