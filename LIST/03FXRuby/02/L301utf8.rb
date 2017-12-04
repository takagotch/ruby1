#!/usr/local/bin/ruby

require 'nkf'
require 'uconv'

ARGF.each do |line|
  print Uconv::euctou8(NKF::nkf('-e', line))
end
