require './models/array_extension'

describe Array do
  describe '#collect_move' do
    it 'collects even integers and leave the odd ones' do
      array = [1,2,3,4,5,6,7,8]
      collected_elements = array.collect_move{|e| e%2 == 0}
      expect(array).to eq [1,3,5,7]
      expect(collected_elements).to eq [2,4,6,8]
    end

    it 'collect and move strings to the return array' do
      array = [1,'hello',2,'world',3,4]
      collected_elements = array.collect_move{|e| e.is_a?(String)}
      expect(array).to eq [1,2,3,4]
      expect(collected_elements).to eq ['hello','world']
    end

    it 'return empty array if invoked on an empty array' do
      array = []
      collected_elements = array.collect_move{|e| e.is_a?(String)}
      expect(array).to eq []
      expect(collected_elements).to eq []
    end
  end
  #
  # describe '#sort_multiplication_division_steps' do
  #   it 'sorts 2 multiplication steps' do
  #     steps = [EquationStep.new(:multiply,'y'),EquationStep.new(:multiply,'x')]
  #     sorted_steps = [EquationStep.new(:multiply,'x'),EquationStep.new(:multiply,'y')]
  #     expect(steps.sort_multiplication_division_steps).to eq sorted_steps
  #   end
  #
  #   it 'sorts 4 multiplication steps recursively' do
  #     steps = [EquationStep.new(:multiply,'y'),EquationStep.new(:multiply,'x'),
  #       EquationStep.new(:multiply,'c'),EquationStep.new(:multiply,'a')]
  #     sorted_steps = [EquationStep.new(:multiply,'a'),EquationStep.new(:multiply,'c'),
  #       EquationStep.new(:multiply,'x'),EquationStep.new(:multiply,'y'),]
  #     expect(steps.sort_multiplication_division_steps).to eq sorted_steps
  #   end
  #
  #   it 'sorts 4 division steps recursively' do
  #     steps = [EquationStep.new(:divide,'y'),EquationStep.new(:divide,'x'),
  #       EquationStep.new(:divide,'c'),EquationStep.new(:divide,'a')]
  #     sorted_steps = [EquationStep.new(:divide,'a'),EquationStep.new(:divide,'c'),
  #       EquationStep.new(:divide,'x'),EquationStep.new(:divide,'y'),]
  #     expect(steps.sort_multiplication_division_steps).to eq sorted_steps
  #   end
  #
  #   it 'sorts 2 multiplication and division steps' do
  #     steps = [EquationStep.new(:divide,'y'),EquationStep.new(:multiply,'x')]
  #     sorted_steps = [EquationStep.new(:multiply,'x'),EquationStep.new(:divide,'y')]
  #     expect(steps.sort_multiplication_division_steps).to eq sorted_steps
  #   end
  #
  #   it 'sorts many multiplication and division steps' do
  #     steps = [EquationStep.new(:divide,'y'),EquationStep.new(:multiply,'x'),
  #       EquationStep.new(:divide,'a'),EquationStep.new(:multiply,'z'),
  #       EquationStep.new(:divide,'d'),EquationStep.new(:multiply,'f')]
  #     sorted_steps = [EquationStep.new(:multiply,'f'),EquationStep.new(:multiply,'x'),
  #       EquationStep.new(:multiply,'z'),EquationStep.new(:divide,'a'),
  #       EquationStep.new(:divide,'d'),EquationStep.new(:divide,'y')]
  #     expect(steps.sort_multiplication_division_steps).to eq sorted_steps
  #   end
  #
  # end

end
