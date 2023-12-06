module Year2023
  class Day05 < Solution

    def getSeedsTransforms
      dataSplit = data.slice_when { |i,j| i.size==0 || j.size==0 }.reject { |i| i[0].size==0 }
      seeds = dataSplit.shift.shift.split(": ")[1].split(" ").map(&:to_i)

      transforms = []
      while m = dataSplit.shift
         m = m[1..]
         mapping = []
         while c = m.shift
            # dstRange srcRange rangeLen
            mapping << c.split(" ").map(&:to_i)
         end
         transforms << mapping
      end
      [seeds, transforms]
    end

    def part_1
      seeds, transforms = getSeedsTransforms()
      # transform the seeds passing it through each layer
      transforms.reduce(seeds) { |seeds, mappings| 
        # re-map every value in the seed list
        seeds.map { |s| 
           # by iterating over every range in each 
           # transformation layer and looking for inclusion
           mappings.map { |dst, src, len|
              if(s>src && s<(src+len-1))
                 s - src + dst
              end
           }.compact.shift || s # keep current value if it didn't get mapped
        }
      }.compact.min
    end

    def part_2
      seeds, transforms = getSeedsTransforms()
      seeds = seeds.each_slice(2).map { |start, len| [start, start+len-1]}
      # transform the seeds passing it through each layer
      transforms.reduce(seeds) { |seeds, mappings|
         # re-map every Range in the seed list
         seeds.flat_map { |seedMin, seedMax|
            # keep track of how we disect the ranges, create new ranges for 
            # each instance of a successful mapping
            mapped, unmapped = [], [[seedMin, seedMax]]
            mappings.each { |dst, src, len|
               remainder = []
               unmapped.each { |rMin, rMax|
                  before = [rMin, [rMax, src].min]
                  overlap = [[rMin, src].max, [src + len, rMax].min]
                  after = [[src + len, rMin].max, rMax]
                  remainder << before if before[0] < before[1]
                  mapped.push([overlap[0] - src + dst, overlap[1] - src + dst]) if overlap[0] < overlap[1]
                  remainder << after if after[0] < after[1]
               }
               unmapped = remainder
            }
            # preserve all the translated and untranslated values at this level
            mapped + unmapped
         }
      }.map{ |r| r[0] }.min

    end

  end
end
