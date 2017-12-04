#!/usr/local/bin/ruby

require "cgi"

cgi = CGI.new
if cgi["post"].first
  File.open("data", "a") {|fp|
    fp.print cgi["data"].first, "\n"
  }
end

print "Content-Type:text/html\n\n"
File.open("data") {|fp|
  print "<p>", fp.read
}
