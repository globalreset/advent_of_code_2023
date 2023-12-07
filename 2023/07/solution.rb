# frozen_string_literal: true
module Year2023
  class Day07 < Solution
    def getHandRank(hand, jokersWild = false)
      charTally = hand.chars.tally
      countTally = charTally.values.tally
      if(jokersWild)
        numJokers = charTally.delete("J") || 0
        countTally = charTally.values.tally
        if(numJokers > 0)
          maxCount = countTally.keys.max || 0
          countTally[maxCount] -= 1 if(countTally[maxCount])
          countTally[maxCount+numJokers] = 1
        end
      end
      case 
      when (countTally[5]||0)>0    then 1
      when (countTally[4]||0)>0    then 2
      when (countTally[3]||0)>0 && 
           (countTally[2]||0)>0    then 3
      when (countTally[3]||0)>0    then 4
      when (countTally[2]||0) == 2 then 5
      when (countTally[2]||0)>0    then 6
      when (countTally[1]||0) == 5 then 7
      end
    end


    def part_1
      cardRank = "AKQJT98765432".chars
      data.map(&:split).sort_by { |hand, bid| 
        [getHandRank(hand), *hand.chars.map{|c| cardRank.index(c) }]
      }.reverse.map.with_index{ |(hand, bid), i| bid.to_i * (i+1)}.sum
    end

    def part_2
      cardRank = "AKQT98765432J".chars
      data.map(&:split).sort_by { |hand, bid| 
        [getHandRank(hand, true), *hand.chars.map{|c| cardRank.index(c) }]
      }.reverse.map.with_index{ |(hand, bid), i| bid.to_i * (i+1)}.sum
    end
  end
end
