#!/usr/local/bin/ruby
# -*- mode:ruby; encoding:euc-jp -*-

require "cgi"
$SAFE = 1

cgi = CGI.new
print "Content-Type:text/html; charset=EUC-JP\n\n"
if !cgi['next'].empty?
  print "<p>[��]��������ޤ�����\n"
elsif !cgi['prev'].empty?
  print "<p>[��]��������ޤ�����\n"
elsif !cgi['new'].empty?
  print "<p>[����]��������ޤ�����\n"
end
