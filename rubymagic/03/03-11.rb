#リスト3.11　日付へマッチする正規表現のテスト（その１）

def match(re, str)
  if m = re.match(str) 
    "#{$`}<<#{$&}>>#{$'}" 
  else 
    "no match -> #{re.source}, #{str}" 
  end 
end

re = %r!\d{4}/(0[1-9]|1[012])/(0[1-9]|[12]\d|3[01])!

puts match(re, '9999/99/99')
puts match(re, '2002/09/02')
puts match(re, '2002/12/32')
