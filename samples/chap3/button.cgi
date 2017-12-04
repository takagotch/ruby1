#!/usr/local/bin/ruby
# -*- mode:ruby; encoding:euc-jp -*-

require "cgi"
$SAFE = 1

cgi = CGI.new
print "Content-Type:text/html; charset=EUC-JP\n\n"
if !cgi['next'].empty?
  print "<p>[次]が押されました。\n"
elsif !cgi['prev'].empty?
  print "<p>[前]が押されました。\n"
elsif !cgi['new'].empty?
  print "<p>[新規]が押されました。\n"
end
