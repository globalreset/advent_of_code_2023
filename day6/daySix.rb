#!/bin/env ruby

inputList = IO.readlines("day6/daySixInput.txt").map(&:chomp)

time, dist = inputList.map{|l| l.split()[1..].map(&:to_i)}
puts time.zip(dist).reduce(1) { |winCnt, (time, dist)| 
   winCnt *= (0..time).reduce(0) { |acc, t| 
      acc + (((time-t)*t > dist)?1:0)
   }
}

time, dist = inputList.map{|l| l.split()[1..].join.to_i}
puts (0..time).reduce(0) { |acc, t| 
        acc + (((time-t)*t > dist)?1:0)
     }
