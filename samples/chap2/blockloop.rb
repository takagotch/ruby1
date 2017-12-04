
hash = {1 => "foo", 2 => "bar", 3 => "baz"}
hash.each_pair {|k, v|
  print k, " = ", v, "\n"
}
