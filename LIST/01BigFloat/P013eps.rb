#!/usr/local/bin/ruby

#
# eps.rb
#
e = 1.0
v = 1.0
while (v+e)!=v do
  e = e/10.0
end

print "e=",e,"\n"

e = 1.0
v = 1.0
while (v+e)!=v do
  v = v*10.0
end
print "v=",v
