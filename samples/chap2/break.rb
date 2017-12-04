
while line = gets
  break if line.gsub(/[\r\n]/, '') == ""
end
