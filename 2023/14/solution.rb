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

    def cycle(plat)
      n = roll_north(plat)
      w = roll_north(rotate_clockwise(n))
      s = roll_north(rotate_clockwise(w))
      e = roll_north(rotate_clockwise(s))
      rotate_clockwise(e)
    end

    def part_1
      plat = data.map(&:chars)

      roll_north(plat)

      plat.reverse.map.with_index { |row, i| row.count(?O)*(i+1) }.sum
    end

    def part_2
      plat = data.map(&:chars)

      # dropped over 10 seconds off my routine by adding this cache. It was added after
      # I submitted my answer, but wanted to make sure I understood methods that used
      # the cycle count. Basically record all the states and the cycle count they
      # were executed on, then find the number of steps between a repeat. The remainder
      # of those cycles into 1000 gives you the lookup for the final state.
      cache = {}
      cycle_end = (0..).find { |i|
        cache[plat] = i
        plat = cycle(plat)
        cache.key?(plat)
      } + 1 # plus 1 because it would've been recorded on the next step
      remainder = (1000 - cycle_end) % (cycle_end - cache[plat])

      cache.key(cache[plat] + remainder).reverse.map.with_index { |row, i| row.count(?O)*(i+1) }.sum
    end

  end
end
