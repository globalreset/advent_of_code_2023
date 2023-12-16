# frozen_string_literal: true
module Year2023
  class Day16 < Solution
    Beam = Struct.new(:pos, :vec)

    def energize(startBeam)
      xR,yR = (0...data.first.size), (0...data.size)
      visited = Set.new
      energized = Set.new
      beams = [startBeam]
      while b = beams.shift
        if(!visited.include?(b))
          visited << b
          energized << b.pos if(xR.include?(b.pos[0]) && yR.include?(b.pos[1]))
          newPos = b.pos.zip(b.vec).map(&:sum)
          if(xR.include?(newPos[0]) && yR.include?(newPos[1]))
            case([b.vec[0].abs, data[newPos[1]][newPos[0]]])
            when [1, ?|], [0, ?-]
              beams << Beam.new(newPos, [b.vec[1].abs, b.vec[0].abs])
              beams << Beam.new(newPos, [b.vec[1].abs*-1, b.vec[0].abs*-1])
            when [1, ?\\], [0, ?\\] #reflect, preserve sign
              beams << Beam.new(newPos, [b.vec[1], b.vec[0]])
            when [1, ?/], [0, ?/] #reflect, invert sign
              beams << Beam.new(newPos, [b.vec[1]*-1, b.vec[0]*-1])
            else
              beams << Beam.new(newPos, b.vec)
            end
          end
        end
      end
      energized.size
    end

    def part_1
      energize(Beam.new([-1,0], [1,0]))
    end

    def part_2
      xR,yR = (0...data.first.size), (0...data.size)
      [ xR.to_a.map{ energize(Beam.new([_1, yR.last], [0, -1])) },
        xR.to_a.map{ energize(Beam.new([_1, -1], [0, 1])) },
        yR.to_a.map{ energize(Beam.new([-1, _1], [1, 0])) },
        yR.to_a.map{ energize(Beam.new([xR.last, _1], [-1, 0])) }
      ].flatten.max
    end

    private
      def process_input(line)
        line.chars
      end
  end
end
