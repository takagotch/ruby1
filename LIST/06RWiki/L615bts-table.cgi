#!/usr/local/bin/ruby -Ke

require 'cgi'

## btsライブラリのディレクトリを指定。自分の環境にあわせて設定‥
$bts_lib = '/home/mas/labo/ruby/rw256'

$:.unshift($bts_lib) if $bts_lib
require 'bts-table'

## RWikiのURLを指定
$rwiki_url = 'http://localhost/cgi-bin/rw-cgi.rb'

DRb.start_service
$rwiki = DRbObject.new(nil, 'druby://localhost:8470')

index = BTSIndex.new
format = BTSTableFormat.new(BTSCellFormat, $rwiki_url)
ary = index.find_all_items

## HTMLページを生成し、ヘッダとともに出力する
cgi = CGI.new('html4')
cgi.out({'charset' => 'euc-jp' }) {
  cgi.html {
    cgi.body { 
      format.to_html(ary)
    }
  }
}

