# frozen_string_literal: true
module Year2023
  class Day17 < Solution
    # @input is available if you need the raw data input
    # Call `data` to access either an array of the parsed data, or a single record for a 1-line input file
    $tdata = [
      "2413432311323",
      "3215453535623",
      "3255245654254",
      "3446585845452",
      "4546657867536",
      "1438598798454",
      "4457876987766",
      "3637877979653",
      "4654967986887",
      "4564679986453",
      "1224686865563",
      "2546548887735",
      "4322674655533"
    ]
    require 'set'

    Node = Struct.new(:pos, :vec, :cnt)

    def get_neighbor(grid, pos, vec, cnt, steps)
      xR = 0...grid[0].size
      yR = 0...grid.size
      new_node = Node.new(pos, vec, cnt)
      new_cost = 0
      steps.times {
        new_node.pos = new_node.pos.zip(vec).map(&:sum)
        new_node.cnt += 1
        return nil unless (xR.include?(new_node.pos[0]) && yR.include?(new_node.pos[1]))
        new_cost += grid[new_node.pos[1]][new_node.pos[0]]
      }
      [new_node, new_cost]
    end

    def get_neighbors(grid, current, min_cnt, max_cnt)
      neighbors = []
      if(current.pos==[0,0])
        neighbors << get_neighbor(grid, [0,0], [1,0], 0, min_cnt)
        neighbors << get_neighbor(grid, [0,0], [0,1], 0, min_cnt)
      else
        # continue straight, 1 unit step
        if(current.cnt<max_cnt)
          neighbors << get_neighbor(grid, current.pos, current.vec, current.cnt, 1)
        end

       # 90 degree turns, min cnt steps
       if(current.vec[0]==0)
          neighbors << get_neighbor(grid, current.pos, [1,0], 0, min_cnt)
          neighbors << get_neighbor(grid, current.pos, [-1,0], 0, min_cnt)
        else
          neighbors << get_neighbor(grid, current.pos, [0,1], 0, min_cnt)
          neighbors << get_neighbor(grid, current.pos, [0,-1], 0, min_cnt)
        end
      end
      neighbors.compact
    end

    def solve(grid, min_cnt, max_cnt)
      xR = 0...grid[0].size
      yR = 0...grid.size

      start = Node.new([0, 0], [0,0], max_cnt)
      goal = Node.new([xR.max, yR.max], [0,0])

      cost_so_far = {}
      cost_so_far.default = Float::INFINITY
      cost_so_far[start] = 0

      pqueue = PQueue.new([start]) { |a, b| cost_so_far[b] <=> cost_so_far[a] }

      current = nil
      until pqueue.empty?
        current = pqueue.pop
        return cost_so_far[current] if current.pos == goal.pos

        get_neighbors(grid, current, min_cnt, max_cnt).each { |vertex, new_cost|
          new_cost += cost_so_far[current]
          next unless !cost_so_far.key?(vertex) || new_cost < cost_so_far[vertex]

          cost_so_far[vertex] = new_cost
          pqueue.push vertex
        }
      end
    end

    def part_1
      solve(data.map(&:chars).map{ _1.map(&:to_i) }, 1, 3)
    end

    def part_2
      solve(data.map(&:chars).map{ _1.map(&:to_i) }, 4, 10)
    end

  end
end
