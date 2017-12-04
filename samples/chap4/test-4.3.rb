#!/usr/local/bin/ruby
# -*- mode:ruby; encoding:euc-jp -*-

require "mailform.rb"

if __FILE__ == $0
  $SAFE = 1
  cgi = CGI.new
  message = format_comment(get_data(cgi))
  header_out("メール整形テスト")
  print <<EOF
<p>ヘッダー：
<pre style="background-color:#ccc;margin:0">
#{CGI.escapeHTML(message[0]).chomp}
</pre>
<p>本体：
<pre style="background-color:#ccc;margin:0">
#{CGI.escapeHTML(message[1]).chomp}
</pre>
</body>
</html>
EOF
end
