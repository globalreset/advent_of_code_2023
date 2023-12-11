Point3D = Struct.new(:x, :y, :z)
class Cuboid
  def initialize(state, corner1, corner2)
    @state = state
    @c1 = corner1
    @c2 = corner2
  end

  def state
    return @state
  end
  def state=(s)
    @state = s
  end

  def c1
    @c1
  end
  def c2
    @c2
  end

  def getVolume
    return (@c2.x - @c1.x)*(@c2.y - @c1.y)*(@c2.z - @c1.z)
  end

  def isValid
    return (@c2.x > @c1.x)&&(@c2.y > @c1.y)&&(@c2.z > @c1.z)
  end

  def getOverlap(cube)
    overlap = Cuboid.new(
       cube.state,
       Point3D.new([@c1.x, cube.c1.x].max,
                   [@c1.y, cube.c1.y].max,
                   [@c1.z, cube.c1.z].max),
       Point3D.new([@c2.x, cube.c2.x].min,
                   [@c2.y, cube.c2.y].min,
                   [@c2.z, cube.c2.z].min)
    )
    if(overlap.isValid)
       return overlap
    else
       return nil
    end
  end

  def toSet
    points = []
    (c1.x..c2.x).each { |x|
      (c1.y..c2.y).each { |y|
        (c1.z..c2.z).each { |z|
           points << [x,y,7]
        }
      }
    }
    return points.to_set
  end
end
