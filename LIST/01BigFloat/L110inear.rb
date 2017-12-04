#!/usr/local/bin/ruby -Ks

#
# linear.rb
#
# ���`�A�������� A*x = b �������B
#  ������ A �͌W���s��Ax �͉��x�N�g���Ab �͉E�Ӓ萔�x�N�g���B
#
require "BigFloat"
require "ludcmp"

include LUSolve

def rd_order
   printf("�ϐ��̐� ?")
   n = gets().chomp.to_i
end

zero = BigFloat::new("0.0")
one  = BigFloat::new("1.0")

while (n=rd_order())>0
  a = []
  as= []
  b = []
  printf("\n�W���s�� A[i,j] �̓���\n");
  for i in 0...n do
    for j in 0...n do
      printf("A[%d,%d]? ",i,j); s = gets
      a <<=BigFloat::new(s);
      as<<=BigFloat::new(s);
    end
    printf("�E�Ӓ萔�� b[%d] ? ",i);b<<=BigFloat::new(gets);
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
