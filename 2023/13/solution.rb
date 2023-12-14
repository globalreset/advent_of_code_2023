# frozen_string_literal: true
module Year2023
  class Day13 < Solution

    # allowed is number of mismatched locations in the reflection
    def find_reflection(tile, allowed=0)
      tile = tile.map { _1.join.gsub("#", "1").gsub(".", "0").to_i(2) }
      (1..(tile.size-1)).find { |h|
        cnt = [h, tile.size - h].min
        left = (h-cnt)..(h-1)
        right = (h)..(h+cnt-1)
        tile[left].zip(tile[right].reverse).sum { Util.hamming_distance(_1,_2) } == allowed
      }
    end

    def part_1
      data.slice_when { _1.size==0 }.sum { |tile|
        # need chars for transpose to work
        tile = tile.reject(&:empty?).map(&:chars)
        find_reflection(tile.transpose) || 100*find_reflection(tile)
      }
    end

    def part_2
      data.slice_when { _1.size==0 }.sum { |tile|
        tile = tile.reject(&:empty?).map(&:chars)
        find_reflection(tile.transpose, 1) || 100*find_reflection(tile, 1)
      }
    end

  end
end
