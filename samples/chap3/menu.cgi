#!/usr/local/bin/ruby

require "cgi"
$SAFE = 1

cgi = CGI.new
print <<EOF
Content-Type: text/html; charset=EUC-JP

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">
<head>
  <title>��˥塼</title>
</head>
<body>
<p>multichoice = #{
  cgi["multi"].empty? ? "����ʤ�" : cgi['multi'].join(", ")}
<p>where = #{cgi['where'].first}
<hr>
</body>
</html>
EOF
