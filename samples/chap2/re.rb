
s = "ʸ�Ϥ��椫�������ֹ�餷�����0798-55-5555��06-5555-5555����Ф�"
while s =~ /([0-9]+-)+[0-9]+/
  puts $&
  s = $'
end