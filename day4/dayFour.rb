#!/bin/env ruby

require "set"

inputList = IO.readlines("day4/dayFourInput.txt").map(&:chomp)

matchCnt = inputList.map { |row|
   row.split(": ")[1].split(" | ").map { |num| Set.new(num.split(" ").map(&:to_i)) }.reduce(:&).size
}
puts matchCnt.select { |i| i > 0 }.map { |i| 1 << (i-1) }.sum

copies = Array.new(inputList.size(), 1)
matchCnt.each_with_index{ |cnt, i|
   cnt.times { |di|
      copies[i+di+1] += copies[i] if(i+di+1<copies.size)
   }
}
puts copies.sum
