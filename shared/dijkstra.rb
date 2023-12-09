module Dijkstra
  Infinity = 1/0.0
  class << self
    def find_path(graph, start, goal)
      came_from = {}
      cost_so_far = {}
      cost_so_far.default = Float::INFINITY
      cost_so_far[start] = 0

      pqueue = PQueue.new([start]) {|a,b| cost_so_far[b]<=>cost_so_far[a]}
  
      while(!pqueue.empty?)
        current = pqueue.pop
        break if current == goal
        graph.neighbors(current).each do |vertex|
          new_cost = cost_so_far[current] + graph.cost(current, vertex)
          if !cost_so_far.key?(vertex) || new_cost < cost_so_far[vertex]
            cost_so_far[vertex] = new_cost
            pqueue.push vertex
            came_from[vertex] = current
          end
        end
      end
  
      [came_from, cost_so_far]
    end
  
  end
end

class DijkstraSearch
 
  def initialize(neighborHash, costHash)
     @neighborHash = neighborHash
     @costHash = costHash
     @pathHash = {}
     @pathScore = {}
     @pathScore.default = Float::INFINITY
  end
  
  def printPath(start, goal)
     pathStr = goal
     until(goal==start)
        pathStr += "<=#{pathHash[goal]}"
        goal = pathHash[goal]
     end
  end
 
  # generic dijkstra's search
  def search(start, goal)
     @pathHash = {}
     @pathScore = {}
     @pathScore.default = Float::INFINITY
     @pathScore[start] = 0
     pqueue = PQueue.new([start]) {|a,b| @pathScore[b]<=>@pathScore[a]}
     while(!pqueue.empty?) do
        current = pqueue.pop
        if(current==goal)
           return @pathScore[current]
        end
        @neighborHash[current].each { |n|
           newPathScore = @pathScore[current] + @costHash[n]
           if(newPathScore < @pathScore[n])
              @pathHash[n] = current
              @pathScore[n] = newPathScore 
              if(!pqueue.include?(n))
                 pqueue.push(n)
              end
           end
        }
     end
     return nil
  end
 end