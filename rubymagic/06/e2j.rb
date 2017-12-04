#!/usr/bin/env ruby

#リスト6.17　e2j.rb

require 'nkf'
require 'fetchdoc'
require 'htmlutil'

include HTMLUtil

GooBase    = 'http://dictionary.goo.ne.jp'
GooCGI     = GooBase + '/cgi-bin/dict_search.cgi?sw=0&MT='      # (1)
LinkRegexp = 
  /<td nowrap>.*?<a href="(\/cgi-bin\/ej-more_print.cgi?[^"]*?)">/m 
                                                                # (2)
ContentsRegexp =  /■[^■]*/sm                                  # (3)
# EUC の場合 /em

def usage
  puts "usage: e2j.rb word"
  exit 1
end

def goo(html, http)
  html = NKF.nkf('-s', html)
  ContentsRegexp =~ html                                        # (4)
  contents = $&

  links = contents.scan(LinkRegexp).flatten                     # (5)

  if links.size > 0
    links.each do |l|                                           # (6)
      html = http.fetchdoc(GooBase + l)
      goo(html, http)                                           # (7)
    end
    return
  end

  HTMLUtil.html2txt(contents).each do |line|
    next if line.size == 0 || /^[\s　]*$/ =~ line               # (8)
    if (/^\w/ =~ line || /^■/ =~ line) && /^\w\./ !~ line
      puts "\n#{line}"
    else
      puts "\t#{line}"
    end
  end
end

usage if ARGV.size < 1

http = FetchDoc.new('e2j.rb/0.1')
html = http.fetchdoc(GooCGI + ARGV[0])                          # (9)

goo(html, http)                                                 # (10)
