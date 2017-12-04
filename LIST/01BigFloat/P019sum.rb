#!/usr/local/bin/ruby

#
# sum.rb
#
require "BigFloat"

s = Bigfloat.new("0")
while f = ARGF.gets do
   s = s + f
end  

print "çáåv=",s.to_s
