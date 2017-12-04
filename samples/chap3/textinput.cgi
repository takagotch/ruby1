#!/usr/local/bin/ruby

require "cgi"
$SAFE = 1

cgi = CGI.new
body = CGI.escapeHTML(cgi['body'].first.strip).split(/\r?\n/)

print <<EOF
Content-Type: text/html; charset=EUC-JP

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">
<head>
  <title>�������</title>
  <style type="text/css">th { text-align:right; }</style>
</head>
<body>

<table border="1">
  <tr><th>��̾��<td>#{CGI.escapeHTML(cgi["user"].first)}
  <tr><th>ɽ��<td>#{CGI.escapeHTML(cgi["subject"].first)}
  <tr><th>��ʸ<td>#{body.join("<br>\n")}
  <tr><th>URL<td>#{CGI.escapeHTML(cgi['url'].first)}
  <tr><th>ʸ����<td>#{cgi['col'].first}
  <tr><th>�������<td>#{CGI.escapeHTML(cgi['delkey'].first)}
</table>

<hr>
</body>
</html>
EOF
