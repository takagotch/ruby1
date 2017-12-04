
[1, 2, 3].each {|s|
  t = s
}
print "s? = ", defined?(s), "\n"
print "t? = ", defined?(t), "\n"

total = 0
[1, 2, 3].each {|x|
  total += x
}
print "x? = ", defined?(x), "\n"
print "total = #{total}\n"
