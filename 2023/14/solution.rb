# frozen_string_literal: true
module Year2023
  class Day14 < Solution
    def roll_north(platform)
      platform.transpose.map { |row|
        Util.get_indices(row, ?O).each { |i|
          (i-1).downto(0).each { |j|
            case(row[j])
            when ?. then row[j], row[j+1] = row[j+1], row[j]
            when ?# then break
            end
          }
        }
        row
      }.transpose
    end

    def rotate_clockwise(platform)
      platform.transpose.map(&:reverse)
    end

    def part_1
      plat = data.map(&:chars)

      roll_north(plat)

      plat.reverse.map.with_index { |row, i| row.join.scan(/O/).size*(i+1) }.sum
    end

    def part_2
      plat = data.map(&:chars)

      1000.times { |i|
        n = roll_north(plat)
        w = roll_north(rotate_clockwise(n))
        s = roll_north(rotate_clockwise(w))
        e = roll_north(rotate_clockwise(s))
        plat = rotate_clockwise(e)
      }

      plat.reverse.map.with_index { |row, i| row.join.scan(/O/).size*(i+1) }.sum
    end

  end
end
