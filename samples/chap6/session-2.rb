# -*- encoding:euc-jp -*-

require "cgi/session"
SESSION_DIR = "/home/hori/wwwdata/book/session"

def write(cgi, session_option)
  session = CGI::Session.new(cgi, session_option)
  session["foo"] = "あいうえお"
  session.update
  return session.session_id
end

def get(cgi, session_option)
  session = CGI::Session.new(cgi, session_option)
  print session["foo"], "\n"
end

session_option = {"tmpdir" => SESSION_DIR}
cgi = CGI.new
id = write(cgi, session_option)
session_option["session_id"] = id
get(cgi, session_option)
