#!/usr/bin/env ruby

require "soap/driver"

log = Devel::Logger.new("echo_client.log", "daily")
log_id = "Echo client using SOAP::Driver#invoke"

driver = SOAP::Driver.new(log, log_id,
                          "http://echo2.org/",
                          "http://localhost:8080/")

header_items = []
  
# �e�v�f�𐶐�
parent = SOAP::SOAPElement.new("http://foo/", "parent")
parent.text = "has_children"

# �q�v�f��ǉ�
parent.add(SOAP::SOAPElement.new(nil, "child", "child1"))
parent.add(SOAP::SOAPElement.new(nil, "child", "child2"))

# mustUnderstand�����̒l��1
header_items << [parent, true, nil]

# ��߂̃w�b�_����
session = SOAP::SOAPElement.new("http://bar/", "session", "15")

# mustUnderstand�����̒l��0
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
