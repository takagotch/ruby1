#!/usr/bin/env ruby
  
require "soap/standaloneServer"
require "rxsh"
require "rxsh_conf"

AppName = "RxshServer"

class RxshServer < SOAP::StandaloneServer
  def initialize(*args)
    @rxsh = Rxsh.new(args[-1])

    class << @rxsh
      def _eval_input(input)
        if input[0] == ?!
          "You can't use shell command."
        else
          eval_input(input)
        end
      end
    end

    super(*args[0..-2])
  end

  def methodDef
    addMethodAs(@rxsh, "_eval_input", "eval_input", "input")
  end

end

server = RxshServer.new(AppName, RxshNS, RxshHost, RxshPort, ARGV[0])

server.start
