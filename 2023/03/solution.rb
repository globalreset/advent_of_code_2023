module Year2023
  class Day03 < Solution
    # returns an array with 1 element for each row of the input.
    # each element is another array which is either empty or a
    # collection of hashes of each number found on the row
    def getNumbers
      data.map.with_index { |line, y|
        numPerY = []
        # find digits on each line
        line.chars.map.with_index { |c,idx| idx if(c=~/\d/) }
          # group consecutive digits
          .compact.slice_when { |i,j| i+1!=j }
          # map into a hash for each run of digits
          .map { |indices|
            num = {}
            coordinates = Set.new(indices.map{ |x| [y, x] })
            num[:value] = indices.map { |i| data[y][i] }.join.to_i
            num[:neighbors] = indices.reduce(Set.new) { |neighbors, x| 
              (-1..1).each { |dy|
                (-1..1).each { |dx|
                  if(y+dy >= 0 && y+dy<data.size && x+dx >= 0 && x+dx < data[0].size)
                    if(!coordinates.include?([dy+y, dx+x]))
                       neighbors << [dy+y, dx+x]
                    end
                  end
                }
              }
              neighbors
            }
            num[:neighborChars] = num[:neighbors].map { |y,x| data[y][x] }
            numPerY << num
          }
        numPerY
      }
    end

    def part_1
      getNumbers.flatten.map{ |num|
        num if(num[:neighborChars].any? { |c| c !~ /[\d\.]/})
      }.compact.map{|n| n[:value]}.sum
    end

    def part_2
      numbers = getNumbers()
      data.map.with_index { |line, y|
        offset = 0
        gearRatioSum = 0
        while idx = line.index('*', offset)
           touching = Set.new([numbers[y-1], numbers[y], numbers[y+1]].compact.flatten.select { |num| 
              num[:neighbors].include?([y,idx]) 
           })
           if(touching.size()==2)
              gearRatioSum += touching.map{ |num| num[:value] }.reduce(1, :*)
           end
           offset = idx + 1
        end
        gearRatioSum
      }.sum
    end

  end
end
