
def positive_test(x)
  raise ArgumentError, "must positive" if x <= 0
  puts x
end

begin
  positive_test(10)
  positive_test(-1)
rescue
  puts $!
end
