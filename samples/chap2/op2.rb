
class Foo
  def initialize(v)
    @val = v
  end
  def +(x)
    @val *= x
    return self
  end
  def [](x)
    @val += x
    return self
  end
  def get()
    return @val
  end
end

obj = Foo.new(2)
result = (obj + 5)[2]
puts result.get
