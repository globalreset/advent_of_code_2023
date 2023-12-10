require_relative 'pqueue'

class PriorityQueue
  include Enumerable

  class Element
    include Comparable

    attr_accessor :value, :priority

    def initialize(value, priority)
      @value = value
      @priority = priority
    end

    def <=>(other)
      @priority <=> other.priority
    end
  end

  def initialize
    @elements = [nil]
  end

  def size
    @elements.size - 1
  end

  def each(&block)
    @elements.drop(1).each(&block)
  end

  def empty?
    size == 0
  end

  def <<(element)
    @elements << element
    bubble_up(@elements.size - 1)
  end

  def enqueue(value, priority = nil)
    value = Element.new(value, priority) if priority
    self << value
  end

  def dequeue
    exchange(1, @elements.size - 1)
    element = @elements.pop.tap { bubble_down(1) }
    return element.value if element.is_a? Element

    element
  end

  private

  def bubble_up(index)
    parent_index = index / 2
    return if index <= 1
    return if @elements[parent_index] <= @elements[index]

    exchange(index, parent_index)
    bubble_up(parent_index)
  end

  def bubble_down(index)
    child_index = index * 2
    max_index = @elements.size - 1
    return if child_index > max_index

    not_last_element = child_index < max_index
    left_element = @elements[child_index]
    right_element = @elements[child_index + 1]
    child_index += 1 if not_last_element && right_element < left_element
    return if @elements[index] <= @elements[child_index]

    exchange(index, child_index)
    bubble_down(child_index)
  end

  def exchange(source, target)
    @elements[source], @elements[target] = @elements[target], @elements[source]
  end
end

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
