#リスト6.4　fetchsample.rb

require 'fetchdoc'

# 通常のパターン
http = FetchDoc.new
puts   http.fetchdoc('http://www.namaraii.com/')

# BASIC認証
puts   http.fetchdoc('http://www.namaraii.com/auth/', 'hogehoge', 
                     'itteyoshi')

# プロキシ経由でのアクセス
http.proxy      = 'proxy.namaraii.com'
http.proxy_port = 8080
puts   http.fetchdoc('http://www.namaraii.com/')

# 認証が必要なプロキシ経由でのアクセス
http.proxy = 'authproxy.namaraii.com'
http.proxy_port = 8080 
http.proxy_account = 'hogehoge'
http.proxy_password = 'hagehage'
puts   http.fetchdoc('http://www.namaraii.com/')
