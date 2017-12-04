#!/usr/bin/env ruby

#ÉäÉXÉg6.16Å@gurupalm.rb

require 'nkf'
require 'fetchdoc'
require 'htmlutil'
require 'makedoc'
require 'tempfile'

include PalmDoc                                                 # (1)
include HTMLUtil

SITEDIR = './sites'
DOCDIR  = './doc'                                               # (2)

def getSites
  sites = Array.new
  
  Dir.glob("#{SITEDIR}/*").each do |f|
    h = Hash.new
    open(f).each do |line|
      next if /^#/ =~ line
      /^([^=]+?)=(.*)$/ =~ line
      next unless $1 and $2
      h[$1.strip] = $2.strip
    end
    h['CFGFILE'] = NKF.nkf('-s', f)
    sites << h
  end
  return sites
end

http = FetchDoc.new('gurupalm.rb/0.1')

getSites.each do |site|
  next unless site['URL']

  title = File.basename(site['CFGFILE'])
  title = site['SITENAME'] if site['SITENAME']

  puts "Fetching #{site['URL']}"
  html = http.fetchdoc(site['URL'])
  unless html
    puts "failed - #{title}\n\n"
    next
  end

  html = NKF.nkf('-s', html)

  if site['BEGIN']
    str = Regexp.quote(site['BEGIN'])
    Regexp.new(str).match(html)
    html = $'
  end

  if site['END']
    str = Regexp.quote(site['END'])
    Regexp.new(str).match(html)
    html = $`
  end

  next unless html

  puts "done - #{title}\n\n"

  tempfile = Tempfile.new('gurup')                              # (3)
  tempfile.puts NKF.nkf('-s', HTMLUtil.html2txt(html))
  tempfile.close(false)
  
  prcfile = "#{DOCDIR}/#{File.basename(site['CFGFILE'])}.prc"
  open(tempfile.path, 'rb') {|fin|
    open(prcfile, 'wb') {|fout|
      PalmDoc::encode(fin, fout, NKF.nkf('-s', title), {})      # (4)
    }
  }
end
