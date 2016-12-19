class Array
  def collect_move
    return [] if length == 0
    collected_elements = []
    index = 0
    loop do
      if yield(self[index])
        collected_elements << delete_at(index)
        return collected_elements if index == length
      else
        return collected_elements if index == length - 1
        index += 1
      end
    end
  end
  #
  # def sort_multiplication_division_steps
  #   division_steps = self.collect_move_if{|step| step.operation == :divide}._sort_by_value
  #   multiplication_steps = self._sort_by_value
  #   multiplication_steps + division_steps
  # end
  #
  # def _sort_by_value
  #   number_of_swaps = 0
  #   for x in 0...(self.length - 1)
  #       if  self[x].value > self[x+1].value
  #         self[x],self[x+1] = self[x+1],self[x]
  #         number_of_swaps += 1
  #       end
  #   end
  #   return number_of_swaps == 0 ? self : self._sort_by_value
  # end
end
