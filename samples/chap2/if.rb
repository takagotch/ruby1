
now = Time.now
if now.hour >= 6 && now.hour < 10
  puts "���Ϥ褦"
elsif now.hour >=10 && now.hour < 18
  puts "����ˤ���"
else
  puts "����Ф��"
end
