#!/usr/local/bin/ruby
# -*- mode:ruby; encoding:euc-jp -*-

require "cgi"
$SAFE = 1

cgi = CGI.new
print "Content-Type: text/html\n\n"
for i in 1..5 do
  print "<p>", cgi["check#{i}"].first, "\n"
end
