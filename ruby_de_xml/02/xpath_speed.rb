#!/usr/bin/env ruby

require 'rexml/document'

if ARGV.shift == 'xpath'
  xpath = REXML::XPath
else
  require 'rexml/quickpath'
  xpath = REXML::QuickPath
end

p xpath

filename = ARGV.shift || File.join('..', 'etc', 'mathml.rlx') 

File.open(filename) do |xml|
  before = Time.now
  doc = REXML::Document.new(xml)
  p Time.now - before
  before = Time.now
  p xpath.match(doc, '//ref').size
  p Time.now - before
end
