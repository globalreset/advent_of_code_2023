# frozen_string_literal: true

module Year2023
  class Day10 < Solution
    def getLoop
      y = data.find_index do |row|
        row.index('S')
      end
      x = data[y].index('S')

      visited = [[y,x]].to_set

      nextItems = []
      # originally started 2 directions at once and counted steps to meet in the middle
      # but shoelace wants all vertices in order, so change to launche one search node
      if( ['F','|','7'].include?(data[y-1][x]))
        nextItems << [ [y-1, x], [-1,0], 1 ]
      elsif( ['L','|','J'].include?(data[y+1][x]))
        nextItems << [ [y+1, x], [1,0], 1 ]
      elsif( ['L','-','F'].include?(data[y][x-1]))
        nextItems << [ [y, x-1], [0,-1], 1 ]
      elsif( ['7','-','J'].include?(data[y][x+1]))
        nextItems << [ [y, x+1], [0,1], 1 ]
      end

      until nextItems.empty?
        curr, vector = nextItems.shift
        visited << curr
        case(data[curr[0]][curr[1]])
        when '-', '|' # vector stays the same
        when 'F', 'J' then vector = [-1*vector[1], -1*vector[0]]
        when 'L', '7' then vector = [vector[1], vector[0]]
        end
        if(!visited.include?([curr[0]+vector[0], curr[1]+vector[1]]))
          nextItems.push [ [curr[0] + vector[0], curr[1] + vector[1]], vector ]
        end
      end
      visited
    end

    def part_1
      getLoop.size/2
    end

    # https://en.wikipedia.org/wiki/Shoelace_formula
    # area inside a polygon given by the following product/sum of all vertices:
    # A = 1/2*(x0*y1 - x1*y0 + .... x999*y1000 - x1000*y999)
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

    def part_2
      visited = getLoop.to_a

      # my original solution, before I discovered shoelace+pick's
      #data.map.with_index { |row,y|
      #  parity = 0
      #  row.chars.map.with_index { |c, x|
      #    if(visited.keys.include?([y,x]))
      #      parity ^= 1 if ['L','J','|','S'].include?(c)
      #      0
      #    else
      #      parity
      #    end
      #  }.sum
      #}.sum

      vertices = []
      visited.size.times { |i|
        y,x = visited[i]
        vertices << [y,x] if ([?F,?7,?L,?J].include?(data[y].chars[x]))
      }
      picks_theorem_interior(shoelace_formula(vertices), visited.size).to_i
    end

  end
end
