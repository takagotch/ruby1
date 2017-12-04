#!/usr/local/bin/ruby -Ks

require "minimize"

$w = BigFloat.new("70")
$A = BigFloat.new("1000000")
class Weight
  include Minimizer
  def doFunc(x)  # 目的関数の計算
     d = x[0] - $w
     e = x[0]*x[0]
     d*d + $A/e
  end
end

solver = Weight.new
x     = []
delta = []
x.push  BigFloat.new("100.0")       # xの初期値
delta.push  BigFloat.new("1")       # 最初に動かす幅
epsMove = BigFloat.new("0.1e-20")   # 動かす幅の最小値
f = solver.solve(x,delta,epsMove) 
printf("体重  =%s\n難度=%s",x[0],f)
