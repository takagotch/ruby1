#!/usr/local/bin/ruby

# to_b.rb
# Usage: to_b n value
#      value must be 0.xxxx
#
require "BigFloat"
n = ARGV.shift.to_i
v = BigFloat.new(ARGV.shift)
b = BigFloat.new("1.0")
if v >= b
  raise "2�Ԗڂ̈����͂P�ȉ��ɂ��ĂˁI"
end
t = BigFloat.new("0.0")
s = "0."
n.times {
  b = b/2.0
  if t+b > v 
    s = s + "0"
  elsif t+b < v
    s = s + "1"
    t = t + b
  else
    s = s + "1"
    t = t + b
    print "�ϊ��ł����A���΁I\n"
    break
  end
}
print "2�i = ",s
