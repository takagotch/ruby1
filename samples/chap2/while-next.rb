# -*- encoding:euc-jp -*-

for i in 1..3 do
  print "for�롼��: i = #{i}\n"
  next
  print "�������̤�ʤ�\n"
end

j = 0
while j < 3
  j += 1
  print "while�롼��: j = #{j}\n"
  break if j == 5
  redo
  print "�������̤�ʤ�\n"
end
