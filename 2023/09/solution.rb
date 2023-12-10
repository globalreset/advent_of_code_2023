module Year2023
  class Day09 < Solution
    def getNext(arr)
      if arr.all? { |a| a == 0 }
        0
      else
        arr.last + getNext(arr.each_cons(2).to_a.map { |a, b| b - a })
      end
    end

    def part_1
      data.map(&:split).map { |a| a.map(&:to_i) }.map { |a| getNext(a) }.sum
    end

    def part_2
      data.map(&:split).map { |a| a.map(&:to_i) }.map { |a| getNext(a.reverse) }.sum
    end
  end
end
