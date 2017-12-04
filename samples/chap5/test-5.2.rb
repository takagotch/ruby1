
require "enq-common.rb"
$SAFE = 1

id = "1"
db = ResultDB.new(id)
db.append([1, "テストテストテスト"])
db.append([5, "これもテスト"])
db.each {|data|
  print "#{data[0]}, #{data[1]}\n"
}
puts db.size
ResultDB.delete(id)
