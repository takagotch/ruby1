# -*- encoding:euc-jp -*-

ary = Array.new      # []
ary[1] = "str"       # [nil, "str"]
puts ary.size

ary += [1, 2]        # [nil, "str", 1, 2]
ary << 10            # [nil, "str", 1, 2, 10]
ary << ["a", "b"]    # [nil, "str", 1, 2, 10, ["a", "b"]]
puts ary.size
p ary
puts ary[100]

[1, 2, 3].each {|x|
  print x, " "
}
print "\n"

puts ["a", "1", "Z"].join(":::")
