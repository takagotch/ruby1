#!/usr/bin/env ruby

#ƒŠƒXƒg6.5@webget.rb

require 'fetchdoc'
require 'nkf'

def usage
  puts "usage: webget.rb <HTTP URL>"
  exit 1
end

usage if ARGV.size < 1

http = FetchDoc.new
html = http.fetchdoc(ARGV[0])

puts NKF.nkf('-s', html)
