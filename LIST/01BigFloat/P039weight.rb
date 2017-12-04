#!/usr/local/bin/ruby -Ks

require "minimize"

$w = BigFloat.new("70")
$A = BigFloat.new("1000000")
class Weight
  include Minimizer
  def doFunc(x)  # �ړI�֐��̌v�Z
     d = x[0] - $w
     e = x[0]*x[0]
     d*d + $A/e
  end
end

solver = Weight.new
x     = []
delta = []
x.push  BigFloat.new("100.0")       # x�̏����l
delta.push  BigFloat.new("1")       # �ŏ��ɓ�������
epsMove = BigFloat.new("0.1e-20")   # ���������̍ŏ��l
f = solver.solve(x,delta,epsMove) 
printf("�̏d  =%s\n��x=%s",x[0],f)
