#!/usr/local/bin/ruby
# -*- mode:ruby; encoding:euc-jp -*-

require "mailform.rb"

if __FILE__ == $0
  $SAFE = 1
  cgi = CGI.new
  message = format_comment(get_data(cgi))
  header_out("�᡼�������ƥ���")
  print <<EOF
<p>�إå�����
<pre style="background-color:#ccc;margin:0">
#{CGI.escapeHTML(message[0]).chomp}
</pre>
<p>���Ρ�
<pre style="background-color:#ccc;margin:0">
#{CGI.escapeHTML(message[1]).chomp}
</pre>
</body>
</html>
EOF
end
