#!/usr/local/bin/ruby

# int2b.rb
# Usage: int2b value
#      value bust be an integer number.
#
n = ARGV.shift.to_i
s = ""
while (n>0)
  s = (n%2).to_s + s
  n = n/2
end
print "2i = ",s
