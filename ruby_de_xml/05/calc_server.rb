#!/usr/bin/env ruby

require 'xmlrpc/server'
require 'calc_conf'

server = XMLRPC::Server.new(PORT, HOST)

interface = XMLRPC::Service::Interface.new("calc") do
  add_method(["double add(double, double)"], "A + B")
  add_method(["double sub(double, double)"], "A - B", "fuga")
  add_method(["double multi(double, double)"], "A * B")
  add_method(["double div(double, double)"], "A / B")
end

class Calc
  
  def add(a, b)
    a + b
  end
  
  def sub(*args)
    raise XMLRPC::FaultException.new(2, "sub")
  end
  
  def fuga(a, b)
    a - b
  end
  
  def multi(a, b)
    a * b
  end
  
  def div(a, b)
    a / b
  end
  
end

server.add_handler(interface, Calc.new)

server.serve
