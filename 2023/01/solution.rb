# frozen_string_literal: true
module Year2023
  class Day01 < Solution
    def part_1
      return data.map { |i| i.scan(/\d/) }.map { |i| ((i[0]||"0") + (i[-1]||"")).to_i }.sum
    end

    def part_2
      words = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
      return data.map { |i|
         digits = []
         i.size().times { |idx|
            if(i[idx] =~ /\d/)
               digits << i[idx]
            else
               words.each_with_index { |w, wi|
                  if(i.index(w, idx)==idx)
                     digits << (wi + 1).to_s
                  end
               }
            end
         }
      }.map { |i| ((i[0]||"0") + (i[-1]||"")).to_i }.sum
    end
  end
end
