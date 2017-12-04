#ÉäÉXÉg4.1Å@filter1.rb

def textfilter(line)                           # (1)
  puts line
end

if ARGV.size == 0                              # (2)
  STDIN.each {|line| textfilter(line)}
else
  while filename = ARGV.shift                  # (3)
    File.open(filename) do |f| 
      f.each {|line| textfilter(line)}
    end
  end
end
