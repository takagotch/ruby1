#!/usr/bin/env ruby
  
require "soap/cgistub"
require "rxsh"
require "rxsh_conf"
require "rexml/document"
require "rexml/sax2parser"

RxshCGIConfigFile = "rxsh_cgi_conf.xml"

CONF = {
  "encoding" => nil,
  "xmldoc" => nil,
  "xpath_to_current" => nil
}

if File.exist?(RxshCGIConfigFile)
  File.open(RxshCGIConfigFile) do |conf|
    parser = REXML::SAX2Parser.new(conf)
    CONF.each do |key, value|
      parser.listen(:characters, [/^(#{key})$/]) do |text|
        CONF[key] = text
      end
    end
    parser.parse
  end
end

AppName = "RxshServer"

class RxshCGIServer < SOAP::CGIStub
  def initialize(*args)
    @rxsh = Rxsh.new(args[-1]["encoding"])

    class << @rxsh
      def _eval_input(input)
        res = if input[0] == ?!
                "You can't use shell command."
              else
                eval_input(input)
              end
        write
        res
      end
    end

    unless args[-1]["xmldoc"].nil?
      @rxsh._eval_input("cx #{args[-1]['xmldoc']}")
      unless args[-1]["xpath_to_current"].nil?
        @rxsh._eval_input("cn #{args[-1]['xpath_to_current']}")
      end
    end

    super(*args[0..-2])
  end

  def methodDef
    addMethodAs(@rxsh, "_eval_input", "eval_input", "input")
  end

  CONF_CMD = {
    "encoding" => ["enc"],
    "xmldoc" => ["_eval_input", "pwx"],
    "xpath_to_current" => ["_eval_input", "pwn"]
  }
  def write(filename)
    doc = REXML::Document.new
    doc.add(REXML::XMLDecl.new)
    doc.add_element("rxsh_conf")
    CONF_CMD.each do |elem_name, cmd|
      doc.root.add_element(elem_name).text = @rxsh.send(*cmd)
    end
    File.open(filename, "w") do |file|
      doc.write(file)
    end
  end

end

server = RxshCGIServer.new(AppName, RxshNS, CONF)

server.start

server.write(RxshCGIConfigFile)
