#!/usr/bin/env ruby

require "rexml/document"
require "rexml/streamlistener"

class MyListener
  include REXML::StreamListener

  def initialize()
    @generals = {}
    class << @generals
      alias_method :entity, :[]
    end
    @parameters = @generals.clone
    clear
  end

  attr_reader :result
  def clear
    @result = ""
    @generals.clear
    @parameters.clear
  end

  ENTITY_RE = /#{REXML::Entity::PEREFERENCE}|#{REXML::Entity::REFERENCE}/u
  def entitydecl(content)
    unless content[1] =~ /^(PUBLIC|SYSTEM)$/ or
        content[0] == "%" && content[2] =~ /^(PUBLIC|SYSTEM)$/
      target = if content[0] == "%"
                 content.shift
                 @parameters
               else
                 @generals
               end
      content[1].gsub!(ENTITY_RE) do |ref|
        if ref[0] == ?&
          if ref[1] == ?#
            if ref[2] == ?x
              ref[0..1] = '0'
            else
              ref.slice!(/&#0*/)
            end
            [Integer(ref[0..-2])].pack('U*')
          else
            ref
          end
        else
          if @parameters.has_key? ref[1..-2]
            @parameters[ref[1..-2]]
          else
            ref
          end
        end
      end
      unless target.has_key? content[0]
        target[content[0]] = content[1]
      end
    end
  end

  def text(text)
    unnormalized_text = REXML::Text.unnormalize(text, @generals)
    @result << "Text = '#{unnormalized_text}'\n"
  end

  DEFAULT_ENTITIES = {
    'gt' => '>',
    'lt' => '<',
    'quot' => '"',
    "apos" => "'"
  }

  def tag_start(name, attrs)
    entities = @generals.clone.update(DEFAULT_ENTITIES)
    attrs.each do |attr|
      attr[1] = REXML::Text.unnormalize(attr[1], entities)
      @result << "Attribute = '#{attr[1]}'\n"
    end
  end

end

if $0 == __FILE__
  unless ARGV.empty?
    listener = MyListener.new
    File.open(ARGV.shift) do |source|
      REXML::Document.parse_stream(source, listener)
    end
    puts listener.result
    listener.instance_eval("p @generals")
  else
    puts "usage: #{$0} xml_file"
  end
end
