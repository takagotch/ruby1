#!/usr/local/bin/ruby

require "BigFloat"

f = BigFloat::mode(BigFloat::EXCEPTION_ALL,nil)
p f
#f = BigFloat::mode(BigFloat::EXCEPTION_NaN,true)
f = BigFloat::mode(BigFloat::EXCEPTION_INFINITY,true)
p f
p BigFloat.new("NaN")
p BigFloat.new("Infinity")
