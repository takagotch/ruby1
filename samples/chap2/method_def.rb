# -*- encoding:euc-jp -*-

class Person
  def initialize(name, addr, tel)
    @name = name
    @addr = addr
    @tel = tel
  end
  
  def get_name
    return @name
  end
end

suzuki = Person.new("������Ϻ", "�����̶�", "06-5555-5555")
satou = Person.new("��ƣ�ֻ�", "���ܻ�", "0798-55-5555")
puts suzuki.get_name
puts satou.get_name
