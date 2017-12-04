#!/usr/bin/env ruby

require "xmlrpc/client"

# à»â∫ÇìKìñÇ…ïœÇ¶ÇÈÅB
host = "www.oreillynet.com"
path = "/meerkat/xml-rpc/server.php"
port = 80
proxy_host = nil
proxy_port = nil
user = nil
password = nil
use_ssl = false
timeout = nil

client = XMLRPC::Client.new(host, path, port, proxy_host, proxy_port,
			     user, password, use_ssl, timeout)

client.call('system.listMethods').each do |method|
  puts method
  puts "\thelp: #{client.call('system.methodHelp', method)}"
  sigs = client.call('system.methodSignature', method)
  if sigs.kind_of? Array
    sigs.each do |sig|
      puts "\t ret: #{sig[0]}"
      puts "\tpara: #{sig[1..-1].join(', ')}"
    end
  else 
    puts "\t ret: Unknown"
    puts "\tpara: Unknown"
  end
  puts
end
