#!/usr/local/bin/ruby
# -*- mode:ruby; encoding:euc-jp -*-

require "cgi"
$SAFE = 1

cgi = CGI.new
print "Content-Type: text/html; charset=EUC-JP\n\n"
print "<p>コントロール'foo'の値 = '#{cgi['foo'].first}'\n"
