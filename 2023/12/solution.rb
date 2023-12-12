module Year2023
  class Day12 < Solution

    $cache = {}
    # recursive search of solution space
    # recurse down if '#' and count for this group is correct
    # recurse down if '.', breaking current group if applicable
    # explore both paths above if '?'
    def find_groups(pattern, i, groups, j, curr)
      key = [pattern, i, groups, j, curr]
      return $cache[key] if($cache.key?(key))

      if(i==pattern.size)
         $cache[key] = ((j==(groups.size-1) && groups[j]==curr) || (j==groups.size && curr==0)) ? 1 : 0
         return $cache[key]
      end

      room_to_grow = j<groups.size && groups[j]>curr
      group_valid = j<groups.size && groups[j]==curr

      found = 0
      case(pattern[i])
      when '#'
        # always continue counting current group
        # unless we exhausted our groups
        if(room_to_grow)
          found += find_groups(pattern, i+1, groups, j, curr+1)
        end
      when '.'
        # continue not counting group
        if(curr==0)
          found += find_groups(pattern, i+1, groups, j, 0)
        # break current group if it's correct, otherwise abort path
        elsif(group_valid)
          found += find_groups(pattern, i+1, groups, j+1, 0)
        end
      when '?'
        # try always continue counting current group
        # unless we exhausted our groups
        if(room_to_grow)
          found += find_groups(pattern, i+1, groups, j, curr+1)
        end
        # try to continue not counting group
        if(curr==0)
          found += find_groups(pattern, i+1, groups, j, 0)
        # break current group if it's correct
        elsif(group_valid)
          found += find_groups(pattern, i+1, groups, j+1, 0)
        end
      end

      $cache[key] = found
      return found
    end

    $tdata = [
      "???.### 1,1,3",
      ".??..??...?##. 1,1,3",
      "?#?#?#?#?#?#?#? 1,3,1,6",
      "????.#...#... 4,1,1",
      "????.######..#####. 1,6,5",
      "?###???????? 3,2,1"
    ]

    def part_1
      data.sum { |line|
        pattern,groups = line.split
        groups = groups.split(",").map(&:to_i)
        find_groups(pattern, 0, groups, 0, 0)
      }
    end

    # doesn't work
    def part_2
      data.sum { |line|
        pattern,groups = line.split
        pattern = "#{pattern}?"*5
        groups = groups.split(",").map(&:to_i)
        groups = groups*5
        find_groups(pattern, 0, groups, 0, 0)
      }
    end

  end
end
