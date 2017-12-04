#ƒŠƒXƒg5.7@delmail.rb

require 'checkmail'
require 'nkf'

SERVER    = 'pop.hoge.ne.jp'
USER      = 'hitoshi_takeuchi'
PASSWD    = 'hogehoge'
SLEEPTIME = 60

pop           = CheckMail.new(SERVER, USER, PASSWD)         # (1)
pop.subject   = [/money/i]                                  # (2)
pop.from      = [/\.com$/]                                  # (3)
pop.condition = CheckMail::COND_AND                         # (4)

while true
  count = 0
  pop.start do |popmail, mail|                              # (5)
    puts NKF.nkf('-s', mail.subject || ''),
         mail.from_addrs[0].addr, 
         mail.message_id                                    # (6)
    puts "-" * 40
    count = count + 1
#   popmail.delete
  end
  if count > 0 
    puts "#{count} mail(s) deleted." 
  else
    puts "no match."
  end

  sleep SLEEPTIME
end
