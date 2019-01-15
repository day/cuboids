# Write code that represents 3D objects in space - to keep it real simple, only
# "rectangular cuboids."
class Cuboid

  # That way you could represent one by having an origin (z,y,x) and length,
  # width, height. Of course, you should be able to create (initialize) an
  # object at a certain origin, with a certain length/width/height.
  def initialize(origin, dimensions, is_container=false)
    # an array of three values: x, y, z (relative to origin of container)
    @origin = origin
    # an array of three values: x, y, z (length, width, height)
    @dimensions = dimensions
    # indicates the cuboid may contain other cuboids
    @is_container = is_container
  end

  def length
    # length = x = index 0
    @dimensions[0]
  end

  def width
    # width = y = index 1
    @dimensions[1]
  end

  def height
    # height = z = index 2
    @dimensions[2]
  end

  # You should also be able to move your object to a different origin.
  def move_to!(coordinates)
    @origin = coordinates
    self
  end


  # Additionally, you should be able to get a list of the vertices that represent
  # the cuboid (a total of 8 vertices).
  def vertices
    # These six translations are all we need
    x1 = @origin[0]
    x2 = x1 + self.length
    y1 = @origin[1]
    y2 = y1 + self.width
    z1 = @origin[2]
    z2 = z1 + self.height
    # Define the eight vertices
    v1 = [x1, y1, z1] # from origin
    v2 = [x2, y1, z1] # add length
    v3 = [x2, y2, z1] # add width
    v4 = [x1, y2, z1] # subtract length
    v5 = [x1, y2, z2] # add height
    v6 = [x1, y1, z2] # subtract width
    v7 = [x2, y1, z2] # add length
    v8 = [x2, y2, z2] # add width
    # Return the vertices
    [v1, v2, v3, v4, v5, v6, v7, v8]
  end

  # Now here's the important part - write a method that tests whether or not 2
  # cuboids are overlapping. Note that we are allowing the cuboids to be immediately
  # adjacent with zero margin or padding in between.
  def intersects?(other)
    # Any of the following conditions means the cuboids DO NOT intersect, so we
    # negate the entire thing. This will return TRUE where the two cuboids intersect
    # each other and FALSE otherwise.
    !(
      self.vertices[0][0] >= other.vertices[7][0] ||
      self.vertices[0][1] >= other.vertices[7][1] ||
      self.vertices[0][2] >= other.vertices[7][2] ||
      self.vertices[7][0] <= other.vertices[0][0] ||
      self.vertices[7][1] <= other.vertices[0][1] ||
      self.vertices[7][2] <= other.vertices[0][2]
    )
  end

  # The "tricky" part about the rotation is that - imagine the origin is walled
  # - a rotation of an object that is up against a corner would also require the
  # object to shift if you are rotating the object around its origin. This restriction
  # exists because the objects are actually part of a bin packing algorithm - meaning
  # the objects are inside a box and can only exist within the walls of the outer
  # box.
  def is_container?
    @is_container
  end

  def within?(other)
    # All of the following conditions must be met for the cuboid to be WITHIN
    # the other. This will return TRUE where the cuboid is inside the other and
    # FALSE otherwise.
    (
      other.is_container? &&
      self.vertices[0][0] >= other.vertices[0][0] &&
      self.vertices[0][1] >= other.vertices[0][1] &&
      self.vertices[0][2] >= other.vertices[0][2] &&
      self.vertices[7][0] <= other.vertices[7][0] &&
      self.vertices[7][1] <= other.vertices[7][1] &&
      self.vertices[7][2] <= other.vertices[7][2]
    )
  end

  # Allow your objects to rotate (to keep it simple, only at 90 degree angles).
  # This version considers rotation to be swapping two dimensions and leaving
  # the origin in place. Phase two will be to consider the container.
  def rotate!(axis)
    # Rotation may change origin due to necessary shifting
    case axis
      when :x # x-axis = length = index 0
        # temp vars for the new dimensions
        new_z = @dimensions[1]
        new_y = @dimensions[2]
        # length stays the same
        @dimensions[1] = new_y
        @dimensions[2] = new_z
      when :y # y-axis = width = index 1
        # temp vars for the new dimensions
        new_z = @dimensions[0]
        new_x = @dimensions[2]
        # width stays the same
        @dimensions[0] = new_x
        @dimensions[2] = new_z
      when :z # z-axis = height = index 2
        # temp vars for the new dimensions
        new_y = @dimensions[0]
        new_x = @dimensions[1]
        # height stays the same
        @dimensions[0] = new_x
        @dimensions[1] = new_y
    end
    self
  end
end
