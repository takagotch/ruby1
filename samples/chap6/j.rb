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

class JSkyView < BoardView
  # ���������
  def logon(is_retry = false)
    print <<EOF
Content-Type: text/html; charset=EUC-JP

<html>
<head><title>log on</title></head>
<body>
EOF
    print "�桼����ID�ޤ��ϥѥ���ɤ��㤤�ޤ���\n" if is_retry
    print <<EOF
<form method="post" action="./j.rb">
�桼����ID:<input type="text" size="4" mode="numeric" name="user"><br>
�ѥ����:<input type="password" size="4" mode="numeric" name="pwd"><br>
<input type="submit" value="������">
</form>

<hr>
</body>
</html>
EOF
  end

  # ��å�����ɽ��
  def mes_out(cgi, user, pos, store)
    if !pos
      nothing(cgi)
      exit
    end
    last = store.last

    print <<EOF
Content-Type: text/html; charset=EUC-JP

<html>
<head><title>#{pos}</title></head>
<body>
EOF
    print cgi.form("post", "./j.rb") {
      s = "<input type=\"hidden\" name=\"cur\" value=\"#{pos}\">\n"
      if pos < last
        s += '<input type="submit" name="next" value="��">' + "\n"
      else
        s += "[��] "
      end
      if pos > 1
        s += '<input type="submit" name="prev" value="��">' + "\n"
      else
        s += "[��] "
      end
      s += '<input type="submit" name="new" value="����">' + "\n"
      s
    }
    begin
      mes = store.get(pos.to_s)
    rescue Errno::ENOENT
      print "[#{pos}] ���\n"
    else
      t = ParseDate.get_time(mes['date']).localtime
      print "[#{pos}] #{mes['from']}<br>#{t.strftime('%m/%d %H:%M')}<br>\n"
      mes.body.each {|line|
        print CGI.escapeHTML(line.chomp), "<br>\n"
      }
    end
    print <<EOF
<hr>
</body>
</html>
EOF
  end

  # ������Ʋ���
  def new_mes_form(cgi)
    s = <<EOF
Content-Type: text/html; charset=Shift_JIS

<html>
<head><title>�������</title></head>
<body>
EOF
    s += cgi.form("post", "./j.rb") {
      '<textarea name="text" rows="5" cols="14"></textarea>' + "\n" +
      "<br>\n" + 
      '<input type="submit" name="post" value="���">' + "\n"
    }
    s += <<EOF
<hr>
</body>
</html>
EOF
    print e2s(s)
  end

  private
  # ��å�������1���ʤ��Ȥ�
  def nothing(cgi)
    print <<EOF
Content-Type: text/html; charset=EUC-JP

<html>
<body>
��ƤϤ���ޤ���
EOF
    print cgi.form("post", "./j.rb") { 
      '<input type="submit" name="new" value="����">' + "\n"
    }
    print <<EOF
<hr>
</body>
</html>
EOF
  end
end

if __FILE__ == $0
  main(JSkyView.new)
end
