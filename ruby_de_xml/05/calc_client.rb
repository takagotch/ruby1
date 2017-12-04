#!/usr/bin/env ruby

require 'xmlrpc/client'
require 'calc_conf'

client = XMLRPC::Client.new(HOST, '/RPC2', PORT) 

begin
  puts client.call("calc.add", 1, 2)
rescue XMLRPC::FaultException => e
  puts e.faultCode
  puts e.faultString
end

ok, res = client.call2("calc.add", 1, 2)
if ok
  puts res
else
  puts res.faultCode
  puts res.faultString
end

calc = client.proxy("calc")

puts calc.add(1, 2)

calc_1 = client.proxy("calc", 1)

puts calc_1.add(2)

calc_1_2 = client.proxy("calc", 1, 2)

puts calc_1_2.add
