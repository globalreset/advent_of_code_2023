module Year2023
  class Day08 < Solution
    def part_1
      inst = data[0].chars
      tree = data[2..].map { |line| line.scan(/\w{3}/) }.map { |n, l, r| [n, { 'L' => l, 'R' => r }] }.to_h
      curr = 'AAA'
      (0..).find { |i| (curr = tree[curr][ inst[i % inst.size] ]) =~ /ZZZ/ } + 1
    end

    def part_2
      inst = data[0].chars
      tree = data[2..].map { |line| line.scan(/\w{3}/) }.map { |n, l, r| [n, { 'L' => l, 'R' => r }] }.to_h
      tree.keys.select { |k| k =~ /A$/ }.map do |curr|
        # pattern is cyclical, so for every starting key figure out how many full runs through
        # the instructions it takes to get to the end. Then find the lcm for all the step counts.
        (0..).find { |i| (curr = tree[curr][ inst[i % inst.size] ]) =~ /Z$/ } + 1
      end.reduce(1) { |acc, steps| acc.lcm(steps) }
    end
  end
end
