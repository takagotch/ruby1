#!/usr/local/bin/ruby

# Copyright (c) 2002 HORIKAWA Hisashi. All rights reserved.

# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, and/or sell copies of the Software, and to permit persons
# to whom the Software is furnished to do so, provided that the above
# copyright notice(s) and this permission notice appear in all copies of
# the Software and that both the above copyright notice(s) and this
# permission notice appear in supporting documentation.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT
# OF THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# HOLDERS INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL
# INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING
# FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
# NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION
# WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# Except as contained in this notice, the name of a copyright holder
# shall not be used in advertising or otherwise to promote the sale, use
# or other dealings in this Software without prior written authorization
# of the copyright holder.

require "board-common.rb"
$SAFE = 1

class PCView < BoardView
  # �����������
  def logon(is_retry = false)
    print <<EOF
Content-Type: text/html; charset=EUC-JP
Cache-Control: no-cache
Pragma: no-cache

EOF
    print html_header("Web�Ǽ��ĤؤΥ�������")
    print '<a href="./j.rb">[J-SKY��]</a>', "\n"
    print "<p>�桼����ID�ޤ��ϥѥ���ɤ��㤤�ޤ���\n" if is_retry
    print <<EOF
<form method="post" action="./board.rb">
<table border="0" class="panel">
  <tr><th align="right">�桼����ID:
    <td><input type="text" size="10" name="user">
  <tr><th align="right">�ѥ����:
    <td><input type="password" size="10" name="pwd">
  <tr><td><input type="submit" value="��������">
</table>
</form>

<hr>
</body>
</html>
EOF
  end

  # ��å�����ɽ��
  def mes_out(cgi, user, pos, store)
    last = store.last

    print cgi.header({"type" => "text/html", "charset" => "Shift_JIS",
                      "Cache-Control" => "no-cache",
                      "Pragma" => "no-cache"})
    print e2s(html_header("Web�Ǽ���"))
    html = <<EOF
<form action="./board.rb" method="post">
#{if pos then '<input type="hidden" name="cur" value="' + pos.to_s + '">' end}
<table border="0" class="panel" cellpadding="3">
  <tr><th>̾����<td>#{get_name(PWD_FILE, user)}
  <tr><th valign="top">��ʸ��
    <td><textarea name="text" rows="5" cols="60"></textarea>
  <tr><td colspan="2"><input type="submit" name="post" value="���">
EOF
    if pos && pos + PAGE_SIZE <= last
      html += "<a href=\"./board.rb?next=1&amp;cur=#{pos}&amp;m=#{PAGE_SIZE}\">" +
              "[����#{PAGE_SIZE}��]</a> "
    else
      html += "[����#{PAGE_SIZE}��] "
    end
    if pos && pos > 1
      html += "<a href=\"./board.rb?prev=1&amp;cur=#{pos}&amp;m=#{PAGE_SIZE}\">" +
              "[����#{PAGE_SIZE}��]</a> "
    else
      html += "[����#{PAGE_SIZE}��] "
    end
    html += <<EOF
  <input type="submit" name="bye" value="��������">
</table>
</form>
EOF

    if !pos
      html += "<p>��ƤϤ���ޤ���\n"
    else
      html += '<form action="./board.rb" method="post">' + "\n"
      (PAGE_SIZE - 1).downto(0) {|i|
        next if pos + i > last
        begin
          mes = store.get((pos + i).to_s)
        rescue Errno::ENOENT
          html += "<h3> [#{pos + i}] ���</h3>\n"
          next
        end
        t = ParseDate.get_time(mes['date']).localtime
        html += "<h3>" +
                "[#{pos + i}] #{mes['from']} #{t.strftime('%m/%d %H:%M')} " +
                "<input type=\"checkbox\" name=\"delitem\" value=\"#{pos + i}\">" +
                "</h3>\n"
        mes.body.each {|line|
          html += CGI.escapeHTML(line.chomp) + "<br>\n"
        }
      }
      html += '<p align="right">' +
              '<input type="password" name="delpwd" size="6"> ' + 
              '<input type="submit" name="delete" value="�����Ժ��">' + "\n" +
              "</form>\n"
    end
    print e2s(html)
    print <<EOF
<hr>
</body>
</html>
EOF
  end

  # ��������
  def bye(cgi, session)
    session.delete
    print cgi.header({"type" => "text/html", "charset" => "EUC-JP",
                      "Cache-Control" => "no-cache",
                      "Pragma" => "no-cache"})
    print html_header("��������")
    print <<EOF
<p>�������դ��ޤ������Ƥӥ����ӥ������Ѥ���Ȥ��ϡ��������󤷤ʤ����Ƥ���������
<p><a href="./board.rb">[Web�Ǽ��ĤؤΥ�������]</a>
<hr>
</body>
</html>
EOF
  end

  private
  def html_header(title)
    s = <<EOF
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">
<head>
  <title>#{title}</title>
<style type="text/css">
body, table, textarea { font-size:10pt; }
body { background-color:#fc9; }
h1 { font-family:sans-serif; color:#363;
  border:solid #f00; border-width: 0 0 3px 0; }
.panel { background-color:#c96; margin-top:1em; }
h3 { color:#930; font-size:10pt; margin-bottom:0; }
</style>
</head>
<body>
<h1>#{title}</h1>
EOF
    return s
  end
end

if __FILE__ == $0
  main(PCView.new)
end