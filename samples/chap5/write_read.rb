
def w
  f = File.open("test", "w")
  f.print "This is test.\n"
  f.close
end

def r
  File.open("test", "r") {|fp|
    print fp.gets
  }
end

w()
r()
