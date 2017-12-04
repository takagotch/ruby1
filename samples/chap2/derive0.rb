
class Cow
  def speak; puts "moooo!" end
end

class Horse
  def speak; puts "neigh!" end
end

def call(obj)
  obj.speak
end

cow = Cow.new
horse = Horse.new
call(cow)
call(horse)
