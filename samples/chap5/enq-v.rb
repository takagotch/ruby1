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

def view_result_sub(id, question, options, resultdb)
  total = 0
  obtained = Array.new
  resultdb.each {|data|
    obtained[data[0].to_i] = (obtained[data[0].to_i] || 0) + 1
    total += 1
  }
  width = total > WIDTH_MAX ? WIDTH_MAX : total

  header_out('投票結果')
  print <<EOF
<table border="0" cellspacing="0" cellpadding="3">
  <tr><th colspan="2" class="q">質問：#{CGI.escapeHTML(question)}
EOF
  options.each_index {|i|
    print <<EOF
  <tr><td>#{CGI.escapeHTML(options[i])}
    <td><table border="0"><tr>
EOF
    if total > 0 && obtained[i + 1] && obtained[i + 1] > 0
      print <<EOF
<td width="#{width * obtained[i + 1] / total}" style="background-color:#f60;">
<td>#{obtained[i + 1]} / #{100 * obtained[i + 1] / total}%
EOF
    else
      print "<td>0 / -%\n"
    end
    print "</table>\n"
  }
  print <<EOF
  <tr><th>投票数<td>#{total}
  <tr><td colspan="2"><a href="./enq.rb?id=#{id}">[投票画面へ]</a>
</table>
EOF
  footer_out()
end

def view_result(cgi)
  id = cgi['id'].first
  question, options = get_question(id)
  resultdb = ResultDB.new(id)
  view_result_sub(id, question, options, resultdb)
end

# 連続投票かチェックする。
# @return 連続投票のときtrueを返す。
def check_multi()
  remote = ENV['REMOTE_HOST'] || ENV['REMOTE_ADDR']
  now = Time.now
  recent = Array.new
  ret = false
  File.open(CHECK_FILE, "r+") {|fp|
    fp.flock(File::LOCK_EX)
    while line = fp.gets
      t, host = line.chomp.split("\t", 2)
      if t.to_i + CHECK_TIME > now.to_i
        if host == remote
          ret = true
        else
          recent << [t.to_i, host]
        end
      end
    end
    recent << [now.to_i, remote]
    fp.rewind
    fp.truncate(0)
    recent.each {|x|
      fp.print x[0], "\t", x[1], "\n"
    }
  }
  return ret
end

def vote(cgi)
  id = cgi['id'].first
  ans = cgi['ans'].first
  comment = cgi['comment'].first

  question, options = get_question(id)
  if !ans || ans.to_i < 1 || ans.to_i > options.size
    print "Content-Type: text/html; charset=EUC-JP\n\n"
    print "<p>どれか一つ選んでください。"
    print "<a href=\"./enq.rb?id=#{id}\">[投票画面へ]</a>\n"
    exit
  end

  resultdb = ResultDB.new(id)
  resultdb.append([ans, comment]) if !check_multi()
  view_result_sub(id, question, options, resultdb)
end

if __FILE__ == $0
  cgi = CGI.new
  case cgi['action'].first
  when 'vote'
    vote(cgi)
  when 'view'
    view_result(cgi)
  else
    cgi.params['id'] = ['1']
    view_result(cgi)
  end
end
