#!/usr/local/bin/ruby

require "BigFloat"
print "sqrt(2):\n"
p c=BigFloat.new("2.0").sqrt(50)
p c*c - "2.0"
print "sqrt(3):\n"
p c=BigFloat.new("3.0").sqrt(50)
p c*c - "3.0"
print "sqrt(5):\n"
p c=BigFloat.new("5.0").sqrt(50)
p c*c - "5.0"
print "e:\n"
p BigFloat::E(50)

