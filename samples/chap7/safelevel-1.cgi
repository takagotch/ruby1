#!/usr/local/bin/ruby

require "cgi"
$SAFE = 1
cgi = CGI.new
print "Content-Type: text/html\n\n"
File.open(cgi['article'].first) {|fp|
  while line = fp.gets
    print line.chomp, "<br>\n"
  end
}
