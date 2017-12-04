
CNTFILE = "testfile"

def locktest(p)
  cnt = 0
  for i in 1..500 do
    File.open(CNTFILE, "r+") {|fp|
      cnt = fp.gets.to_i + 1
      fp.rewind
      fp.print cnt, "\n"
    }
    print "#{p}: #{cnt}\n" if i % 100 == 0
  end
end

File.open(CNTFILE, "w") {}
if pid = Process.fork
  locktest('A')
  Process.waitpid(pid)
  File.open(CNTFILE, "r") {|fp| print "cnt = #{fp.gets}"}
else
  locktest('B')
end
