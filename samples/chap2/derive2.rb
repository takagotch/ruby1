
# -*- encoding:euc-jp -*-

class Person
  def initialize(name) @name = name end
  def get_name() @name end
end

class Apple < Person
  def initialize(name) super(name) end
end

obj = Apple.new("�ե�")
puts obj.get_name        #=> �ե�
