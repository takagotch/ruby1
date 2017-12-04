#ÉäÉXÉg4.8Å@osaka.rb

$KCODE = 's'                    # n:none, e:EUC, s:Shift-JIS, u:UTF-8

Delimiter = '%%%'
DicFile = "osaka.dic"
@dic = Hash.new

def textfilter(line)
  @dic.each_key {|e| line.gsub!(e, @dic[e])}
  puts line.gsub(/#{Delimiter}/o, '')                       # (1)
end

def readDic
  File.foreach(DicFile) do |line|
    line = line.chomp!
    s1, s2 = line.split
    strTo = s2.scan(/./).join(Delimiter) + Delimiter        # (2)
    @dic[Regexp.new(s1, false)] = strTo
  end
end

readDic

while ARGV[0] =~ /^-/
  ARGV.shift
end

ARGF.each {|line| textfilter(line)}
