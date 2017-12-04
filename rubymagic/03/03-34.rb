#リスト3.34　HTTP URLチェックのテスト

def urlcheck(url)
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
  http_URL      = 
      "http://#{host}(?::#{port})?(?:#{abs_path}(?:\\?#{query})?)?"

  http    = "^#{http_URL}$"
  re_http = Regexp.new(http)

  re_http.match(url)
end

testurl = ["http://www.foo.com/",                     # valid
           "http://www.fo foo.com/",                  # invalid
           "http://www.foo.com/index.html",           # valid
           "ftp://www.foo.com/",                      # invalid
           "http://www.A(),%%%.com/",                 # invalid
           "http://www.foo.com/bar/~null/index.html"  # valid
          ]

while u = testurl.shift
  if urlcheck(u)
    puts "#{u} is valid."
  else
    puts "#{u} is invalid."
  end
end
