#ÉäÉXÉg5.5Å@maillist2.rb

require 'net/pop'
require 'tmail'
require 'nkf'

SERVER = 'pop.hoge.ne.jp'
PORT   = 110
USER   = 'hitoshi_takeuchi'
PASSWD = 'hogehoge'

Net::POP3.start(SERVER, PORT, USER, PASSWD) do |pop|
  pop.each do |m|
    mail = TMail::Mail.parse(m.pop)                              # (1)
    puts mail.date                                               # (2)
    puts mail.from_addrs[0].addr
    puts NKF.nkf('-s', mail.subject || '(no subject)') 
    puts '-' * 40
  end
end
