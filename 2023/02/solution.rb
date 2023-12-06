# frozen_string_literal: true
module Year2023
  class Day02 < Solution

    def initialize(input)
      @input = input
      @actual = { :red => 12, :green => 13, :blue => 14 }
    end

    def part_1
      data.select { |g| 
         @actual.all? { |color, cnt| g[1].all? { |r| (r[color] || 0) <= cnt } }
      }.map(&:first).sum
    end

    def part_2
      data.map { |g|
         @actual.reduce([]) { |pwr, (color, cnt)|
            pwr << g[1].select{ |r| r[color] }.map { |r| r[color] }.max
         }.reduce(1, :*)
      }.sum
    end

    private
      def process_input(line)
        idStr, result = line.split(":")
        results = result.split("; ").map{ |r| r.split(", ").map { |c| 
              [c.split(" ")].map{ |a,b| [b.to_sym, a.to_i] }.shift
           }.to_h 
        }
        [idStr.split(" ")[1].to_i, results]
      end

  end
end
