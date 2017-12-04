#ƒŠƒXƒg5.11@cmdmail.rb

require 'checkmail'
require 'net/smtp'
require 'nkf'

SMTPSERVER  = 'smtp.hoge.ne.jp'                              # (1)
POPSERVER   = 'pop.hoge.ne.jp'                               # (2)
USER        = 'hitoshi_takeuchi'
PASSWD      = 'hogehoge'

FORWARDADDR = 'take@can.hoge-tako.co.jp'                     # (3)
FROMADDR    = 'hitoshi@namaraii.com'                         # (4)

SLEEPTIME   = 60

def sendit(from, to, subject, body)                          # (5)
  newmail = TMail::Mail.new

  charset = 'iso-2022-jp'
  charset = 'US-ASCII' if NKF.guess(body) == NKF::UNKNOWN
  newmail.to = to
  newmail.from = from
  newmail.subject = subject || '(no subject)'
  newmail.set_content_type('text', 'plain', {'charset' => charset})
  newmail.encoding = '7bit'
  newmail.body = NKF.nkf('-j -m0', body)
  newmail.mime_version = '1.0'
  newmail.message_id = TMail::new_message_id
  newmail.date = Time.now
  
  Net::SMTP.start(SMTPSERVER) do |smtp|
    smtp.sendmail(newmail.encoded, newmail.from_addrs[0].addr, to)
  end
end

def forward(from, to, mail)                                 # (6)
  mail.delete 'bcc'
  mail.delete 'received'
  mail.delete 'Delivered-To'
  mail.date = Time.now
  mail.delete_if {|n,v| v.empty?}
  mail.to = to
  mail.message_id = TMail::new_message_id
  
  Net::SMTP.start(SMTPSERVER) do |smtp|
    smtp.sendmail(mail.encoded, from, to)
  end
end

pop = CheckMail.new(POPSERVER, USER, PASSWD)
pop.readCheck = false
 
while true
  commands = []
  pop.subject = [/#[A-Z]+(?: +\d+)?$/o]                      # (7)
  pop.from = [/^#{FORWARDADDR}$/o]                           # (8)
  pop.condition = CheckMail::COND_AND

  pop.start do |popmail, mail|                               # (9)
    commands << mail.subject.scan(/#([A-Z]+)(?: +(\d+))?$/).flatten
    popmail.delete
  end

  pop.subject = []
  pop.from = []

  commands.each do |c|                                      # (10)
    count = 0
    case c[0]
    when 'LIST'                                             # (11)
      list = "LIST command result #{Time.now}\n\n"
      listfrom = listfrom ? listfrom : 0
      pop.start do |popmail, mail|
        count = count + 1
        list << sprintf("%3d:%-30s\n    %-50s %s\n", count,
                   mail.subject, mail.from_addrs[0].addr, 
                   mail.date) if count >= listfrom
      end
      sendit(FROMADDR, FORWARDADDR, 'LIST command result', list)
      puts "LIST command done (total #{count} mail(s))."

    when 'GET'                                              # (12)
      next unless c[1]
      pop.start do |popmail, mail|
        count = count + 1
        if count == c[1].to_i
          forward(FROMADDR, FORWARDADDR, mail)
          puts "GET #{count} command done."
          next
        end      
      end

    when 'QUIT'                                             # (13)
      puts 'Program is terminated by QUIT command.'
      exit
    end
  end
  sleep SLEEPTIME
end
