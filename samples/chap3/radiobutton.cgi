#!/usr/local/bin/ruby

require "cgi"
$SAFE = 1

cgi = CGI.new

print <<EOF
Content-Type: text/html; charset=EUC-JP

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">
<head>
  <title>���󥱡��ȷ��</title>
<style type="text/css"><!--
  th { text-align:right; }
-->
</style>
</head>
<body>

<table border="1">
  <tr><th>ǯ��<td>#{cgi["age"].first || "���򤵤줺"}
  <tr><th>���̡�<td>#{cgi["sex"].first || "���򤵤줺"}
  <tr><th>��Х��뵡�
    <td>#{cgi["portable"].first || "���򤵤줺"}
  <tr><th>����¾��<td>#{CGI.escapeHTML(cgi["other"].first)}
EOF
