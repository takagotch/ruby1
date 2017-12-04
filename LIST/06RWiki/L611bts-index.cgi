#!/usr/local/bin/ruby -Ke

## btsライブラリのディレクトリを指定。自分の環境にあわせて設定‥
$bts_lib = '/home/mas/labo/ruby/rw256'

$:.unshift($bts_lib) if $bts_lib
require 'bts-index'

## このCGIのURLを指定
$cgi_url = 'http://localhost/cgi-bin/bts-index.cgi'

## リダイレクトするページのURLを指定
$rwiki_url = 'http://localhost/cgi-bin/rw-cgi.rb?cmd=view;name=todo-index'

class MyIndexFormat < BTSIndexFormat
  def to_rd(entry)
    body = super(entry)
    body.concat("\n((<更新|URL:#{$cgi_url}>))\n")
  end
end

if __FILE__ == $0
  DRb.start_service
  $rwiki = DRbObject.new(nil, 'druby://localhost:8470')

  idx = BTSIndex.new
  format = MyIndexFormat.new

  entry = idx.prepare_index
  idx.page.src = format.to_rd(entry)

  puts "Location: #{$rwiki_url}"
  puts
end
