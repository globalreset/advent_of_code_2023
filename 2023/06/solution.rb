module Year2023
  class Day06 < Solution

    def part_1
      time, dist = data.map{|l| l.split()[1..].map(&:to_i)}
      time.zip(dist).reduce(1) { |winCnt, (time, dist)| 
        winCnt *= (0..time).reduce(0) { |acc, t| 
          acc + (((time-t)*t > dist)?1:0)
        }
      }
    end

    def part_2
      time, dist = data.map{|l| l.split()[1..].join.to_i}
      (0..time).reduce(0) { |acc, t| 
        acc + (((time-t)*t > dist)?1:0)
      }
    end

  end
end
