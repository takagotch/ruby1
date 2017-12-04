#
# ludcmp.rb
#
module LUSolve
  def ludecomp(a,n,zero=0.0,one=1.0)
  #
  # 任意の行列 'a' を下三角(L)と上三角(U)行列に分解する。
  # 更にLの対角要素は全て 1 であるので、これを無視することで
  # L と U を同じ行列 'a' にパックしてリターンする。
  # 戻り値はピボット変換用のベクター(lusolveで使用する)。
  # 注意：　行列 a の要素 a[i,j] は a[i*n+j] 
  #
    ps     = []
    scales = []
    for i in 0...n do  # pick up largest(abs. val.) element in each row.
      ps <<= i
      nrmrow  = zero
      ixn = i*n
      for j in 0...n do
         biggst = a[ixn+j].abs
         nrmrow = biggst if biggst>nrmrow
      end
      if nrmrow>zero then
         scales <<= one/nrmrow
      else 
         raise "Singular matrix"
      end
    end
    n1          = n - 1
    for k in 0...n1 do # Gaussian elimination with partial pivoting.
      biggst  = zero;
      for i in k...n do
         size = a[ps[i]*n+k].abs*scales[ps[i]]
         if size>biggst then
            biggst = size
            pividx  = i
         end
      end
      raise "Singular matrix" if biggst<=zero
      if pividx!=k then
        j = ps[k]
        ps[k] = ps[pividx]
        ps[pividx] = j
      end
      pivot   = a[ps[k]*n+k]
      for i in (k+1)...n do
        psin = ps[i]*n
        a[psin+k] = mult = a[psin+k]/pivot
        if mult!=zero then
           pskn = ps[k]*n
           for j in (k+1)...n do
             a[psin+j] -= mult*a[pskn+j]
           end
        end
      end
    end
    raise "Singular matrix" if a[ps[n1]*n+n1] == zero
    ps
  end

  def lusolve(a,b,ps,zero=0.0)
  #  LU分解された行列 a を用いて ax=b を解く。
    n = ps.size
    x = []
    for i in 0...n do
      dot = zero
      psin = ps[i]*n
      for j in 0...i do
        dot = a[psin+j]*x[j] + dot
      end
      x <<= b[ps[i]] - dot
    end
    (n-1).downto(0) do |i|
       dot = zero
       psin = ps[i]*n
       for j in (i+1)...n do
         dot = a[psin+j]*x[j] + dot
       end
       x[i]  = (x[i]-dot)/a[psin+i]
    end
    x
  end
end
