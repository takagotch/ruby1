
##
# 負でない整数について階乗を求める。
def factorial(x)
  raise ArgumentError if x < 0
  if x == 0
    1
  else
    x * factorial(x - 1)
  end
end

puts factorial(100)
