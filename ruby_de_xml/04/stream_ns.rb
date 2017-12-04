#!/usr/bin/env ruby

require "rexml/document"
require "rexml/streamlistener"

class MyListener
  include REXML::StreamListener

  def initialize(indent_size=2)
    @stack = [{}]
    @indent_size = indent_size
    clear
  end
  attr_reader :result

  def clear
    @result = ""
  end

  def tag_start(name, attrs)
    @stack.push(get_ns_info(attrs, @stack[-1].dup))
    indent = ' ' * @indent_size * (@stack.size - 2)
    @result << "#{indent}#{to_expanded_name(name)}\n"
    indent << ' ' * @indent_size
    attrs.each do |attr|
      @result << "#{indent}#{to_expanded_name(attr[0], false)}='#{attr[1]}'\n"
    end
  end

  def tag_end(name)
    indent = ' ' * @indent_size * (@stack.size - 2)
    @result << "#{indent}#{to_expanded_name(name)}\n"
    @stack.pop
  end

  private
  def to_expanded_name(name, element=true)
    ns = @stack[-1]
    if name =~ /^([^:]*)(:[^:]*)$/u
      return ns[$1] + $2 if ns.has_key? $1
    elsif element and ns.has_key? :default and !ns[:default].empty?
      return "#{ns[:default]}:#{name}"
    end
    name
  end

  def get_ns_info(attrs, ns)
    attrs.each do |attr|
      if attr[0] =~ /^xmlns(.*)$/u
        if $1.empty?
          ns[:default] = attr[1]
        else
          ns[$1[1..-1]] = attr[1]
        end
      end
    end
    ns
  end

end

if $0 == __FILE__
  unless ARGV.empty?
    listener = if ARGV[1].nil?
		 MyListener.new
	       else
		 MyListener.new(ARGV[1].to_i)
	       end
    File.open(ARGV.shift) do |source|
      REXML::Document.parse_stream(source, listener)
    end
    puts listener.result
  else
    puts "usage: #{$0} xml_file [indent_size=2]"
  end
end
