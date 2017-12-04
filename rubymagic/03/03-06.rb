#リスト3.6　引用符で括られた文字列へのマッチ（その２）

re = /".*?"/

teststr = ['"Ruby"',
           'オブジェクト指向スクリプト言語 "Ruby"',
           '"Ruby"と"Perl"と"Python"']

while s = teststr.shift
  puts s
  puts s.scan(re)
  puts "------------------------------"
end
