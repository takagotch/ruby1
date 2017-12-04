#!/usr/local/bin/ruby -Ks

require "minimize"

$v = BigFloat.new(ARGV.shift)
class Sqrt
  include Minimizer
  def doFunc(x)  # �ړI�֐��̌v�Z
     (x[0]*x[0] - $v).abs   # x**2 - v => 0�ix��v�̕������Ax=sqrt(v)�j
  end
end

solver = Sqrt.new
x     = []
delta = []
x.push  BigFloat.new("0.0")         # x�̏����l
delta.push  BigFloat.new("0.1")     # �ŏ���y�𓮂�����
epsFunc = BigFloat.new("0.1e-30")   # �֐��̎�������萔
epsMove = BigFloat.new("0.1e-50")   # ���������̍ŏ��l
f = solver.solve(x,delta,epsMove,epsFunc)
printf("����  =%s\n�֐��l=%s",x[0],f)
