# frozen_string_literal: true
module Year2023
  class Day18 < Solution

    # area inside a polygon given by the following product/sum of all vertices:
    # A = 1/2*(x0*y1 - x1*y0 + .... x999*y1000 - x1000*y999)
    def shoelace_formula(vertices)
      sum1 = 0
      sum2 = 0

      vertices.each_with_index do |(x, y), i|
        next_vertex = vertices[(i + 1) % vertices.size]
        sum1 += x * next_vertex[1]
        sum2 += y * next_vertex[0]
      end

      (sum1 - sum2).abs / 2.0
    end

    # gives number of integer points within a simple polygon.
    # Normally gives area based on interior integer points and
    # boundary points, but can solve for interior points if
    # we have the other 2 arguments
    def picks_theorem_interior(area, boundary_length)
      #A = i + b/2 - 1
      area - boundary_length/2.0 + 1
    end

    def solve(instructions)
      vertices = [[0,0]]
      length = instructions.sum { |dir, cnt|
        x, y = vertices.last
        case(dir)
        when ?R,?0 then x += cnt
        when ?D,?1 then y += cnt
        when ?L,?2 then x -= cnt
        when ?U,?3 then y -= cnt
        end
        vertices << [x,y]
        cnt
      }
      (picks_theorem_interior(shoelace_formula(vertices), length) + length).to_i
    end

    def part_1
      solve(data.map { _1.split[0..1] }.map { |dir, cnt| [dir, cnt.to_i] })
    end

    def part_2
      solve(data.map { _1.split.last.chars }.map { |color| [color[7], color[2..6].join.to_i(16)] })
    end
  end
end
