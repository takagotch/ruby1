#
# jacobian.rb
#
# 関数オブジェクト f の x における Jacobian 行列 を計算する。
# fx は x における関数値ベクター。
#
# 呼び出し形式：
#   dfdx =  jacobian(f,fx,x)
# 引数
#   f ... Jacobian 行列 を計算する関数オブジェクト。
#         f.values(x) で関数ベクターを計算できれば良い。
#   fx... 変数値が x の時の関数値ベクター。
#   x ... Jacobian 行列を計算する時点の右辺ベクター。
#
module Jacobian
  def isEqual(a,b,zero=0.0,e=1.0e-8)
    aa = a.abs
    bb = b.abs
    if aa == zero &&  bb == zero then
          true
    else
          if ((a-b)/(aa+bb)).abs < e then
             true
          else
             false
          end
    end
  end

  def dfdxi(f,fx,x,i)
  #
  # 関数ベクター f を x[i] で微分する。
  #
    nRetry = 0
    n = x.size
    xSave = x[i]
    ok = 0
    ratio = f.ten*f.ten*f.ten
    dx = x[i].abs/ratio
    dx = fx[i].abs/ratio if isEqual(dx,f.zero,f.zero,f.eps)
    dx = f.one/f.ten     if isEqual(dx,f.zero,f.zero,f.eps)
    until ok>0 do
      s = f.zero
      deriv = []
      #
      # 数値微分するための x[i] の変化幅(dx)を計算する。
      # 
      if(nRetry>100) then
         raize "Jacobian が特異です。 x[" + i.to_s + "] に対して変化しません。"
      end
      dx = dx*f.two
      x[i] += dx
      fxNew = f.values(x)
      for j in 0...n do
        if !isEqual(fxNew[j],fx[j],f.zero,f.eps) then
           ok += 1
           deriv <<= (fxNew[j]-fx[j])/dx
        else
           deriv <<= f.zero
        end
      end
      x[i] = xSave
    end
    deriv
  end

  def jacobian(f,fx,x)
    n = x.size
    dfdx = Array::new(n*n)
    for i in 0...n do
      df = dfdxi(f,fx,x,i)
      for j in 0...n do
         dfdx[j*n+i] = df[j]
      end
    end
    dfdx
  end
end
