# frozen_string_literal: true
module Year2023
  class Day15 < Solution
    def local_hash(str)
      str.chars.reduce(0) { |acc, c| ((acc + c.ord)*17) & 0xFF }
    end

    def part_1
       data.split(",").sum { local_hash(_1) }
    end

    def part_2
      box = {}
      data.split(",").each { |op|
        if(op =~ /(\w+)(=|-)(\d?)/)
          h = local_hash(Regexp.last_match(1))
          box[h] ||= {}
          # Ruby hashtables preserve insertion order
          case(Regexp.last_match(2))
          when ?=
            box[h][Regexp.last_match(1)] = Regexp.last_match(3)
          when ?-
            box[h].delete(Regexp.last_match(1))
          end
        end
      }
      box.keys.sum { |k|
        (box[k] && box[k].size>0) ?
          (k.to_i+1) * (box[k].map.with_index { |l, idx| (idx+1)*(l[1].to_i) }.sum) : 0
      }
    end

  end
end
