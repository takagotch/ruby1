#!/usr/bin/env ruby

#ÉäÉXÉg6.21Å@getimage.rb

require 'fetchdoc'
require 'htmlutil'
require 'uri'
require 'getopts'
require 'norobots'

include HTMLUtil

class MyNoRobots < NoRobots                                     # (1)
  def initialize(host)
    @host = host
    path  = '/robots.txt'
    http  = FetchDoc.new('getimage.rb/0.1')
    robotstxt = http.fetchdoc("http://#{host}#{path}")  || ''
    parse(robotstxt)
  end
end

HrefRegexp   = /<a.*?href\s*=\s*"?([^"\s>]+)/mi                 # (2)
Images       = '(?:jpe?g)|(?:gif)|(?:png)|(?:bmp)'
ImageRegexp  = /#{Images}/i
ImgTagRegexp = /<img\s[^>]*?>/mi
SrcRegexp    = /\ssrc\s*=\s*"?([^"\s>]+)/mi

UA           = 'getimage.rb/0.1'

@checkedUri = []
@image_dir  = './'
@max_level  = 1

def getAbsPath(baseuri, currenturi)
  begin
    uri = URI.parse(currenturi)
  rescue
    puts "Invalid URI? \"#{currenturi}\""
    return nil
  end

  if uri.host 
    server = uri.host
    path   = uri.path
  else
    server = baseuri.host
    
    basepath = (File.dirname(baseuri.path) + '/').gsub(/\/\//, '/')
    path = basepath + uri.path if uri.path
  end
  return if path == nil || path.size == 0

  a = Array.new
  path.split('/').each do |p|
    if p == ".."
      a.pop
    else
      a.push(p)
    end
  end

  abspath = a.join('/')
  abspath = abspath + '/' if path[-1].chr == '/'

  return "http://#{server}#{abspath}#{uri.query}"
end

def extractLinks(uri, http, html)                               # (3)
  links = []

  html.scan(HrefRegexp).flatten.each do |l|
    u = getAbsPath(URI.parse(uri), l)
    next unless u
    cururi = URI.parse(u)
    next if cururi.scheme != 'http' ||                          # (4)
            /(?:(?:html?)|#{Images}|(?:\/))$/ !~ cururi.path ||
            links.index(u) != nil
    links << u
  end

  return links
end

def getImage(uri, http, html)
  imgTags = html.scan(ImgTagRegexp)
  imgTags.each do |img|
    if SrcRegexp =~ img
      src = $1.gsub(/[\n\r]/m, '')
    else
      next
    end
    u = getAbsPath(URI.parse(uri), src)
    writeImage(u, http) if u
  end
end

def writeImage(uri, http)                                       # (5)
  u = URI.parse(uri)
  norobots = MyNoRobots.new(u.host)
  return if @checkedUri.index(uri) || 
            !norobots.isaccessable?(UA, u.request_uri)          # (6)
  @checkedUri << uri                                            # (A)
  
  puts "Getting #{uri}"
  filename = checkFilename(@image_dir + File.basename(uri))     # (7)
  begin
    File.open(filename, "wb") do |f|
      image = http.fetchdoc(uri)
      raise "can't fetch \"#{uri}\"" unless image
      f.write image
      puts "wrote #{filename}\n\n"
    end
  rescue
    puts "write failed: \"#{uri}\""
    File.delete(filename) if test(?e, filename)
  end
end

def checkFilename(filename)                                     # (8)
  f = File.basename(filename)
  d = File.dirname(filename)
  while test(?e, "#{d}/#{f}")
    tmp = f.split('.')
    f = "#{tmp[0].succ}.#{tmp[1]}"
  end
  return "#{d}/#{f}"
end

def main(uri, http, level)
  u = URI.parse(uri)
  norobots = MyNoRobots.new(u.host)                             # (9)
  return if @checkedUri.index(uri) || 
            !norobots.isaccessable?(UA, u.request_uri)          #(10)

  puts "-----> ENTERING #{uri} (level #{level})"

  @checkedUri << uri                                            # (A)
  begin
    html = http.fetchdoc(uri)
    raise "can't fetch \"#{uri}\"" unless html
  rescue
    return
  end

  getImage(uri, http, html)                                     # (11)

  href = []
  img = []

  extractLinks(uri, http, html).each do |l|                     # (12)
    if /html?$/ =~ l || l[-1].chr == '/'
      href << l
    elsif /#{Images}$/ =~ l
      img << l
    end
  end

  img.each {|imageuri| writeImage(imageuri, http)}              # (13)
  href.each {|href| main(href, http, level+1)} if level < @max_level
                                                                # (14)
end

def usage
  puts "usage: getimage.rb [-r NUMBER] [-d IMAGEDIR] <HTTP URI>"
  exit 1
end

getopts(nil, "r:", "d:")                                        # (15)
if $OPT_d
  @image_dir = $OPT_d
  @image_dir = @image_dir + '/' if $OPT_d[-1].chr != '/'
end
@max_level = $OPT_r.to_i if $OPT_r

usage if ARGV.size < 1

http = FetchDoc.new(UA)

main(ARGV[0], http, 1)
