require_relative '../enumerable'

describe Enumerable do
    arr = [3, 4, 7, 1, 2, 8]
    highest_num = 8
    my_hash = {min: 2, max: 5}
    
    describe '#my_each' do
        it 'Adding 1 to each array item' do
          array = []
          [1, 2, 3].my_each { |x| array.push(x + 1) }
          expect(array).to eql([2, 3, 4])
        end
    
        it 'my_each iteration testing with no block' do
          expect(%w(one two three).my_each).to be_an Enumerator
        end
    
        it 'my_each when self is a hash' do
          expect(my_hash.each { |key, value| "k: #{key}, v: #{value}" }).to eql({:min=>2, :max=>5})
        end
      end 
    end