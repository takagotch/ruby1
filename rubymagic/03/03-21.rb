#リスト3.21　0～255の数値にマッチする正規表現のテスト

def match(re, str)
  if m = re.match(str) 
    "#{$`}<<#{$&}>>#{$'}" 
  else 
    "no match -> #{re.source}, #{str}" 
  end 
end

re = /^(\d|\d\d|[01]\d\d|2[0-4]\d|25[0-5])$/

puts match(re, '000')
puts match(re, '0')
puts match(re, '10')
puts match(re, '010')
puts match(re, '100')
puts match(re, '200')
puts match(re, '255')
puts match(re, '256')
puts match(re, '999')
