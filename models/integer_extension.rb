class Integer

	def small_english_number(with_and = false)
		num = self
		the_number = ''
		if num == 0
			the_number == 'zero'
		end
		ones =['one','two','three','four','five','six','seven','eight','nine']
		teens = ['eleven','twelve','thirteen','fourteen','fifteen','sixteen',
      'seventeen','eighteen','nineteen']
		tens = ['ten','tweenty','thirty','forty','fifty','sixty','seventy',
      'eighty','ninety']
		if num > 99
			current = (num/100).to_i
			the_number = ones[current-1] + ' hundred '
			the_number += 'and ' if with_and == true
			num = num - current*100
		end
		if num > 0 && num < 10
			the_number = the_number + ones[num-1]
		elsif num > 10 && num < 20
			the_number = the_number + teens[num-11]
		elsif num > 19 && num < 100
			the_number = the_number + tens[(num/10).to_i - 1] + ' ' + ones[(num%10).to_i - 1]
		end
		return the_number
	end

	def english(with_and = false)
		num = self
		left = num
		current = 0
		the_number = ''
		large_units = [" trillion "," billion "," million "," thousand ",""]
		for i in 0..4
			power_index = 3*(4-i)
			if left.to_s.length > power_index
				current = (left / (10**power_index)).to_i
				left -= current*(10**power_index)
				if with_and == true
					the_number += (current.small_english_number(true) + large_units[i])
				else
					the_number += (current.small_english_number + large_units[i])
				end
				the_number += 'and ' if (with_and == true && i != 4)
			end
		end
		return the_number
	end

  def english_years
    self == 1 ? self.english + ' year' : self.english + ' years'
  end

  def english_times
    return ' ' if self == 1
    return 'twice ' if self == 2
    return self.english + ' times ' if self > 2
  end

end

# arr = (1..100).to_a
# arr.each
