#!/usr/local/bin/ruby

require "cgi"
$SAFE = 1

def foo_out(cgi)
  a = cgi['foo'].first.strip
  print "Content-Type: text/html\n\n"
  print "#{a}\n"
end

if __FILE__ == $0
  cgi = CGI.new
  foo_out(cgi)
end
