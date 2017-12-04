
k = 0
while k < 10
  a = 20
  k += 1
end
p a                 #=> 20

for i in 1..10 do
  x = 100
end
p i                 #=> 10
p x                 #=> 100

begin
  s = "str"
  raise "exception!"
rescue
  t = "foo"
end
p s                 #=> "str"
p t                 #=> "foo"
