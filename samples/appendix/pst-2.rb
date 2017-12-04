
# -*- encoding:euc-jp -*-

require "pstore"

db = PStore.new("/tmp/testdb")
db.transaction {
  db["1"] = {"k" => "v"}
  db.commit
  puts "ここは通らない"
  db["1"] = {"k" => "foo"}
}

db.transaction {
  p db["1"]
}
