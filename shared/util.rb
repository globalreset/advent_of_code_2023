
# find the min/max of 2 numbers and create a range from them
def getRange( a, b )
   rMin, rMax = [a,b].minmax
   rMin..rMax
end

# Search a string for instances of a char, return an array of indices
def getIndices( str, char)
   str = str.chars if(str.is_a?(String))
   str.map.with_index{[_1,_2]}.select{ _1==char }.map { _2 }
end

class Hash
  # lets you use 'myHash.whatever = x' as a shorthand for 'myHash["whatever"] = x'
  def method_missing(sym,*args)
    if(sym[-1]=="=")
      self.store(sym[0...-1].to_sym, args[0])
    else
      self.fetch(sym.to_sym)
    end
  end
end
