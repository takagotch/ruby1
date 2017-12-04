#
# minimize.rb
#
require "BigFloat"
module Minimizer
  def doFunc(x) # 仮の定義（目的関数）
    raise "これでは計算できません。doFunc(x) は必ず自分で定義してね。"
  end

  # 実際の解法部分
  def solve(x,deltax,epsMove,epsFunc=nil)  # doFunc(x)<=epsFunc を解く。
    # 戻り値はdoFunc(x)の最小値、または極小値。
    # 引数の説明
    #   x       ... 答えの配列、入力時は初期値。
    #   deltax  ... 移動幅の配列
    #   epsMove ... x[i]の最小移動幅。極小点の判定に用いる。
    #   epsFunc ... doFunc(x)の希望最小値。nilなら極小点まで繰り返す。
    fvNow   = doFunc(x)
    goodTry = BigFloat.new("1.5")    # うまくいったとき、次は更に伸ばす割合。
    badTry  = BigFloat.new("-0.5")   # 失敗したとき、逆方向に行く割合。
    nx      = x.size
    while (epsFunc==nil)||(fvNow>epsFunc) # 関数値>epsFuncは繰り返す。
      nCount = 0
      deltax.each_with_index {|dx,i|
        xSave = x[i].dup
        begin
          if dx.abs >= epsMove     # 動かせる？
            x[i]      = xSave + dx # x[i] をチョット動かす。
            fvTry = doFunc(x)      # x[i] を dx だけ動かして計算する。
            dx   *=  badTry        # もしダメなら、次は逆方向を調べることにする。
          else
            nCount += 1            # 動かせないから、カウントする。
            if nCount >= nx        # 全て動かしけど小さくならない=>極小値
               return fvNow if epsFunc==nil # 極小値を求めたい場合
               raise "多分「極小値」にハマったので、動けません。"
            end
            i = -1                 # 「動かしてもダメだった」という印。
            break                  # x[i]はダメ、次（x[i+1]）に行こう！
          end
        end while fvTry>=fvNow      # 小さくなるまで繰り返し。
        if i>=0                     # しめた！　小さくなった。
           fvNow = fvTry            # 次はfvNow以下を目指す。
           deltax[i] *= goodTry     # 調子に乗ってもっと進んじゃえ！
        end
      }
    end
    fvNow
  end
end
