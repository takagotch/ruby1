
now = Time.now
if now.hour >= 6 && now.hour < 10
  puts "おはよう"
elsif now.hour >=10 && now.hour < 18
  puts "こんにちは"
else
  puts "こんばんは"
end
