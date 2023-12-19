
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

module Util
  class << self

    # calculate the hamming distance between 2 numbers
    def hamming_distance(x, y)
      (x ^ y).to_s(2).count('1')
    end

    # find the min/max of 2 numbers and create a range from them
    def get_range( a, b )
       rMin, rMax = [a,b].minmax
       rMin..rMax
    end

    # Search a string for instances of a char, return an array of indices
    def get_indices( str, char )
       str = str.chars if(str.is_a?(String))
       str.map.with_index{[_1,_2]}.select{ |c,i| c==char }.map { |c,i| i }
    end

    # get all direct neighbor coordinates (non-diagonal) from a 2/3/4-dimensional point
    def get_neighbors(dimensions = 2, x = 0, y = 0, z = 0, w = 0)
      neighbors = []
      (-1..1).each do |dx|
        (-1..1).each do |dy|
          if(dimensions==2)
            next if dx == 0 && dy == 0
            neighbors << [x + dx, y + dy]
          else
            (-1..1).each do |dz|
              if(dimensions==3)
                 next if dx == 0 && dy == 0 && dz == 0
                 neighbors << [x + dx, y + dy, z + dz]
              else
                (-1..1).each do |dw|
                  next if dx == 0 && dy == 0 && dz == 0 && dw ==0
                  neighbors << [x + dx, y + dy, z + dz, w + dw]
                end
              end
            end
          end
        end
      end
      neighbors
    end

    # area inside a polygon given by the following product/sum of all vertices:
    # A = 1/2*(x0*y1 - x1*y0 + .... x999*y1000 - x1000*y999)
    # https://en.wikipedia.org/wiki/Shoelace_formula
    def shoelace_formula(vertices)
      sum1 = 0
      sum2 = 0

      vertices.each_with_index do |(x, y), i|
        next_vertex = vertices[(i + 1) % vertices.size]
        sum1 += x * next_vertex[1]
        sum2 += y * next_vertex[0]
      end

      (sum1 - sum2).abs / 2.0
    end

    # gives number of integer points within a simple polygon.
    # Normally gives area based on interior integer points and
    # boundary points, but can solve for interior points if
    # we have the other 2 arguments
    def picks_theorem_interior(area, boundary_length)
      #A = i + b/2 - 1
      area - boundary_length/2.0 + 1
    end
  end
end
