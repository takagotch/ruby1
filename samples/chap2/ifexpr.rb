
now = Time.now
s = if now.hour >= 6 && now.hour < 10
      "���Ϥ褦"
    elsif now.hour >=10 && now.hour < 18
      "����ˤ���"
    else
      "����Ф��"
    end
puts s
