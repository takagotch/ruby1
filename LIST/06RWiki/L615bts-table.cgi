#!/usr/local/bin/ruby -Ke

require 'cgi'

## bts���C�u�����̃f�B���N�g�����w��B�����̊��ɂ��킹�Đݒ�d
$bts_lib = '/home/mas/labo/ruby/rw256'

$:.unshift($bts_lib) if $bts_lib
require 'bts-table'

## RWiki��URL���w��
$rwiki_url = 'http://localhost/cgi-bin/rw-cgi.rb'

DRb.start_service
$rwiki = DRbObject.new(nil, 'druby://localhost:8470')

index = BTSIndex.new
format = BTSTableFormat.new(BTSCellFormat, $rwiki_url)
ary = index.find_all_items

## HTML�y�[�W�𐶐����A�w�b�_�ƂƂ��ɏo�͂���
cgi = CGI.new('html4')
cgi.out({'charset' => 'euc-jp' }) {
  cgi.html {
    cgi.body { 
      format.to_html(ary)
    }
  }
}

