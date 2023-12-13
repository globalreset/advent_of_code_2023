require_relative 'pqueue'

module AStar
  class << self
    def find_path(graph, start, goal, &heuristic)
      heuristic ||= method(:default_heuristic)

      frontier = PriorityQueue.new
      came_from = {}
      cost_so_far = {}

      if start.is_a?(Enumerable) && !start.is_a?(Vector)
        start.each do
          frontier.enqueue _1, 0
          came_from[_1] = nil
          cost_so_far[_1] = 0
        end
      else
        frontier.enqueue start, 0
        came_from[start] = nil
        cost_so_far[start] = 0
      end

      while frontier.any?
        current = frontier.dequeue
        break if current == goal

        graph.neighbors(current).each do |vertex|
          new_cost = cost_so_far[current] + graph.cost(current, vertex)
          next unless !cost_so_far.key?(vertex) || new_cost < cost_so_far[vertex]

          cost_so_far[vertex] = new_cost
          priority = new_cost + heuristic.call(vertex, goal)
          frontier.enqueue vertex, priority
          came_from[vertex] = current
        end
      end

      [came_from, cost_so_far]
    end

    def reconstruct_path(came_from, start, goal)
      current = goal
      path = []
      while current != start
        path << current
        current = came_from[current]
      end
      path << start
      path.reverse
    end

    private

    def default_heuristic(a, b)
      x1, y1 = a.to_a
      x2, y2 = b.to_a
      (x1 - x2).abs + (y1 - y2).abs
    end
  end
end


##Astar test
#def heuristic(a, b)
#  x1, y1 = a.to_a
#  x2, y2 = b.to_a
#  (x1 - x2).abs + (y1 - y2).abs
#end
#
#diagram4 = GridWithWeights.new 10, 10
#diagram4.walls = [[1, 7], [1, 8], [2, 7], [2, 8], [3, 7], [3, 8]].map { Vector[*_1] }
#
#start, goal = Vector[1, 4], Vector[1, 9]
#came_from, cost_so_far = AStar.find_path(diagram4, start, goal, &method(:heuristic))
#diagram4.draw point_to: came_from, start: start, goal: goal
#path = AStar.reconstruct_path(came_from, start, goal)
#diagram4.draw path: path
#diagram4.draw number: cost_so_far, start: start, goal: goal
#
#puts "Shortest path has cost #{cost_so_far[goal]}"
