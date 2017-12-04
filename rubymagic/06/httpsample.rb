#!/usr/bin/env ruby

#ƒŠƒXƒg6.1@httpsample.rb

require 'net/http'
Net::HTTP.version_1_2
require 'nkf'

Net::HTTP.start('www.namaraii.com', 80) do |http|          # (1)
  response , = http.get('/index.html')                     # (2)
  puts NKF.nkf('-s', response.body)                        # (3)
end
