#ƒŠƒXƒg5.8@forward.rb

require 'checkmail'
require 'net/smtp'
require 'nkf'

def forward(mail, to)
  newmail = TMail::Mail.new                                 # (1)
  body    = mail.body

  if mail.multipart?                                        # (2)
    mail.parts.each do |m|
      body = m.body if m.main_type == 'text'
    end
  end 

  charset = 'iso-2022-jp'                                   # (3)
  charset = 'US-ASCII' if NKF.guess(body) == NKF::UNKNOWN
  newmail.to = to
  newmail.from_addrs = mail.from_addrs
  newmail.subject = mail.subject || '(no subject)'
  newmail.set_content_type('text', 'plain', {'charset' => charset})
  newmail.encoding = '7bit'
  newmail.body = NKF.nkf('-j -m0', body)
  newmail.mime_version = '1.0'
  newmail.message_id = TMail::new_message_id
  newmail.date = Time.now
  
  Net::SMTP.start(SMTPSERVER) do |smtp|                     # (4)
    smtp.sendmail(newmail.encoded, newmail.from_addrs[0].addr, to)
  end
end

SMTPSERVER    = 'smtp.hoge.ne.jp'                                # (5)
POPSERVER     = 'pop.hoge.ne.jp'
USER          = 'hitoshi_takeuchi'
PASSWD        = 'hogehoge'

FORWARDADDR   = 'xxxxxxxxxxxxxx@jp-t.ne.jp'                      # (6)

SLEEPTIME     = 60
pop           = CheckMail.new(POPSERVER, USER, PASSWD)
pop.from      = [/^(hitoshi@namaraii.com|hoge@namaraii.com)$/]   # (7)

while true
  count = 0
  pop.start do |popmail, mail|
    count     = count + 1
    forward(mail, FORWARDADDR)                                   # (8)
  end
  if count > 0 
    puts "#{count} mail(s) forwarded." 
  else
    puts "no match."
  end

  sleep SLEEPTIME
end
