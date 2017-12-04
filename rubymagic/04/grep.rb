#ÉäÉXÉg4.11Å@grep.rb

require 'nkf'
require "getopts"
Code = "s"          # e: EUC, s: Shift-JIS, t: ASCII

def textfilter(pattern, line)
  line = NKF.nkf("-#{Code}", line)                                # (1)
  match = (pattern =~ line) != nil
  if match ^ $OPT_v
      prefix = ''
      prefix = ARGF.filename + ':' if $NFILES && $OPT_n
      print prefix, ARGF.file.lineno, ':' if $OPT_n
      puts line
  end
end

getopts("fnv")

if ARGV.size == 0
  $stderr.puts "usage:#{File.basename($0)} [-n] [-v] <PATTERN> [files]"
  exit 2
end

pattern = NKF.nkf("-#{Code}", ARGV.shift)                         # (2)
pattern = Regexp.quote(pattern) if $OPT_f
pattern = Regexp.new(pattern, nil, Code == "t" ? "n" : Code)
$NFILES = true if ARGV.size > 1

ARGF.each {|line| textfilter(pattern, line)}
