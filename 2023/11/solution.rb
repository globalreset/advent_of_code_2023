# frozen_string_literal: true
module Year2023
  class Day11 < Solution
    # @input is available if you need the raw data input
    # Call `data` to access either an array of the parsed data, or a single record for a 1-line input file

    def manhattan (a, b)
      (b[0] - a[0]).abs + (b[1] - a[1]).abs
    end

    def part_1
      galaxies = Set.new
      data.map(&:chars).flat_map { |r|
        if(r.any? { |c| c=='#'})
          [r]
        else
          [r,r]
        end
      }.transpose.flat_map { |r|
        if(r.any? { |c| c=='#'})
          [r]
        else
          [r,r]
        end
      }.transpose.each_with_index { |r,y|
        r.each_with_index { |c,x|
          if(c=="#")
            galaxies << [y,x]
          end
        }
      }

      galaxies.to_a.combination(2).to_a.map { |a,b|
         manhattan(a,b)
      }.sum
    end

    def part_2
      dupRows = Set.new
      dupCols = Set.new
      galaxies = []
      data.map!(&:chars)
      data.each_with_index { |r,y|
        empty = true
        r.each_with_index { |c,x|
          if(c=='#')
            empty = false
            galaxies << [y,x]
          end
        }
        dupRows << y if(empty)
      }
      data.transpose.each_with_index { |r,x|
        dupCols << x if(r.none? { |c| c=='#'})
      }

      galaxies.combination(2).to_a.map { |a,b|
        ymin, ymax = [a[0], b[0]].minmax
        ySet = ((ymin+1)..ymax).to_set
        xmin, xmax = [a[1], b[1]].minmax
        xSet = ((xmin+1)..xmax).to_set

        ySet.size + (ySet & dupRows).size*999_999 + xSet.size + (xSet & dupCols).size*999_999
      }.sum
    end

  end
end
