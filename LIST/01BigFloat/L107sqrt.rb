#!/usr/local/bin/ruby -Ks

require "minimize"

$v = BigFloat.new(ARGV.shift)
class Sqrt
  include Minimizer
  def doFunc(x)  # 目的関数の計算
     (x[0]*x[0] - $v).abs   # x**2 - v => 0（xはvの平方根、x=sqrt(v)）
  end
end

solver = Sqrt.new
x     = []
delta = []
x.push  BigFloat.new("0.0")         # xの初期値
delta.push  BigFloat.new("0.1")     # 最初にyを動かす幅
epsFunc = BigFloat.new("0.1e-30")   # 関数の収束判定定数
epsMove = BigFloat.new("0.1e-50")   # 動かす幅の最小値
f = solver.solve(x,delta,epsMove,epsFunc)
printf("答え  =%s\n関数値=%s",x[0],f)
