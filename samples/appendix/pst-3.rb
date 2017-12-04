
# -*- encoding:euc-jp -*-

require "pstore"

db = PStore.new("/tmp/testdb")
db.transaction {
  db["a"] = "str"
}

db.transaction {
  db["a"] = {"k" => "v"}
  db.abort
  puts "ここは通らない"
}

db.transaction {
  p db["a"]
}
