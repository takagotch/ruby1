#ƒŠƒXƒg4.3@filter.rb

def textfilter(line)
  puts line
end

while ARGV[0] =~ /^-/               # (1)
  ARGV.shift
end

ARGF.each {|line| textfilter(line)}
