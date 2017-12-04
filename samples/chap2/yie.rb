
def foo
  yield 10, 20
end

foo() {|x, y| print "#{x}, #{y}\n"}
