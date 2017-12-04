#!/usr/local/bin/ruby -Ks

#
# linear.rb
#
# 線形連立方程式 A*x = b を解く。
#  ここで A は係数行列、x は解ベクトル、b は右辺定数ベクトル。
#
require "BigFloat"
require "ludcmp"

include LUSolve

def rd_order
   printf("変数の数 ?")
   n = gets().chomp.to_i
end

zero = BigFloat::new("0.0")
one  = BigFloat::new("1.0")

while (n=rd_order())>0
  a = []
  as= []
  b = []
  printf("\n係数行列 A[i,j] の入力\n");
  for i in 0...n do
    for j in 0...n do
      printf("A[%d,%d]? ",i,j); s = gets
      a <<=BigFloat::new(s);
      as<<=BigFloat::new(s);
    end
    printf("右辺定数項 b[%d] ? ",i);b<<=BigFloat::new(gets);
  end
  printf "ANS="
  x = lusolve(a,b,ludecomp(a,n,zero,one),zero)
  p x
  printf "A*x-b\n"
  for i in 0...n do
    s = zero
    for j in 0...n do
       s = s + as[i*n+j]*x[j]
    end
    p s-b[i]
  end
end
