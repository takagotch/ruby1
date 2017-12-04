#ÉäÉXÉg5.6Å@checkmail.rb

require 'net/pop'
require 'tmail'
require 'nkf'

class CheckMail
  COND_AND = :cond_and
  COND_OR  = :cond_or

  attr_accessor :subject
  attr_accessor :from
  attr_accessor :readCheck
  attr_accessor :port
  attr_accessor :condition
  attr_accessor :code

  def initialize(server, uid, passwd)
    @server     = server
    @port       = 110
    @uid        = uid
    @passwd     = passwd
    @subject    = []
    @from       = []
    @message_id = []
    @readCheck  = true
    @condition  = COND_OR
    @code       = "s"
  end

  def start 
    @current_id = []
    @maillist   = []
    count       = 1
    Net::POP3.start(@server, @port, @uid, @passwd) do |pop|
      pop.each do |m|
        mail = TMail::Mail.parse(m.pop)
        yield(m, mail) if match(mail)
      end
    end
    @message_id = @current_id
  end

  private
  def match(mail)
    from_match = subject_match = false

    @from.each do |re|
      if re =~ mail.from_addrs[0].addr and checkMsgId(mail.message_id)
        from_match = true
        break
      end
    end if @from

    @subject.each do |re|
      if re =~ NKF.nkf("-#{@code}", mail.subject || '') and 
               checkMsgId(mail.message_id)
        subject_match = true
        break
      end
    end if @subject

    case @condition
    when COND_OR 
      return true if from_match or subject_match
    when COND_AND
      return true if from_match and subject_match
    end
    return checkMsgId(mail.message_id) if @from.size == 0 and 
                                          @subject.size == 0

    false
  end

  def checkMsgId(msgid)
    return true unless @readCheck
    
    @current_id << msgid
    unless @message_id.index(msgid) and @message_id.size > 0
      return true
    end
    return false
  end
end   
