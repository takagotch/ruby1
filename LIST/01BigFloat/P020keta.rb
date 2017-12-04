#!/usr/local/bin/ruby

#
# keta.rb
#
require "BigFloat"
a = BigFloat.new("1.0")
b = BigFloat.new("1.0e40")
c = a+b
print "c = ",c.to_s
