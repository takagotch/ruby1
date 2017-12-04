#リスト3.22　IPアドレスへマッチする正規表現のテスト

def match(re, str)
  if m = re.match(str) 
    "#{$`}<<#{$&}>>#{$'}" 
  else 
    "no match -> #{re.source}, #{str}" 
  end 
end

re = /^(\d|\d\d|[01]\d\d|2[0-4]\d|25[0-5])\.(\d|\d\d|[01]\d\d|2[0-4]\d|25[0-5])\.(\d|\d\d|[01]\d\d|2[0-4]\d|25[0-5])\.(\d|\d\d|[01]\d\d|2[0-4]\d|25[0-5])$/

puts match(re, '1.1.1.1')
puts match(re, '10.20.30.40')
puts match(re, '001.010.100.255')
puts match(re, '255.255.255.255')
puts match(re, '1.2.3.256')
puts match(re, '256.1.2.3')
puts match(re, '1.1.300.3')
