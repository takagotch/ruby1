#ÉäÉXÉg4.5Å@mynkf.rb

require 'nkf'

def textfilter(opt, line)
  puts NKF.nkf(opt, line)                             # (1)
end

option = Array.new

while ARGV[0] =~ /^-/
  option << ARGV.shift                                # (2)
end

ARGF.each {|line| textfilter(option.join(' '), line)} # (3)
