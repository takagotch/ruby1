
require "cgi/session"
SESSION_DIR = "/home/hori/wwwdata/book/session"

session_option = {"tmpdir" => SESSION_DIR}
cgi = CGI.new
session = CGI::Session.new(cgi, session_option)

print "session_id = ", session.session_id, "\n"
