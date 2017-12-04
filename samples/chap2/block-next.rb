# -*- encoding:euc-jp -*-

[1, 3, 5].each {|x|
  puts x
  next
  puts "ここは通らない"
}

i = 0
[1, 2, 3, 4, 5].each {|x|
  i += 1
  print "i = #{i}, x = #{x}\n"
  break if i == 3
  redo
  puts "ここは通らない"
}
