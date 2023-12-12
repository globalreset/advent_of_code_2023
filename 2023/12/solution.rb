module Year2023
  class Day12 < Solution

    $cache = {}
    # recursive search of solution space
    # recurse down if '#' and count for this group is correct
    # recurse down if '.', breaking current group if applicable
    # explore both paths above if '?'
    def find_groups(pattern, groups, curr=0)
      key = [pattern, groups, curr]
      return $cache[key] if($cache.key?(key))

      room_to_grow = (!groups.empty? && groups.first>curr)
      group_valid = (!groups.empty? && groups.first==curr)

      found = 0
      if(pattern.empty?)
        # end of pattern is end of search
        # but success means we either got here with the right group count
        # or we counted all the groups successfully before we got here
        return ((groups.empty? &&  curr==0) || (groups.size==1 && groups.first==curr)) ? 1 : 0
      else
        if([?#,??].include?(pattern.first) && room_to_grow)
          # always continue counting current group
          # unless we exhausted our groups
          found += find_groups(pattern[1..], groups, curr+1)
        end
        if([?.,??].include?(pattern.first))
          # continue not counting group
          if(curr==0)
            found += find_groups(pattern[1..], groups, 0)
          # break current group if it's correct, otherwise abort path
          elsif(group_valid)
            found += find_groups(pattern[1..], groups[1..], 0)
          end
        end
      end

      $cache[key] = found
      return found
    end

    def part_1
      data.sum { |line|
        pattern,groups = line.split
        groups = groups.split(',').map(&:to_i)

        find_groups(pattern.chars, groups)
      }
    end

    def part_2
      data.sum { |line|
        pattern,groups = line.split
        groups = groups.split(',').map(&:to_i)

        pattern = ([pattern]*5).join('?')
        groups = groups*5

        find_groups(pattern.chars, groups)
      }
    end

  end
end
