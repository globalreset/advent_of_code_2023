# frozen_string_literal: true

module Year2023
  class Day10 < Solution
    def getLoop
      y = data.find_index do |row|
        row.index('S')
      end
      x = data[y].index('S')

      visited = {[y,x] => 0}

      nextItems = []
      nextItems << [ [y-1, x], [-1,0], 1 ] if( ['F','|','7'].include?(data[y-1][x]))
      nextItems << [ [y+1, x], [1,0], 1 ] if( ['L','|','J'].include?(data[y+1][x]))
      nextItems << [ [y, x-1], [0,-1], 1 ] if( ['L','-','F'].include?(data[y][x-1]))
      nextItems << [ [y, x+1], [0,1], 1 ] if( ['7','-','J'].include?(data[y][x+1]))

      until nextItems.empty?
        curr, vector, steps = nextItems.shift
        visited[curr] = steps
        case(data[curr[0]][curr[1]])
        when '-', '|' # vector stays the same
        when 'F', 'J' then vector = [-1*vector[1], -1*vector[0]]
        when 'L', '7' then vector = [vector[1], vector[0]]
        end
        if(!visited.keys.include?([curr[0]+vector[0], curr[1]+vector[1]]))
          nextItems.push [ [curr[0] + vector[0], curr[1] + vector[1]], vector, steps + 1 ]
        end
      end
      visited
    end

    def part_1
      getLoop.values.max
    end

    def part_2
      visited = getLoop

      data.map.with_index { |row,y|
        parity = 0
        row.chars.map.with_index { |c, x|
          if(visited.keys.include?([y,x]))
            parity ^= 1 if ['L','J','|','S'].include?(c)
            0
          else
            parity
          end
        }.sum
      }.sum
    end

  end
end
