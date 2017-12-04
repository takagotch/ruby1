#!/usr/local/bin/ruby

require "board.rb"
$SAFE = 1

cgi, session = get_session(PCView.new)

print "Content-Type: text/html\n\n"
print "<p>", CGI.escapeHTML(cgi.inspect), "\n"
print "<p>", CGI.escapeHTML(session.inspect), "\n"
