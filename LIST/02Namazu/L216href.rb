#! /usr/local/bin/ruby

while gets
  if ( /<a href="([^"]+)">/ =~ $_ ) then
    path = $1
    path.gsub! ("//([a-z])") { "#{$1}:" }
    path.gsub! ("/") { "\\" }
    sub! (/<a href="[^"]*">/) { "<a href=\"#{path}\">" }
  end
  print $_
end
