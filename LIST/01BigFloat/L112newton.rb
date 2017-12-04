#
# newton.rb 
#
# 関数オブジェクト f = 0 を Newton 法で解く。
#
# 呼び出し形式：
#   n = nlsolve(f,x)
# 引数
#   f ... Jacobian 行列 を計算するための関数オブジェクト。
#       [fが最低限用意しなければいけないメソッド]
#         f.values(x) でxでの関数ベクターを計算。
#         f.zero      0.0 を返す。
#         f.one       1.0 を返す。
#         f.two       1.0 を返す。
#         f.ten      10.0 を返す。
#         f.eps      収束判定定数
#   x ... 初期値
#
require "ludcmp"
require "jacobian"

module Newton
  include LUSolve
  include Jacobian
  
  def norm(fv,zero=0.0)
    s = zero
    n = fv.size
    for i in 0...n do
      s += fv[i]*fv[i]
    end
    s
  end

  def nlsolve(f,x)
    nRetry = 0
    n = x.size

    f0 = f.values(x)
    zero = f.zero
    one  = f.one
    two  = f.two
    p5 = one/two
    d  = norm(f0,zero)
    minfact = f.ten*f.ten*f.ten
    minfact = one/minfact
    e = f.eps
    while d >= e do
      nRetry += 1
      # 収束していないので微係数を計算する。
      dfdx = jacobian(f,f0,x)
      # dfdx*dx = -f0 を解いて、変化幅 dx を計算する。
      dx = lusolve(dfdx,f0,ludecomp(dfdx,n,zero,one),zero)
      fact = two
      xs = x.dup
      begin
        fact *= p5
        if fact < minfact then
          raize "関数値の２乗和を小さくすることができません。"
        end
        for i in 0...n do
          x[i] = xs[i] - dx[i]*fact
        end
        f0 = f.values(x)
        dn = norm(f0,zero)
      end while(dn>=d)
      p x  # 収束状況を見るためのデバッグ出力
      d = dn
    end
    nRetry
  end
end
