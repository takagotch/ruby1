#!/usr/local/bin/ruby

require "board.rb"

# �ƥ��ȥǡ������Ѱդ���
store = MessageStore.new(DATA_DIR)
postdata = Mail.new
postdata.header = {"from" => "hori", "date" => CGI.rfc1123_date(Time.now)}
postdata.body = ["�ƥ��ȥǡ���", "testdata"]
store.write(nil, postdata)
store.write(nil, postdata)
store.write(nil, postdata)

cgi = CGI.new
view = PCView.new
view.mes_out(cgi, "hori", 1, store)
