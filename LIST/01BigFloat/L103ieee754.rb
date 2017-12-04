#!/usr/local/bin/ruby

#
# ieee754.rb
#
def check(arg,opa,aa,ba)
  for op in opa
    for a in aa
      for b in ba
        if arg=="b"
          x = BigFloat::new(a)
          y = BigFloat::new(b)
        else
          x = a
          y = b
        end
        eval("ans = x #{op} y;print a,' ',op,' ',b,' ==> ',ans.to_s,\"\n\"")
      end
    end
  end
end

if ARGV[0]=="b"
  require "BigFloat"
  print "BigFloat operations\n"
  aa  = %w(1 -1 +0.0 -0.0)
  ba  = %w(+Infinity -Infinity NaN)
else
  print "Ruby Float operations\n"
  pinf = 1.0/0.0
  ninf = -1.0/0.0
  nan  = 0.0/0.0
  aa  = [1,-1,+0.0,-0.0]
  ba  = [pinf,ninf,nan]
end
opa = %w(+ - * / > >=  < == != <=)

check(ARGV[0],opa,aa,ba)
check(ARGV[0],opa,ba,ba)
