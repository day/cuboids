require 'cuboid'

# Aiming for full coverage here
describe Cuboid do

  # TODO: Consider changing these to FactoryGirl
  let(:our_cuboid) { Cuboid.new([0,0,0], [2,4,6]) }
  let(:cube_to_the_right) { Cuboid.new([2,0,0], [3,3,3], is_container: true ) }
  let(:cube_above) { Cuboid.new([0,4,0], [3,3,3], is_container: true ) }
  let(:cube_that_intersects) { Cuboid.new([1,0,0], [3,3,3]) }
  let(:cube_that_contains) { Cuboid.new([0,0,0], [6,6,6], is_container: true ) }
  let(:cube_somewhere_else) { Cuboid.new([9,9,9], [6,6,6], is_container: true) }
  let(:identical_cuboid) { Cuboid.new([0,0,0], [2,4,6], is_container: true) }
  
  context 'a freshly initialized cuboid' do
    it 'has the length we assigned' do
      expect(our_cuboid.length).to be 2
    end
    it 'has the width we assigned' do
      expect(our_cuboid.width).to be 4
    end
    it 'has the height we assigned' do
      expect(our_cuboid.height).to be 6
    end
    it 'has the eight vertices we expect' do
      expect(our_cuboid.vertices).to eq [[0,0,0], [2,0,0], [2,4,0], [0,4,0], [0,4,6], [0,0,6], [2,0,6], [2,4,6]]
    end
  end

  context 'the move_to! method' do
    it 'changes the origin in the simple happy case' do
      expect(our_cuboid.move_to!([1,2,3]).vertices[0]).to eq [1,2,3]
    end
  end

  context 'the intersects? method' do
    it 'returns true when the cuboids INTERSECT' do
      expect(our_cuboid.intersects?(cube_that_intersects)).to be true
    end
    it 'returns true when the cuboids are IDENTICAL (100% intersection)' do
      expect(our_cuboid.intersects?(identical_cuboid)).to be true
    end
    it 'returns true when one of the cuboids is MOVED into intersection' do
      expect(our_cuboid.move_to!([1,0,0]).intersects?(cube_to_the_right)).to be true
    end
    it 'returns false when the cuboids DO NOT intersect (other is to the right)' do
      expect(our_cuboid.intersects?(cube_to_the_right)).to be false
    end
    it 'returns false when the cuboids DO NOT intersect (other is above)' do
      expect(our_cuboid.intersects?(cube_above)).to be false
    end
  end

  context 'the within? method' do
    it 'returns true when the cuboid is WITHIN the other' do
      expect(our_cuboid.within?(cube_that_contains)).to be true
    end
    it 'returns true when the cuboids are IDENTICAL (100% filling the other)' do
      expect(our_cuboid.within?(identical_cuboid)).to be true
    end
    it 'returns true when the cuboid is MOVED into the other' do
      expect(our_cuboid.move_to!([13,11,9]).within?(cube_somewhere_else)).to be true
    end
    it 'returns false when the cuboid is OUTSIDE (other is to the right)' do
      expect(our_cuboid.within?(cube_to_the_right)).to be false
    end
    it 'returns false when the the cuboid is OUTSIDE (other is above)' do
      expect(our_cuboid.within?(cube_above)).to be false
    end
  end

  # TODO: Refactor this spec to account for the container when we have one
  context 'the rotate! method' do
    context 'changes the dimensions and thus the vertices' do
      it 'when rotating around the x-axis' do
        expect(our_cuboid.rotate!(:x).vertices).to eq [[0,0,0], [2,0,0], [2,6,0], [0,6,0], [0,6,4], [0,0,4], [2,0,4], [2,6,4]]
      end
      it 'when rotating around the y-axis' do
        expect(our_cuboid.rotate!(:y).vertices).to eq [[0,0,0], [6,0,0], [6,4,0], [0,4,0], [0,4,2], [0,0,2], [6,0,2], [6,4,2]]
      end
      it 'when rotating around the z-axis' do
        expect(our_cuboid.rotate!(:z).vertices).to eq [[0,0,0], [4,0,0], [4,2,0], [0,2,0], [0,2,6], [0,0,6], [4,0,6], [4,2,6]]
      end
    end
  end

end
