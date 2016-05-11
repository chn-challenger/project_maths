require './models/evaluate'

describe Evaluate do

  let(:dummy_class){(Class.new{include Evaluate}).new}
  let(:first_step){double(:first_step,val:11)}
  let(:left_add){double(:left_add,val:5,ops: :add,dir: :lft)}
  let(:right_add){double(:right_add,val:5,ops: :add,dir: :rgt)}
  let(:left_subtract){double(:left_subtract,val:25,ops: :sbt,dir: :lft)}
  let(:right_subtract){double(:right_subtract,val:8,ops: :sbt,dir: :rgt)}
  let(:left_multiply){double(:left_multiply,val:3,ops: :mtp,dir: :lft)}
  let(:right_multiply){double(:right_multiply,val:3,ops: :mtp,dir: :rgt)}
  let(:left_divide){double(:left_divide,val:33,ops: :div,dir: :lft)}
  let(:right_divide){double(:right_divide,val:1,ops: :div,dir: :rgt)}

  describe '#evaluate' do
    it 'can evaluate a left addition' do
      expect(dummy_class.evaluate([first_step,left_add])).to eq 16
    end

    it 'can evaluate a right addition' do
      expect(dummy_class.evaluate([first_step,right_add])).to eq 16
    end

    it 'can evaluate a left subtraction' do
      expect(dummy_class.evaluate([first_step,left_subtract])).to eq 14
    end

    it 'can evaluate a right subtraction' do
      expect(dummy_class.evaluate([first_step,right_subtract])).to eq 3
    end

    it 'can evaluate a left multiplication' do
      expect(dummy_class.evaluate([first_step,left_multiply])).to eq 33
    end

    it 'can evaluate a right multiplication' do
      expect(dummy_class.evaluate([first_step,right_multiply])).to eq 33
    end

    it 'can evaluate a left division' do
      expect(dummy_class.evaluate([first_step,left_divide])).to eq 3
    end

    it 'can evaluate a right division' do
      expect(dummy_class.evaluate([first_step,right_divide])).to eq 11
    end

    it 'can evaluate multi-step expression' do
      expect(dummy_class.evaluate([first_step,right_add,right_multiply,left_subtract])).to eq -23
    end
  end

end
