
now = Time.now
s = if now.hour >= 6 && now.hour < 10
      "おはよう"
    elsif now.hour >=10 && now.hour < 18
      "こんにちは"
    else
      "こんばんは"
    end
puts s
