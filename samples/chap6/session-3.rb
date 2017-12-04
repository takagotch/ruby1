# -*- encoding:euc-jp -*-

require "cgi/session"
SESSION_DIR = "/home/hori/wwwdata/book/session"

cgi = CGI.new
session = CGI::Session.new(cgi, {"tmpdir" => SESSION_DIR})
session["foo"] = "あいうえお"
session.update
id = session.session_id
puts session["foo"]
session.delete

s2 = CGI::Session.new(cgi,
            {"tmpdir" => SESSION_DIR, "session_id" => id})
print s2["foo"], "\n"
