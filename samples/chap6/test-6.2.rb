
require "board-common.rb"
$SAFE = 1

PWDFILE = "/tmp/pwdtest"
File.open(PWDFILE, "w") {|fp|
  fp.print "test:password:test_name\n"
  fp.print "foo:passtest:namename\n"
}

puts check_pwd(PWDFILE, "bar", "baz")
puts check_pwd(PWDFILE, "foo", "passtest")
puts get_name(PWDFILE, "test")
puts get_name(PWDFILE, "hoge")

File.unlink PWDFILE
