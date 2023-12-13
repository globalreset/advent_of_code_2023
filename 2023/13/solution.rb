# frozen_string_literal: true
module Year2023
  class Day13 < Solution

    def find_reflection(tile, allowed=0)
      tile = tile.map { _1.join.gsub("#", "1").gsub(".", "0").to_i(2) }
      (0..(tile.size-2)).find { |h|
        space_on_right = [h, tile.size - h - 2].min + 1
        space_on_left = [h, space_on_right-1].min
        left = (h-space_on_left)..(h)
        right = (h+1)..(h+space_on_right)
        pairs_xored = tile[left].zip(tile[right].reverse).map { _1 ^ _2}.sum
        pairs_xored.to_s(2).count('1') == allowed
      }
    end

    def part_1
      data.slice_when { _1.size==0 }
          .map { |tile| tile.reject(&:empty?).map(&:chars) }
          .sum { |tile|
        h_idx = find_reflection(tile)
        if(h_idx==nil)
          find_reflection(tile.transpose) + 1
        else
          (h_idx+1)*100
        end
      }
    end

    def part_2
      data.slice_when { _1.size==0 }
          .map { |tile| tile.reject(&:empty?).map(&:chars) }
          .sum { |tile|
        h_idx = find_reflection(tile, 1)
        if(h_idx==nil)
          find_reflection(tile.transpose, 1) + 1
        else
          (h_idx+1)*100
        end
      }
    end

  end
end
