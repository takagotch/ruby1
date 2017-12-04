#!/usr/bin/env ruby

require "soap/driver"

log = Devel::Logger.new("echo_client.log", "daily")
log_id = "Echo client using SOAP::Driver#invoke"

driver = SOAP::Driver.new(log, log_id,
                          "http://echo2.org/",
                          "http://localhost:8080/")

header_items = []
  
# 親要素を生成
parent = SOAP::SOAPElement.new("http://foo/", "parent")
parent.text = "has_children"

# 子要素を追加
parent.add(SOAP::SOAPElement.new(nil, "child", "child1"))
parent.add(SOAP::SOAPElement.new(nil, "child", "child2"))

# mustUnderstand属性の値は1
header_items << [parent, true, nil]

# 二つめのヘッダ項目
session = SOAP::SOAPElement.new("http://bar/", "session", "15")

# mustUnderstand属性の値は0
header_items << [session, false, nil]

body_item = SOAP::SOAPStruct.new
body_item.name = "nikai"
body_item.namespace = "http://echo2.org/"
body_item.add("string",
              SOAP::SOAPString.new("abc"))

data = driver.invoke(header_items, body_item)

response_header, response_body = SOAP::Processor.unmarshal(data.receiveString)

if response_body.fault.nil?
  p SOAP::RPCUtils.soap2obj(response_body.response)
else
  fault = SOAP::RPCUtils.soap2obj(response_body.fault.detail)
  p fault.message
end
