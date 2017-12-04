#ƒŠƒXƒg4.2@filter2.rb
def textfilter(line)
  puts line
end

ARGF.each {|line| textfilter(line)}
