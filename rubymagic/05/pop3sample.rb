#ÉäÉXÉg5.1Å@pop3sample.rb

require 'net/pop'
require 'nkf'

SERVER = 'pop.hoge.ne.jp'                                        # (1)
PORT   = 110
USER   = 'hitoshi_takeuchi'
PASSWD = 'hogehoge'

Net::POP3.start(SERVER, PORT, USER, PASSWD) do |pop|             # (2)
  pop.mails.each do |m|                                          # (3)
    m.pop do |str|                                               # (4)
      puts NKF.nkf('-s', str)
    end
  end
end
