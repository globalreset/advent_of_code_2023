
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

class Grid
  @grid = {}


  def initialize
     @grid = {}
  end

  def grid
     return @grid
  end

  def getXRange
     return (@grid.keys.min)..(@grid.keys.max)
  end

  def getYRange
     yVals = @grid.values.map{|p|p.keys}.flatten
     return (yVals.min)..(yVals.max) if(yVals.size>0)
  end

  def setPoint(x,y,value)
     @grid[x] ||= {}
     @grid[x][y] = value
  end

  def getPoint(x,y)
     @grid[x][y] if(@grid[x])
  end


  def setRow(y, values, xRange=nil)
     if(xRange==nil)
        xRange = 0...values.size
     end
     xRange.each { |x| setPoint(x,y,values[x]) }
  end

  def setCol(x, values, yRange=nil)
     if(yRange==nil)
        yRange = 0...values.size
     end
     yRange.each { |y| setPoint(x,y,values[y]) }
  end

  def getRow(y)
     minX = @grid.keys.min
     maxX = @grid.keys.max
     (minX..maxX).to_a.map{ |x| @grid[x] && @grid[x][y] }
  end

  def getCol(x)
     yVals = @grid.values.map {|g|g.keys}.flatten
     minY = yVals.min
     maxY = yVals.max
     (minY..maxY).to_a.map{ |y| @grid[x][y] }
  end

  # returns 2 dimensional array of values
  # handy for easier slicing
  # can be any window on the existing grid
  def getSimpleGrid(xRange=nil, yRange=nil)
     if(xRange==nil)
        minX = @grid.keys.min
        maxX = @grid.keys.max
        xRange = minX..maxX
     end
     if(yRange==nil)
        yVals = @grid.values.map {|g|g.keys}.flatten
        minY = yVals.min
        maxY = yVals.max
        yRange = minY..maxY
     end
     simpleGrid = []
     xRange.each { |x|
        simpleGrid << []
        yRange.each { |y|
           simpleGrid[-1] << @grid[x][y]
        }
     }
     return simpleGrid
  end

  def [](x,y)
     getPoint(x,y)
  end

  def []=(x,y,value)
     setPoint(x,y,value)
  end

  def setPoints(points,value)
     points.each{|x,y| setPoint(x,y,value)}
  end
  def getPoints(points,value)
     points.map{|x,y| getPoint(x,y)}
  end

  def allCoords()
     points = []
     grid.keys.each { |x|
        grid[x].keys.each { |y|
           points << [x,y] if(grid[x][y]!=nil)
        }
     }
     points
  end

  #helper function for calculating all the points along a line
  def getLine(x1,y1,x2,y2)
     lineBetween = []
     dx = x2 - x1
     dy = y2 - y1
     if(dx == 0)
        (dy.abs+1).times { |i|
           lineBetween << [x1, y1+(dy/dy.abs)*i]
        }
     elsif(dy == 0)
        (dx.abs+1).times { |i|
           lineBetween << [x1+(dx/dx.abs)*i, y1]
        }
     else
        slope = dy/dx
        (dx.abs+1).times { |i|
           lineBetween << [x1+(dx/dx.abs)*i, y1+slope*i*(dy/dy.abs)]
        }
     end
     return lineBetween
  end

  # print defaults to 0,0 in top left, x=col, y=row
  # returns array of strings so it can easily be reversed
  # for either axis
  def to_s(unassigned=".", border="+")
     rows = []
     minX = @grid.keys.min
     maxX = @grid.keys.max
     yVals = @grid.values.map {|g|g.keys}.flatten
     minY = 0#yVals.min
     maxY = yVals.max

     rows << border*(maxX-minX+1+2)
     (minY..maxY).to_a.each { |y|
        line = ""
        (minX..maxX).to_a.each { |x|
           if(@grid.keys.include?(x) && @grid[x].keys.include?(y) && @grid[x][y]!=nil)
              line += "#{@grid[x][y]}"
           else
              line += unassigned
           end
        }
        rows << border + line + border
     }
     rows << border*(maxX-minX+1+2)
     return rows
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
