
# find the min/max of 2 numbers and create a range from them
def getRange( a, b )
   rMin, rMax = [a,b].minmax
   rMin..rMax
end

# Search a string for instances of a char, return an array of indices
def getIndices( str, char)
   str = str.chars if(str.is_a?(String))
   str.map.with_index{[_1,_2]}.select{ _1==char }.map { _2 }
end

class Hash
  # lets you use 'myHash.whatever = x' as a shorthand for 'myHash["whatever"] = x'
  def method_missing(sym,*args)
    if(sym[-1]=="=")
      self.store(sym[0...-1].to_sym, args[0])
    else
      self.fetch(sym.to_sym)
    end
  end
end


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
