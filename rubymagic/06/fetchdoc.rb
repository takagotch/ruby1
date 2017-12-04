#!/usr/bin/env ruby

#ƒŠƒXƒg6.3@fetchdoc.rb

require 'net/http'
Net::HTTP.version_1_2
require 'uri'

class FetchDoc
  attr_accessor :proxy
  attr_accessor :proxy_port
  attr_accessor :proxy_account
  attr_accessor :proxy_password
  
  USERAGENT = 'fetchdoc.rb/0.1'

  def initialize(ua = USERAGENT)
    @user_agent     = ua
    @proxy          = nil
    @proxy_port     = nil
    @proxy_account  = nil
    @proxy_password = nil
  end

  def fetchdoc(uri, account=nil, password=nil)
    doc   = URI.parse(uri)
    response = nil
    h = Hash.new
    h['User-Agent'] = @user_agent

    p = []
    doc.request_uri.split('/').each do |e|
      if e == '..'
        p.pop
      elsif
        p.push(e)
      end
    end
    path = p.size > 0 ? p.join('/') : '/'
    path << '/' if doc.request_uri[-1].chr == '/'
    
    begin
      Net::HTTP::Proxy(@proxy, @proxy_port).start(doc.host) do |http|
        if @proxy_account
          proxyauth = "Basic " + 
              ["#{@proxy_account}:#{@proxy_password}"].pack('m').strip
          h['Proxy-Authorization'] = proxyauth
        end
        if account
          auth = "Basic " + ["#{account}:#{password}"].pack('m').strip
          h['Authorization'] = auth if account 
        end
        param = Array.new(1, h)
        response , = http.get(path, *param)
      end
      return response.body
    rescue
      return nil
    end
  end
end
