# -*- encoding:euc-jp -*-

for i in 1..3 do
  print "forループ: i = #{i}\n"
  next
  print "ここは通らない\n"
end

j = 0
while j < 3
  j += 1
  print "whileループ: j = #{j}\n"
  break if j == 5
  redo
  print "ここは通らない\n"
end
