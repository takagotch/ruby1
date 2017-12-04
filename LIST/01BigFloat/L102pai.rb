#!/usr/local/bin/ruby

#
# pai.rb
#

require "BigFloat"
#
# Calculates 3.1415.... using J. Machin's formula.
#
def pai(sig) # sig: Number of significant figures
  exp    = -sig
  pi     = BigFloat::new("0")
  two    = BigFloat::new("2")
  m25    = BigFloat::new("-0.04")
  m57121 = BigFloat::new("-57121")

  u = BigFloat::new("1")
  k = BigFloat::new("1")
  w = BigFloat::new("1")
  t = BigFloat::new("-80")
  while (u.exponent >= exp) 
    t   = t*m25
    u,r = t.div(k,sig)
    pi  = pi + u
    k   = k+two
  end

  u = BigFloat::new("1")
  k = BigFloat::new("1")
  w = BigFloat::new("1")
  t = BigFloat::new("956")
  while (u.exponent >= exp )
    t,r = t.div(m57121,sig)
    u,r = t.div(k,sig)
    pi  = pi + u
    k   = k+two
  end
  pi
end

if $0 == __FILE__
  print "PAI("+ARGV[0]+"):\n"
  p pai(ARGV[0].to_i)
end
