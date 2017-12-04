#!/usr/local/bin/ruby
# -*- mode:ruby; encoding:euc-jp -*-

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

require "cgi"
require "enq-common.rb"

$SAFE = 1

def enquete_form()
  id = "1"
  question, option = get_question(id)
  if !question || option.empty?
    print "Content-Type: text/html\n\n"
    print "<p>question-file error.\n"
    exit
  end
  resultdb = ResultDB.new(id)
  total = resultdb.size

  header_out('Web投票')
  print <<EOF
<form method="post" action="./enq-v.rb">
  <input type="hidden" name="action" value="vote">
  <input type="hidden" name="id" value="#{id}">
<table border="0" cellspacing="0" cellpadding="5">
  <tr><th class="q">質問：#{CGI.escapeHTML(question)}
  <tr><td>
EOF
  option.each_index {|i|
    print "<input type=\"radio\" name=\"ans\" value=\"#{i + 1}\">",
          CGI.escapeHTML(option[i]), "<br>\n"
  }
  print <<EOF
  <tr><td>
    一言：<input type="text" size="50" name="comment">
  <tr><td>
    <input type="submit" value="投票">
    <a href="./enq-v.rb?action=view&amp;id=#{id}">[結果を見る]</a>
    これまでの投票数: #{total}
</table>
</form>
EOF
  footer_out()
end

def error_out()
  print "Content-Type:text/html\n\n"
  print "<p>#{CGI.escapeHTML($!.inspect)}<br>\n"
  $@.each {|x| print CGI.escapeHTML(x), "<br>\n"}
end

# main
if __FILE__ == $0
  begin
    enquete_form()
  rescue StandardError
    error_out()
  rescue ScriptError
    error_out()
  end
end
