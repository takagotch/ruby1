#!/usr/bin/env ruby

require "rexml/sax2parser"
require "rexml/sax2listener"

class MySAX2Listener
  include REXML::SAX2Listener
  
  attr_reader :name, :doc
  def initialize(name)
    @name = name
    clear
  end
  
  def clear
    @doc = REXML::Document.new
    @parent_stack = [@doc]
  end
  
  def start_element(uri, localname, qname, attrs)
    if qname != @name
      @parent_stack.push(REXML::Element.new(qname, @parent_stack[-1]))
      @parent_stack[-1].add_attributes(attrs)
    end
  end
  
  def end_element(uri, localname, qname)
    @parent_stack.pop if qname != @name
  end
  
end

if $0 == __FILE__
  if ARGV.size < 2
    puts "usage: #{$0} xml_file elem_name"
  else
    File.open(ARGV.shift) do |xml|
      parser = REXML::SAX2Parser.new(xml)
      listener = MySAX2Listener.new(ARGV.shift)
      parser.listen(listener)
      parser.parse
      puts listener.doc.to_s
    end
  end
end
