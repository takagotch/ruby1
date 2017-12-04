#!/usr/local/bin/ruby

require 'cgi'

cgi = CGI.new
v1 = cgi['v1'].first
v2 = cgi['v2'].first
op = cgi['op'].first
result = eval("#{v1} #{op} #{v2}")
print "Content-Type:text/html\n\n"
print "<p>#{result}\n"
