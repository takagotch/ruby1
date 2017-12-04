
s = ENV['HOME']
puts s
puts s.tainted?       #=> true

s2 = File.dirname(s)
puts s2
puts s2.tainted?      #=> true

