#!/usr/bin/env ruby

#���X�g6.2�@httpproxy.rb

require 'net/http'
Net::HTTP.version_1_2
require 'nkf'

Proxy      = 'proxy.namaraii.com'                        # (1)
Proxy_port = 8080                                        # (2)

Net::HTTP::Proxy(Proxy, Proxy_port).start('www.namaraii.com', 80) do |http| # (3)
  response , = http.get('/index.html')
  puts NKF.nkf('-s', response.body)
end
