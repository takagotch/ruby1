#!/usr/local/bin/ruby

require 'cgi'

cgi = CGI.new
v1 = cgi['v1'].first
v2 = cgi['v2'].first
op = cgi['op'].first
if op == "*"
  result = v1.to_i * v2.to_i
elsif op == "+"
  result = v1.to_i + v2.to_i
end
print "Content-Type:text/html\n\n"
print "<p>#{result}\n"
