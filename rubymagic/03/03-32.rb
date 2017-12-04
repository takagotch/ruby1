#リスト3.30　HTTP URLの正規表現生成スクリプト（その２）

digit         = "[0-9]"
hex           = "[0-9a-fA-F]"
alpha         = "[A-Za-z]"
alphanum      = "[A-Za-z0-9]"
reserved      = "[;/?:@&=+$,]"
unreserved    = "[A-Za-z0-9\\-_.!~*'()]"
escaped       = "%#{hex}#{hex}"
pchar         = "(?:[A-Za-z0-9\\-_.!~*'():@&=+$,]|#{escaped})"
param         = "#{pchar}*"
segment       = "#{pchar}*(?:;#{param})*"
path_segments = "#{segment}(?:/#{segment})*"
abs_path      = "/#{path_segments}"
port          = "#{digit}*"
ipv4address   = "#{digit}+\\.#{digit}+\\.#{digit}+\\.#{digit}+"
uric          = "(?:[;/?:@&=+$,A-Za-z0-9\\-_.!~*'()]|#{escaped})"
query         = "#{uric}*"
domainlabel   = "#{alphanum}(?:[A-Za-z0-9\\-]*#{alphanum})?"
toplabel      = "#{alpha}(?:[A-Za-z0-9\\-]*#{alphanum})?"
hostname      = "(?:#{domainlabel}\\.)*#{toplabel}\\.?"
host          = "(?:#{hostname}|#{ipv4address})"
http_URL      = "http://#{host}(?::#{port})?(?:#{abs_path}(?:\\?#{query})?)?"

re_http = Regexp.new(http_URL)

puts http_URL
