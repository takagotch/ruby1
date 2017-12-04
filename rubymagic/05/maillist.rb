#ÉäÉXÉg5.3Å@maillist.rb

require 'net/pop'
require 'nkf'

SERVER = 'pop.hoge.ne.jp'
PORT   = 110
USER   = 'hitoshi_takeuchi'
PASSWD = 'hogehoge'

Net::POP3.start(SERVER, PORT, USER, PASSWD) do |pop|
  pop.each do |mail|
    header = mail.header.gsub(/\r\n[ \t]+/m, '')                 # (1)
    puts $1.chop if /^Date: (.*)/ =~ header                      # (2)
    puts NKF.nkf('-s', $1.chop) if /^From: (.*)/ =~ header       # (3)
    puts NKF.nkf('-s', $1.chop) if /^Subject: (.*)/ =~ header
    puts '-' * 40
  end
end
