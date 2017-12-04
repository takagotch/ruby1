#!/usr/local/bin/ruby

require "mailform.rb"
$SAFE = 1

if __FILE__ == $0
  cgi = CGI.new
  data = get_data(cgi)
  if data[2] == ""
    print_retry()
  else
    print_comment(data)
  end
end
