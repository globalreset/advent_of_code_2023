# frozen_string_literal: true
module Year2023
  class Day19 < Solution

    def get_workflows_parts(input)
      workflow_list, part_list = input.slice_when{_1=="" || _2==""}.reject{_1[0]==""}.to_a
      workflows = workflow_list.map { |w|
        name, rule = w.scan(/(\w+){(.*)}/)[0]
        rule = rule.split(",").map{ |r|
          if(r=~/(\w+)(>|<)(\d+):(\w+)/)
            [Regexp.last_match(1), Regexp.last_match(2), Regexp.last_match(3), Regexp.last_match(4)]
          else
            [r]
          end
        }
        [name, rule]
      }.to_h
      parts = part_list.map { |part|
        [:x,:m,:a,:s].zip(part.scan(/\d+/)).to_h
      }
      [workflows, parts]
    end

    def part_1
      workflows, parts = get_workflows_parts(data)
      parts.sum { |part|
        wf = "in"
        until([?R,?A].include?(wf))
          rule = workflows[wf]
          result = rule.find { |r|
             r.size==1 || eval("#{part[r[0].to_sym]}#{r[1]}#{r[2]}")
          }
          wf = result.last
        end
        wf==?A ? part.values.map(&:to_i).sum : 0
      }
    end

    # current wf and min/max values seen on this path so far
    State = Struct.new(:wf, :x, :m, :a, :s)
    def part_2
      workflows, parts = get_workflows_parts(data)
      #explore the tree and get the min/max for every number that leads to an A
      accepted_rules = Set.new
      queue = [ State.new("in", [1,4000], [1,4000], [1,4000], [1,4000]) ]
      until queue.empty?
        curr = queue.shift
        if([?R,?A].include?(curr.wf))
          accepted_rules << curr if(curr.wf==?A)
        else
          workflows[curr[0]].each { |r|
            new_state = State.new(r.last, curr.x.dup, curr.m.dup, curr.a.dup, curr.s.dup)
            if(r.size>1)
              if(r[1]==">") #adjusting min
                curr[r[0].to_sym][1] =  r[2].to_i
                new_state[r[0].to_sym][0] =  r[2].to_i+1
              else #adjusting max
                new_state[r[0].to_sym][1] = r[2].to_i-1
                curr[r[0].to_sym][0] = r[2].to_i
              end
            end
            queue << new_state
          }
        end
      end
      accepted_rules.sum { |state|
        (state.x[1] - state.x[0] + 1) *
        (state.m[1] - state.m[0] + 1) *
        (state.a[1] - state.a[0] + 1) *
        (state.s[1] - state.s[0] + 1)
      }
    end

  end
end
