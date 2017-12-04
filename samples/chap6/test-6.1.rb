
require "board-common.rb"
$SAFE = 1

DIRNAME = "/tmp/storetest"

class StoreTest
  def initialize()
    @store = MessageStore.new(DIRNAME)
  end

  def test1
    mes = Mail.new
    mes.header = {"foo" => "bar", "from" => "me"}
    mes.body = ["line1", "line2"]
    @store.write(nil, mes)
  end

  def test2
    print "last = #{@store.last}\n"
  end

  def test3
    mes = @store.get("1")
    p mes.header
    p mes.body
  end
end

def clean
  File.unlink DIRNAME + "/1" if FileTest.exist?(DIRNAME + "/1")
  File.unlink DIRNAME + "/counter" if FileTest.exist?(DIRNAME + "/counter")
  Dir.rmdir DIRNAME if FileTest.exist?(DIRNAME)
end

clean
Dir.mkdir DIRNAME
test = StoreTest.new
test.test1
test.test2
test.test3
clean
