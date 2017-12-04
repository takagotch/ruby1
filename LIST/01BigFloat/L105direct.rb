#!/usr/local/bin/ruby -Ks

#
# direct.rb
#
require "minimize"

$v = BigFloat.new("2.0")

class NlSolve
  include Minimizer
  def doFunc(x) # 目的関数を必ず再定義する
    f1 = x[0]*x[0] + x[1]*x[1] - $v   # f1 = x**2 + y**2 - 2 => 0
    f2 = x[0] - x[1]                  # f2 = x    - y        => 0
    f1*f1+f2*f2                       # f1*f1+f2*f2 <= epsFunc まで繰り返す。
  end
end

solver = NlSolve.new 
x     = []
delta = []
x.push  BigFloat.new("0.0")         # xの初期値
x.push  BigFloat.new("0.0")         # yの初期値
delta.push  BigFloat.new("0.1")     # 最初にxを動かす幅
delta.push  BigFloat.new("0.1")     # 最初にyを動かす幅
epsFunc = BigFloat.new("0.1e-30")   # 関数の収束判定定数
epsMove = BigFloat.new("0.1e-50")   # 動かす幅の最小値
f = solver.solve(x,delta,epsMove,epsFunc) 
printf("答え=X:%s \n    =Y:%s\n関数値=%s\n",x[0],x[1],f)
