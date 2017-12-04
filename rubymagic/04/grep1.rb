#ƒŠƒXƒg4.9@grep1.rb

def textfilter(pattern, line)                                   # (1)
  puts line if pattern =~ line                                  # (2)
end

while ARGV[0] =~ /^-/
  ARGV.shift
end

if ARGV.size == 0                                               # (3)
  $stderr.puts "usage:#{File.basename($0)} <PATTERN> [files...]"
  exit 2
end

pattern = Regexp.new(ARGV.shift)                                # (4)

ARGF.each {|line| textfilter(pattern, line)}
