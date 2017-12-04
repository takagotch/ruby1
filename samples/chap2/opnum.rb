
x = -10; y = 3
print "整除: #{x / y}\n"
print "余り: #{x % y}\n"
print "実数で: #{Float(x) / y}\n"

require "rational"
z = Rational(x) / y
puts z
puts z * 3
