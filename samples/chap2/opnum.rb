
x = -10; y = 3
print "����: #{x / y}\n"
print ";��: #{x % y}\n"
print "�¿���: #{Float(x) / y}\n"

require "rational"
z = Rational(x) / y
puts z
puts z * 3
