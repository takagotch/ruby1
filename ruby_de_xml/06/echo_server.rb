#!/usr/bin/env ruby

require "soap/standaloneServer"

class EchoServer < SOAP::StandaloneServer
  
  def initialize(*args)
    super
  end
  
  def methodDef
    addMethod(self, "two_times", "string")
    addMethodAs(self, "two_times", "nikai", "string")
    addMethodWithNS("http://echo3.org/", self,
                    "three_times", "string")
    addMethodWithNSAs("http://echo3.org/", self,
                      "three_times", "sankai", "string")
  end
  
  private
  def two_times(string)
    string * 2
  end
  
  def three_times(string)
    string * 3
  end
  
end

server = EchoServer.new(nil, "http://echo2.org/")

server.start
