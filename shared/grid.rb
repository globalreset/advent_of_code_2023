require 'matrix'
require 'set'

require 'pp'

class WalledGrid
  attr_reader :width
  attr_reader :height

  def initialize(width, height, walls = nil)
    @width = width
    @height = height
    @walls = Set.new
    self.walls = walls if walls
  end

  def in_bounds?(pos)
    x, y = pos.to_a
    x >= 0 && x < width && y >= 0 && y < height
  end

  def passable?(pos)
    !@walls.include? pos
  end

  def add_wall(pos)
    @walls.add pos
  end

  def walls=(positions)
    positions.each { add_wall _1 }
  end

  def neighbors(pos)
    x, y = pos.to_a
    adjacent = [[x + 1, y], [x - 1, y], [x, y - 1], [x, y + 1]].map { Vector[*_1] }
    adjacent.reverse! if (x + y) % 2 == 0
    adjacent.select { in_bounds?(_1) && passable?(_1) }
  end

  def draw(**opts)
    puts "___" * width
    (0...height).each do |y|
      (0...width).each do |x|
        print draw_tile(Vector[x, y], opts)
      end
      puts
    end
    puts "~~~" * width
  end

  protected

  def draw_tile(pos, opts)
    return '###' unless passable?(pos)
    return ' Z ' if opts.key?(:goal) && opts[:goal] == pos
    return ' A ' if opts.key?(:start) && opts[:start] == pos
    return ' @ ' if opts.key?(:path) && opts[:path].include?(pos)
    if opts.key?(:point_to) && !opts[:point_to][pos].nil?
      x1, y1 = pos.to_a
      x2, y2 = opts[:point_to][pos].to_a
      return ' ↑ ' if y2 == y1 - 1
      return ' ↓ ' if y2 == y1 + 1
      return ' ← ' if x2 == x1 - 1
      return ' → ' if x2 == x1 + 1
    end
    return sprintf(' %-2d', opts[:number][pos]) if opts.key?(:number) && opts[:number].key?(pos)
    ' . '
  end
end

class WalledGridWithWeights < Grid
  def initialize(width, height, walls = nil)
    super(width, height, walls)
    @weights = Hash.new(1)
  end

  def add_weight(pos, weight)
    @weights[pos] = weight
  end

  def cost(source, destination)
    @weights[destination]
  end

  protected

  def draw_tile(pos, opts)
    return sprintf(' %-2d', @weights[pos]) if opts[:weights]
    super
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
        minX, maxX = @grid.keys.minmax
        xRange = minX..maxX
     end
     if(yRange==nil)
        yVals = @grid.values.map {|g|g.keys}.flatten
        minY, maxY = yVals.minmax
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
