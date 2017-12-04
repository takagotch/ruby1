#ƒŠƒXƒg4.12@myfill.rb

class FillText
  def initialize(w)
    @width = w
    @str = ''
  end
  def fill(line)
    (flush; puts "\n"; return) if /^\s*$/ =~line
    line.scan(/./).each do |c|                            # (1)
      @str.concat(c)
      if @str.size >= @width
        puts @str
        @str = ''
      end
    end
  end
  def flush                                                # (2)
    puts @str + "\n"
    @str = ''
  end
end

width = 70

if ARGV[0] =~ /-w(\d*)/                                    # (3)
  ARGV.shift
  if $1 and not $1.empty?
    width = $1.to_i
  else
    width = ARGV.shift.to_i
  end
end
  
f = FillText.new(width)                                    # (4)

ARGF.each do |line|                                        # (5)
  f.fill(line)
end

f.flush                                                    # (6)
