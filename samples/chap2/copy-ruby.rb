
begin
  fin = File.open(ARGV.shift, "r")
  fout = File.open(ARGV.shift, "w")
  fout.write(fin.read)
rescue Errno::ENOENT
  puts $!
ensure
  fin.close if fin
  fout.close if fout
end
