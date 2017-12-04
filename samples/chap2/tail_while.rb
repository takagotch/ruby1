require "date"

date = Date.today
date -= 1 while date.wday() != 0
print "Last Sunday is #{date}\n"

begin
  puts "evaluated."
end while false
