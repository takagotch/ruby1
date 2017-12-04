
# Copyright (c) 2002 HORIKAWA Hisashi. All rights reserved.
# You can redistribute this software and/or modify it under Ruby's License.

require "cgi/session"
require "parsedate"
require "mailread"

module ParseDate
  def ParseDate.get_time(datestr, cyear = nil)
    ary = parsedate(datestr, cyear)
    if !ary[6] || ary[6] == 'GMT'
      return Time.gm *ary[0..-3]
    else
      return nil
    end
  end
end

class Mail
  alias :orig_initialize :initialize

  def initialize(io = nil)
    if io
      orig_initialize(io)
    else
      @header = {}
      @body = []
    end
  end

  def header=(hash)
    @header = hash
  end

  def body=(ary)
    @body = ary
  end
end

class CGI
  class Session
    class FileStore
      # ���å������¸�ե�����Τ������Ť��Τ�������
      # @param option ���ץ������Ǽ�����ϥå��塣tmpdir��holdtimeɬ�ܡ�
      def FileStore.sweep_sessions(option)
        dir = option['tmpdir']
        prefix = option['prefix'] || ''
        holdtime = option['holdtime']
        raise ArgumentError, "no tmpdir option" if !dir
        raise ArgumentError, "no holdtime option" if !holdtime

        now = Time.now
        Dir.glob(dir + "/" + prefix + "*") {|fname|
          fname.untaint
          File.open(fname, "r") {|fp|
            # ��å��Ϥ��ʤ�
            fp.each_line {|line|
              k, v = line.chomp.split('=', 2)
              if k == CGI.unescape("_last-accessed") &&
                    ParseDate.get_time(CGI.unescape(v)) + holdtime < now
                File.unlink fp.path
                fp.close
                break
              end
            }
          }
        }
      end

      # @param option ���ץ������Ǽ�����ϥå��塣tmpdirɬ�ܡ�
      # @return ���å����ե����뤬¸�ߤ�����true
      def FileStore.exist?(id, option)
        dir = option['tmpdir']
        prefix = option['prefix'] || ''
        raise ArgumentError, "no tmpdir option" if !dir
        raise ArgumentError, "session_id '#{id}' is invalid" if /[^0-9a-zA-Z]/ =~ id.to_s
        id.untaint
        return FileTest.exist?(dir + "/" + prefix + id)
      end
    end # Session::FileStore

    def Session.exist?(request, option)
      session_key = option['session_key'] || '_session_id'
      id, = request[session_key]
      id, = request.cookies[session_key] if !id
      if id
        dbman = option['database_manager'] || FileStore
        return dbman.exist?(id, option)
      else
        false
      end
    end

    def Session.sweep(option)
      dbman = option['database_manager'] || FileStore
      dbman.sweep_sessions(option)
    end

    def update_access_time()
      self["_last-accessed"] = CGI.rfc1123_date(Time.now)
    end
  end
end

