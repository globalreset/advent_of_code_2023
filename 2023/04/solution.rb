module Year2023
  class Day04 < Solution

    def getMatchCnt 
      data.map { |row|
        row.split(": ")[1].split(" | ").map { |num| Set.new(num.split(" ").map(&:to_i)) }.reduce(:&).size
      }
    end

    def part_1
      getMatchCnt.select { |i| i > 0 }.map { |i| 1 << (i-1) }.sum
    end

    def part_2
      copies = Array.new(data.size(), 1)
      getMatchCnt.each_with_index{ |cnt, i|
         cnt.times { |di|
            copies[i+di+1] += copies[i] if(i+di+1<copies.size)
         }
      }
      copies.sum
    end
  end
end
