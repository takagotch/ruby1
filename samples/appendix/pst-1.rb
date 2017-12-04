
require "pstore"

db = PStore.new("/tmp/testdb")
db.transaction {
  ary = [1, 2, "str", 4]
  db["obj"] = ary
  ary[1] = {"key" => "val"}
}

db.transaction {
  p db["obj"]
}
