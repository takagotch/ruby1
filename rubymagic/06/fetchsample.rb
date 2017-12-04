#���X�g6.4�@fetchsample.rb

require 'fetchdoc'

# �ʏ�̃p�^�[��
http = FetchDoc.new
puts   http.fetchdoc('http://www.namaraii.com/')

# BASIC�F��
puts   http.fetchdoc('http://www.namaraii.com/auth/', 'hogehoge', 
                     'itteyoshi')

# �v���L�V�o�R�ł̃A�N�Z�X
http.proxy      = 'proxy.namaraii.com'
http.proxy_port = 8080
puts   http.fetchdoc('http://www.namaraii.com/')

# �F�؂��K�v�ȃv���L�V�o�R�ł̃A�N�Z�X
http.proxy = 'authproxy.namaraii.com'
http.proxy_port = 8080 
http.proxy_account = 'hogehoge'
http.proxy_password = 'hagehage'
puts   http.fetchdoc('http://www.namaraii.com/')
