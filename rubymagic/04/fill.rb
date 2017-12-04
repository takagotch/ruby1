#¥ê¥¹¥È4.25¡¡fill.rb

$KCODE = "e"
require 'nkf'

class FillText
  DEFAULT_WIDTH  	= 70
  HeadInhibitChars	= /[¡¢¡£¡¤¡¥¡ª¡©¡§¡¨¡Ä¡Å¡Ë¡Ñ¡Ï¡Û¡Í¡×¡Ù¡ä¡Õ¡Ç¡É¡ë¡¼¡Á¡³¡´¡µ¡¶¡·¡¸¡¹¤ó¤Ã¤ã¤å¤ç¤¡¤£¤¥¤§¤©¥ó¥Ã¥ã¥å¥ç¥¡¥£¥¥¥§¥©]/o
  TailInhibitChars	= /[¡Ê¡Ð¡Î¡Ú¡Ì¡Ö¡Ø¡ã¡Ô¡Æ¡È]$/o
  ASCIIChars	= "[\\x21-\\x7e]"
  EUCChars  	= "[\\xa1-\\xfe]"
  DIGIT	= "[0-9£°-£¹]"
  ALPHA	= "[a-zA-Z£á-£ú£Á-£Ú]"
  DOT  	= "[\\.¡¥]"
  LTOENAIL	= "[\\(¡Ê]"
  RTOENAIL	= "[\\)¡Ë]"
  SPACE 	= "[\\s¡¡]"
  BULLET	= [                                            # (1)
    "#{DIGIT}+#{DOT}#{SPACE}+",
    "#{LTOENAIL}?#{DIGIT}+#{RTOENAIL}#{SPACE}+",
    "#{ALPHA}#{DOT}#{SPACE}+",
    "#{LTOENAIL}?#{ALPHA}#{RTOENAIL}#{SPACE}+",
    "#{DIGIT}+#{ALPHA}#{DOT}?#{SPACE}+",
    "#{LTOENAIL}?#{DIGIT}+#{ALPHA}#{RTOENAIL}#{SPACE}+",
    "[+\\-=*o]#{SPACE}+",
    "[¡¦¢£¢¢¢¥¢¤¢§¢¦¢¡¡þ¡û¡ý¡ü¡ø¡¦¢¨¡ù¡ú]",
  ]
  CITATION = [	                                                 # (2)
    '[#|>;%]+\s*',
    '\w+>\s*',
    '[¡ô¡Ã¡ä]',
  ]
  NOFILL   = [ 	                                                 # (3)
    '[A-Z][A-Za-z-]+?: '
  ]
  BulletRegexp   = Regexp.new('^(?:' + BULLET.join('|') + ')') 	   # (4)
  CitationRegexp = Regexp.new('^(?:' + CITATION.join('|') + ')')
  NoFillRegexp   = Regexp.new('^(?:' + NOFILL.join('|') + ')')
  PrefRegExp     = Regexp.new('^(?:' + BULLET.join('|') + '|' + 
      CITATION.join('|') + ')')

  def initialize(option)
    @width     = option['width']
    @outcode   = option['outcode']
    @paragraph = []
    @current   = []
  end

  def fill(line)                                                   # (5)
    line = NKF.nkf("-m0Xe", line)
    case line
    when /^\s*$/o
      push([:empty, nil, nil])
      flush
    when PrefRegExp
      token       = $&
      body        = $'.chop
      push([token =~ BulletRegexp ? :bullet : :citation, token, body])
    when NoFillRegexp
      push([:nofill, nil, line.chop])
    else
      push([:body, nil, line.chop])
    end
  end

  def flush                                                        # (6)
    pref = ""
    body = ""
    w    = @width
    type = nil

    @paragraph.each do |e|
      type = e[0]
      case type
      when :bullet
        fold(@width-e[1].size, type, e[1], e[2]) 
      when :citation
        pref, w = e[1], @width-e[1].size
        body << e[2]
      when :body
        body << " " if /#{ASCIIChars}$/o =~ body && /^#{ASCIIChars}/o =~ e[2]
        e[2].sub!(/^[\s¡¡]{2,}/o, ' ')
        body << e[2]
      when :nofill
        fold(@width, type, "", e[2])       
      when :empty
        fold(@width, type, "", "\n")
      end
    end

    fold(w, type, pref, body) if body.size > 0
    @paragraph = []
    @current   = []
  end

private
  def push(e)
    flush if @current != nil && @current[0] != e[0]
    @paragraph << e
    @current = e 
  end

  def fold(w, type, prefix, str)                                   # (7)
    str.gsub!(/(#{EUCChars}{2})(#{ASCIIChars})/no, "\\1 \\2")
    str.gsub!(/(#{ASCIIChars})(#{EUCChars}{2})/no, "\\1 \\2")

    if str.size <= w
      putsline prefix + str
      return
    end
    para     = ""
    nextline = ""
    letters  = str.scan(/./)

    letters.each_with_index do |c, idx|
      para.concat(c)
      next if /^#{ASCIIChars}+$/o =~ para
      if para.size >= w
        if c.size == 1 && c != " " && /#{ASCIIChars}/o =~ letters[idx+1]
          spc = para.rindex(" ") 
          if spc 
            nextline << para.slice!(spc+1, para.size)
            putsline prefix + para if para.size > 0
            para     = nextline
            nextline = ""
          end
          next
        end
        next if HeadInhibitChars =~ letters[idx+1]
        while TailInhibitChars =~ para
          tmp   = para.scan(/./)
          nextline << tmp.pop
          para  = tmp.join         
        end
        putsline prefix + para
        para     = nextline
        nextline = ""
        prefix   = " " * prefix.size if type == :bullet
      end
    end
    putsline prefix + para if para.size > 0
    putsline "\n" if type == :empty || type == :nofill
  end

  def putsline(line)
    puts NKF.nkf(@outcode, line)
  end
end

Cmdopt = {
  'outcode' => "-m0Xs",                                # default Shift JIS
  'width' => 70
}

while ARGV[0] =~ /^-/                                              # (8)
  option = ARGV.shift
  Cmdopt['outcode'] = option + "m0X" if option == "-e" || option == "-s"
  if option =~ /-w(\d*)/
    if $1 and not $1.empty?
      Cmdopt['width'] = $1.to_i
    else
      Cmdopt['width'] = ARGV.shift.to_i
    end
  end
end

f = FillText.new(Cmdopt)                                          # (9)

ARGF.each do |line|                                               # (10)
  f.fill(line) 
end
f.flush
