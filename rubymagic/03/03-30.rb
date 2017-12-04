#リスト3.30　HTTP URLの正規表現生成スクリプト（その１）

digit         = "[0-9]"
lowalpha      = "[a-z]"
upalpha       = "[A-Z]"
mark          = "[-_.!~*'()]"
hex           = "(?:#{digit}|[a-fA-F])"
alpha         = "(?:#{lowalpha}|#{upalpha})"
alphanum      = "(?:#{alpha}|#{digit})"
reserved      = "[;/?:@&=+$,]"
unreserved    = "(?:#{alphanum}|#{mark})"
escaped       = "%#{hex}#{hex}"
pchar         = "(?:#{unreserved}|#{escaped}|[:@&=+$,])"
param         = "#{pchar}*"
segment       = "#{pchar}*(?:;#{param})*"
path_segments = "#{segment}(?:/#{segment})*"
abs_path      = "/#{path_segments}"
port          = "#{digit}*"
ipv4address   = "#{digit}+\\.#{digit}+\\.#{digit}+\\.#{digit}+"
uric          = "(?:#{reserved}|#{unreserved}|#{escaped})"
query         = "#{uric}*"
domainlabel   = "(?:#{alphanum}(?:(?:#{alphanum}|-)*#{alphanum})?)"
toplabel      = "(?:#{alpha}(?:(?:#{alphanum}|-)*#{alphanum})?)"
hostname      = "(?:#{domainlabel}\\.)*#{toplabel}\\.?"
host          = "(?:#{hostname}|#{ipv4address})"
http_URL      = "http://(#{host})(:#{port})?(#{abs_path}(?:\\?#{query})?)?"

re_http = Regexp.new(http_URL)

puts http_URL
