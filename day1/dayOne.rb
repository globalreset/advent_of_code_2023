#!/bin/env ruby

inputList = IO.readlines("day1/dayOneInput.txt").map(&:chomp)

puts inputList.map { |i| i.scan(/\d/) }.map { |i| ((i[0]||"0") + (i[-1]||"")).to_i }.sum

words = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
puts inputList.map { |i|
   digits = []
   i.size().times { |idx|
      if(i[idx] =~ /\d/)
         digits << i[idx]
      else
         words.each_with_index { |w, wi|
            if(i.index(w, idx)==idx)
               p w
               digits << (wi + 1).to_s
            end
         }
      end
   }
}.map { |i| ((i[0]||"0") + (i[-1]||"")).to_i }.sum
