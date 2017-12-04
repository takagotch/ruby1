#!/usr/local/bin/ruby

#ÉäÉXÉg4.4Å@nkfsample.rb

require 'nkf'

opt = ''
opt = ARGV.shift if ARGV[0][0] == ?-

while line = ARGF.gets
  print NKF.nkf(opt, line)
end
