#ÉäÉXÉg4.10Å@grep2.rb

require "getopts"

def textfilter(pattern, line)                                    # (1)
  match = (pattern =~ line) != nil
  if match ^ $OPT_v
      prefix = ''
      prefix = ARGF.filename + ':' if $NFILES && $OPT_n
      print prefix, ARGF.file.lineno, ':' if $OPT_n
      puts line
  end
end

getopts("fnv")                                                   # (2)

if ARGV.size == 0
  $stderr.puts "usage:#{File.basename($0)} [-n] [-v] <PATTERN> [files]"
  exit 2
end

pattern = $OPT_f ? Regexp.quote(ARGV.shift):ARGV.shift           # (3)
pattern = Regexp.new(pattern, nil)
$NFILES = true if ARGV.size > 1                                  # (4)

ARGF.each {|line| textfilter(pattern, line)}
