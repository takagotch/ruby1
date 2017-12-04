#!/usr/local/bin/ruby -Ks

require "ludcmp"

include LUSolve

a = [1.0,2.0,3.0,4.0]
b = [3.0,2.0]

ps = ludecomp!(a,2)
x  = lusolve(a,b,ps,n)
p x
