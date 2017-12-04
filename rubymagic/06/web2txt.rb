#!/usr/bin/env ruby

#ƒŠƒXƒg6.9@web2txt.rb

require 'nkf'
require 'fetchdoc'
require 'htmlutil'

include HTMLUtil

def usage
  puts "usage: web2txt.rb <HTTP URL>"
  exit 1
end

usage if ARGV.size < 1

http = FetchDoc.new
html = http.fetchdoc(ARGV[0])

puts HTMLUtil.html2txt(NKF.nkf('-s', html))
