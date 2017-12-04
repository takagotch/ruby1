
def f(arg)
  if arg > 0
    print "f: #{arg}\n"
  else
    raise ArgumentError
  end
end

def g(arg)
  if arg > 5 && arg < 10
    print "g: #{arg}\n"
  else
    raise ArgumentError
  end
end

def test(arg)
  f(arg)
  g(arg)
end

begin
  test(8)
  test(2)
rescue
  puts $!
  puts $@.first
end
