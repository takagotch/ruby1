
s = "foo bar12 baz hoge09 bar hoge"
while s =~ /(bar|hoge)[0-9]+/
  print "pre match : '#{$`}'\n"
  print "match     : '#{$&}'\n"
  s = $'
end
print "post match: '#{s}'\n"
