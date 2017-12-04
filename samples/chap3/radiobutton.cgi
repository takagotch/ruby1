#!/usr/local/bin/ruby

require "cgi"
$SAFE = 1

cgi = CGI.new

print <<EOF
Content-Type: text/html; charset=EUC-JP

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">
<head>
  <title>アンケート結果</title>
<style type="text/css"><!--
  th { text-align:right; }
-->
</style>
</head>
<body>

<table border="1">
  <tr><th>年齢：<td>#{cgi["age"].first || "選択されず"}
  <tr><th>性別：<td>#{cgi["sex"].first || "選択されず"}
  <tr><th>モバイル機器：
    <td>#{cgi["portable"].first || "選択されず"}
  <tr><th>その他：<td>#{CGI.escapeHTML(cgi["other"].first)}
EOF
