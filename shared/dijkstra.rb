module Dijkstra
  class << self
    def find_path(graph, start, goal)
      came_from = {}
      cost_so_far = {}
      cost_so_far.default = Float::INFINITY
      cost_so_far[start] = 0

      pqueue = PQueue.new([start]) { |a, b| cost_so_far[b] <=> cost_so_far[a] }

      until pqueue.empty?
        current = pqueue.pop
        break if current == goal

        graph.neighbors(current).each do |vertex|
          new_cost = cost_so_far[current] + graph.cost(current, vertex)
          next unless !cost_so_far.key?(vertex) || new_cost < cost_so_far[vertex]

          cost_so_far[vertex] = new_cost
          pqueue.push vertex
          came_from[vertex] = current
        end
      end

      [came_from, cost_so_far]
    end
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
end
