#!/usr/local/bin/ruby

print <<EOF
Content-Type: text/html

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">
<head><title>It is running!</title></head>
<body>
<p style="font-size:20pt">It is running!</p>
<p>#{Time.now}
<hr>
</body>
</html>
EOF
