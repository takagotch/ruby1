#!/usr/bin/env ruby

api = ARGV.shift

case api
when 'sax'
  require "rexml/sax2parser"
  require "rexml/sax2listener"
  class MySAX2Listener
    include REXML::SAX2Listener
  end
when 'pull'
  require "rexml/pullparser"
else
  require "rexml/document"
  require "rexml/streamlistener"
  class MyListener
    include REXML::StreamListener
  end
  api = "stream"
end

p api  

filename = ARGV.shift || File.join('..', 'etc', 'mathml.rlx') 

File.open(filename) do |xml|
  before = Time.now
  case api
  when 'sax'
    parser = REXML::SAX2Parser.new(xml)
    parser.listen(MySAX2Listener.new)
    parser.parse
  when 'pull'
    parser = REXML::PullParser.new(xml)
    parser.next while parser.has_next?
  else
    REXML::Document.parse_stream(xml, MyListener.new)
  end
  p Time.now - before
end
