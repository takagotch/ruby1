#!/usr/local/bin/ruby -Ks

#
# direct.rb
#
require "minimize"

$v = BigFloat.new("2.0")

class NlSolve
  include Minimizer
  def doFunc(x) # �ړI�֐���K���Ē�`����
    f1 = x[0]*x[0] + x[1]*x[1] - $v   # f1 = x**2 + y**2 - 2 => 0
    f2 = x[0] - x[1]                  # f2 = x    - y        => 0
    f1*f1+f2*f2                       # f1*f1+f2*f2 <= epsFunc �܂ŌJ��Ԃ��B
  end
end

solver = NlSolve.new 
x     = []
delta = []
x.push  BigFloat.new("0.0")         # x�̏����l
x.push  BigFloat.new("0.0")         # y�̏����l
delta.push  BigFloat.new("0.1")     # �ŏ���x�𓮂�����
delta.push  BigFloat.new("0.1")     # �ŏ���y�𓮂�����
epsFunc = BigFloat.new("0.1e-30")   # �֐��̎�������萔
epsMove = BigFloat.new("0.1e-50")   # ���������̍ŏ��l
f = solver.solve(x,delta,epsMove,epsFunc) 
printf("����=X:%s \n    =Y:%s\n�֐��l=%s\n",x[0],x[1],f)
