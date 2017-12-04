#!/usr/bin/env ruby

#ƒŠƒXƒg6.20@getimg.rb

require 'fetchdoc'
require 'htmlutil'
require 'uri'

include HTMLUtil

IMAGE_DIR = './'                                                # (1)
SrcRegexp    = /\ssrc\s*=\s*"?([^"\s>]+)/mi                     # (2)
ImgTagRegexp = /<img\s[^>]*?>/mi                                # (3)

def getAbsPath(baseuri, currenturi)                             # (4)
  begin
    uri = URI.parse(currenturi)
  rescue
    puts "Invalid URI? \"#{currenturi}\""
    return nil
  end

  if uri.host
    server = uri.host
    path =   uri.path
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

def getImage(uri)
  http = FetchDoc.new('getimg.rb/0.1')
  begin
    html = http.fetchdoc(uri)                                   # (5)
  rescue
    puts "getImage failed: \"#{uri}\""
    return
  end

  imgTags = html.scan(ImgTagRegexp)                             # (6)
  imgTags.each do |img|
    if SrcRegexp =~ img                                         # (7)
      src = $1.gsub(/[\n\r]/m, '')
    else
      next
    end
    imageuri = getAbsPath(URI.parse(uri), src)

    puts "Getting #{imageuri}"    
    filename = IMAGE_DIR + File.basename(src)                   # (8)
    begin
      File.open(filename, "wb") do |f|                          # (9)
        image = http.fetchdoc(imageuri)
        raise "can't fetch \"#{uri}\"" unless image
        f.write http.fetchdoc(imageuri)
        puts "wrote #{IMAGE_DIR}#{File.basename(src)}\n\n"
      end
    rescue
      puts "write failed: \"#{imageuri}\"\n\n"
      File.delete(filename) if test(?e, filename)
    end
  end
end

def usage
  puts "usage: getimg.rb <HTTP URI>"
  exit 1
end

usage if ARGV.size < 1

getImage(ARGV[0])                                               # (10)
