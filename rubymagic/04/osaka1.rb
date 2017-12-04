#ÉäÉXÉg4.7Å@osaka1.rb

$KCODE = 's'                    # n:none, e:EUC, s:Shift-JIS, u:UTF-8

DicFile = "osaka.dic"
@dic = Hash.new

def textfilter(line)
  @dic.each_key {|e| line.gsub!(e, @dic[e])}                # (1)
  puts line
end

def readDic
  File.foreach(DicFile) do |line|                           # (2)
    line = line.chomp!
    s1, s2 = line.split
    @dic[Regexp.new(s1, false)] = s2
  end
end

readDic

while ARGV[0] =~ /^-/
  ARGV.shift
end

ARGF.each {|line| textfilter(line)}
