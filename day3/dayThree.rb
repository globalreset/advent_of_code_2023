#!/bin/env ruby

inputList = IO.readlines("day3/dayThreeInput.txt").map(&:chomp)

numIndices = inputList.map.with_index { |row, y|
   indices = []
   row.chars.map.with_index { |c, idx|
      idx if(c=~/\d/)
   }.compact.each { |idx|
      if(indices.empty? || indices[-1][-1] != idx-1)
         indices << [idx]
      else
         indices[-1] << idx
      end
   }
   indices
}

numPerY = {}
numbers = []
numIndices.each_with_index { |idxArr, y|
   idxArr.each { |indices|
      num = {}
      num[:coordinates] = Set.new(indices.map{ |x| [y, x] })
      num[:value] = indices.map { |i| inputList[y][i] }.join.to_i
      num[:neighbors] = Set.new
      (-1..1).each { |dy|
         (-1..1).each { |dx|
            indices.each { |x| 
               if(y+dy >= 0 && y+dy<inputList.size && x+dx >= 0 && x+dx < inputList[0].size)
                  if(!num[:coordinates].include?([dy+y, dx+x]))
                     num[:neighbors]<< [dy+y, dx+x]
                  end
               end
            }
         }
      }
      num[:neighborChars] = num[:neighbors].map { |y,x| inputList[y][x] }
      indices = []
      numbers << num
      (numPerY[y] ||= []) << num
   }
}

partNums = numbers.map{ |num|
   num if(num[:neighborChars].any? { |c| c !~ /[\d\.]/})
}.compact
p partNums.map{|n| n[:value]}.sum


gearRatioSum = 0 

inputList.each_with_index { |row, y|
   offset = 0
   while idx = row.index('*', offset)
      touching = Set.new([numPerY[y-1], numPerY[y], numPerY[y+1]].compact.flatten.select { |num| 
         num[:neighbors].include?([y,idx]) 
      })
      if(touching.size()==2)
         gearRatioSum += touching.map{ |num| num[:value] }.reduce(1, :*)
      end
      offset = idx + 1
   end
}

p gearRatioSum


