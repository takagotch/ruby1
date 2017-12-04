
require "net/http"

Net::HTTP.start("localhost", 80) {|http|
  response, = http.post("/~hori/book/chap7/sample-6.4.cgi",
                        "v1=`ls`")
  print response.body
}
