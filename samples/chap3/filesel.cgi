#!/usr/local/bin/ruby
# -*- mode:ruby; encoding:euc-jp -*-

require "cgi"
$SAFE = 1

def filesel_test()
  cgi = CGI.new
  checkio = cgi['check'].first
  urlio = cgi['url'].first
  textio = cgi['text'].first
  localio = cgi['local'].first
  size = localio.stat.size

  print "Content-Type:text/html\n\n"
  print "<p>check = #{checkio.read}\n" if checkio
  print "<p>url = #{urlio.read}\n"
  print "<p>text = #{textio.read}\n"
  if size < 10000
    print "<p>file: size = #{size}\n"
    print "<pre style=\"border:solid black 1px\">\n"
    print localio.read
    print "</pre>\n"
  else
    print "<p>file: size = #{size}; too large.\n"
  end
  print "<hr>\n"
end

filesel_test()
