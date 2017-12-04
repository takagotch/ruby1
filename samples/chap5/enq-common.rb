
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

require "enq-conf.rb"

# 質問ファイルから質問と選択肢を取り出す
def get_question(fname)
  raise ArgumentError if fname =~ /[^0-9]/
  fname.untaint

  question = nil
  option = Array.new
  File.open(QUESTION_DIR + "/" + fname) {|fp|
    while line = fp.gets
      k, v = line.strip.split(/[ \t]*=[ \t]*/, 2)
      if k && v
        question = v if k == 'question'
        option << v if k == 'option'
      end
    end
  }
  return [question, option]
end

# 結果ファイルを操作する
class ResultDB
  def initialize(fname)
    raise ArgumentError if fname =~ /[^0-9]/ ||
                           !FileTest.exist?(QUESTION_DIR + "/" + fname)
    fname.untaint
    @path = RESULT_DIR + "/" + fname
    File.open(@path, "a") {} if !FileTest.exist?(@path)
  end

  def size()
    lines = 0
    File.open(@path) {|fp|
      fp.flock(File::LOCK_SH)
      lines += 1 while fp.gets
    }
    return lines
  end

  def each()
    File.open(@path) {|fp|
      fp.flock(File::LOCK_SH)
      while line = fp.gets
        yield line.chomp.split("\t")
      end
    }
  end

  def append(data)
    File.open(@path, "a") {|fp|
      fp.flock(File::LOCK_EX)
      val = Array.new
      data.each {|x|
        val << x.to_s.gsub(/[\r\n\t]+/, ' ').strip
      }
      fp.print val.join("\t"), "\n"
    }
  end

  def ResultDB.delete(fname)
    File.delete(RESULT_DIR + "/" + fname)
  end
end

def header_out(title)
  print <<EOF
Content-Type: text/html; charset=EUC-JP

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">
<head>
  <title>#{title}</title>
<style type="text/css">
  body, table { font-size:10pt; }
  body { background-color:#69c; margin:0 0 0 10px;}
  h1 { color:#fff; margin:4px; font-family:sans-serif;}
  .bg { background-color:#fc9; }
  .q { border:solid #c69; border-width:0 0 2px 0; }
</style>
</head>
<body>
<h1>#{title}</h1>
<table width="100%" border="0" cellspacing="0" cellpadding="10">
  <tr><td width="100%" class="bg">
EOF
end

def footer_out()
  print <<EOF
</table>
<hr>
</body>
</html>
EOF
end
