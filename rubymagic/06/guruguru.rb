#!/usr/bin/env ruby

#ÉäÉXÉg6.11Å@guruguru.rb

require 'nkf'
require 'fetchdoc'
require 'htmlutil'

include HTMLUtil

SITEDIR = './sites/'                                       # (1)

def getSites
  sites = Array.new
  
  Dir.glob("#{SITEDIR}/*").each do |f|                     # (2)
    next if test(?d, f)
    h = Hash.new
    open(f).each do |line|
      next if /^[ \t]*#/ =~ line                           # (3)
      /^([^=]+?)=(.*)$/ =~ line                            # (4)
      next unless $1 and $2
      h[$1.strip] = $2.strip                               # (5)
    end
    h['CFGFILE'] = NKF.nkf('-s', f)
    sites << h
  end
  return sites
end

http = FetchDoc.new('guruguru.rb/0.1')
  
getSites.each do |site|                                    # (6)
  next unless site['URL']                                  # (7)
  html = NKF.nkf('-s', http.fetchdoc(site['URL']))
  title = html.scan(/<title>(.*)<\/title>/mi).flatten[0]   # (8)

  if site['BEGIN']                                         # (9)
    str = Regexp.quote(site['BEGIN'])
    Regexp.new(str).match(html)
    html = $'
  end

  if site['END']                                           # (10)
    str = Regexp.quote(site['END'])
    Regexp.new(str).match(html)
    html = $`
  end

  puts "*" * 60
  title = site['SITENAME'] if site['SITENAME']
  puts title
  puts "*" * 60
  puts HTMLUtil.html2txt(html) if html                     # (11)
end
