#!/usr/local/bin/ruby -Ke

## bts���C�u�����̃f�B���N�g�����w��B�����̊��ɂ��킹�Đݒ�d
$bts_lib = '/home/mas/labo/ruby/rw256'

$:.unshift($bts_lib) if $bts_lib
require 'bts-index'

## ����CGI��URL���w��
$cgi_url = 'http://localhost/cgi-bin/bts-index.cgi'

## ���_�C���N�g����y�[�W��URL���w��
$rwiki_url = 'http://localhost/cgi-bin/rw-cgi.rb?cmd=view;name=todo-index'

class MyIndexFormat < BTSIndexFormat
  def to_rd(entry)
    body = super(entry)
    body.concat("\n((<�X�V|URL:#{$cgi_url}>))\n")
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
