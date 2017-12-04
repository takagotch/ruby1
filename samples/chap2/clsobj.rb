# クラスも普通オブジェクトでしょ

class Foo
  def get
    10
  end
end

class Bar
  def get
    20
  end
end

cls = {"boo" => Foo, "ba" => Bar}
puts cls["boo"].new.get
