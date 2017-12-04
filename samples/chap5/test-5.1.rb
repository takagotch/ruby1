
require "enq-common.rb"
$SAFE = 1

q, o = get_question("1")
puts q
o.each {|x| print "    ", x, "\n"}
