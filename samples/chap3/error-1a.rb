#!/usr/local/bin/ruby

require "cgi"
$SAFE = 1

def foo_out(cgi)
  a = cgi['foo'].first.strip
  print "Content-Type: text/html\n\n"
  print "#{a}\n"
end

def error_out()
  print "Content-Type:text/html\n\n"
  print "<p>#{CGI.escapeHTML($!.inspect)}<br>\n"
  $@.each {|x| print CGI.escapeHTML(x), "<br>\n"}
end

if __FILE__ == $0
  begin
    cgi = CGI.new
    foo_out(cgi)
  rescue StandardError
    error_out()
  rescue ScriptError
    error_out()
  end
end
