#!/bin/env ruby

inputList = IO.readlines("day2/dayTwoInput.txt").map(&:chomp)

games = inputList.map { |g|
   idStr, result = g.split(":")
   results = result.split("; ").map{ |r| r.split(", ").map { |c| 
         c = c.split(" "); 
         [c[1].to_sym, c[0].to_i] 
      }.to_h 
   }
   [idStr.split(" ")[1].to_i, results]
}

actual = { :red => 12, :green => 13, :blue => 14 }

id = []
games.each { |g|
   id << g[0] if(actual.all? { |color, cnt| g[1].all? { |r| (r[color] || 0) <= cnt } })
}
p id.sum

power = []
games.each { |g|
   power << []
   actual.each { |color, cnt|
      cnt = -1
      g[1].each { |r| cnt = r[color] if(r[color] != nil && (cnt<0 || cnt<r[color])) }
      power[-1] << cnt
   }
}
p power.map { |g| g.reduce(1, :*) }.sum




