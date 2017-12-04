
class Animal
  def initialize(cry) @cry = cry end
  def speak; puts @cry end
end

class Cow < Animal
  def initialize; super("moooo!") end
end

class Horse < Animal
  def initialize; super("neigh!") end
end

class Sheep < Animal
  def initialize; super("baaaah!") end
end

cow = Cow.new
horse = Horse.new
sheep = Sheep.new
cow.speak
horse.speak
sheep.speak
