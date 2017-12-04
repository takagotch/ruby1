
s = "1234567890 abc 123"
if s =~ /[a-z]/
  puts "'#{$`}'"
  puts "'#{$&}'"
  puts "'#{$'}'"
end
