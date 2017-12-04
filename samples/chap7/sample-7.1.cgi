#!/usr/local/bin/ruby

require "cgi"

cgi = CGI.new
fname = cgi["target"].first

print "Content-Type: text/html; charset=EUC-JP\n"
print "\n"
print "filename: #{fname}<br>\n"
print "----<br>\n"

File.open(fname, "r") {|f|
  while line = f.gets
    print line.chomp, "<br>\n"
  end
}
