#!/usr/bin/env ruby

require "soap/driver"
require "rxsh_conf"
require "uconv"

class RxshClient

  def initialize(*args)
    @driver = SOAP::Driver.new(*args)
    @driver.setWireDumpDev(File.open("rxsh_wire_dump.log", "w"))
    @driver.setWireDumpFileBase("rxsh_wire_dump")
    
    @driver.addMethod("eval_input", "input")

    @encoding = @driver.eval_input("enc")
  end

  def from_u8(string)
    if @encoding.nil? or @encoding.empty?
      string
    else
      Uconv.send("u8to#{@encoding}", string)
    end
  end
  
  def start
    print "rxsh> "
    $stdin.each do |input|
      input.strip!
      break if input =~ /^exit$/
      puts(from_u8(@driver.eval_input(input))) unless input.empty?
      @driver.eval_input("write")
      @encoding = @driver.eval_input("enc")
      print "rxsh> "
    end
    puts
  end

end

log = Devel::Logger.new("rxsh.log", "daily")
log_id = "Rxsh SOAP Client"

if ARGV.shift == "cgi"
  url = "http://localhost/rxsh_cgi.rb"
else
  url = "http://#{RxshHost}:#{RxshPort}"
end

client = RxshClient.new(log, log_id, RxshNS, url)

client.start
