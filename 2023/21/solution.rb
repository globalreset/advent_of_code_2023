module Year2023
  class Day21 < Solution
    def part_1
      steps = 64
      xR = 0...data[0].size
      yR = 0...data.size
      reachable = [[data[0].size/2, data.size/2]].to_set

      steps.times {
        new_set = Set.new
        reachable.each { |s|
          [ [0,1],[1,0],[0,-1],[-1,0] ].each { |d|
            n = [s[0] + d[0], s[1] + d[1]]
            if xR.include?(n[0]) && yR.include?(n[1]) && data[n[1]][n[0]] != ?#
              new_set << n
            end
          }
        }
        reachable = new_set
      }

      reachable.size
    end

    def part_2
      steps = 26501365
      reachable = [[data[0].size/2, data.size/2]].to_set
      totals = []

      (1..).each { |i|
        new_set = Set.new
        reachable.each { |s|
          [ [0,1],[1,0],[0,-1],[-1,0] ].each { |d|
            n = [s[0] + d[0], s[1] + d[1]]
            if data[n[1] % data.length][n[0] % data[0].length] != ?#
              new_set << n
            end
          }
        }

        if i % data.size == steps % data.size
          totals << new_set.size
          break if totals.size==3
        end
        reachable = new_set
      }

      totals[0] +
        (totals[1] - totals[0])*(steps / data.size) +
        (totals[2] - 2*totals[1] + totals[0])*((steps / data.size) * ((steps / data.size) - 1) / 2)
    end

  end
end
