require 'cuboid'

# Aiming for full coverage here
describe Cuboid do

  # TODO: Consider changing these to FactoryGirl
  let(:our_cuboid) { Cuboid.new([0,0,0], [2,4,6]) }
  let(:cube_to_the_right) { Cuboid.new([2,0,0], [3,3,3]) }
  let(:cube_above) { Cuboid.new([0,4,0], [3,3,3]) }
  let(:cube_that_intersects) { Cuboid.new([1,0,0], [3,3,3]) }
  let(:identical_cuboid) { Cuboid.new([0,0,0], [2,4,6]) }
  
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

  # TODO: Add complete spec for rotate! method
  context 'the as-yet-nonexistent rotate! method' do
    it 'raises the expected error' do
      expect {our_cuboid.rotate!(0,90)}.to raise_error('method rotate not yet defined')
    end
  end

end
