
require "nkf"

def sjis2eucjp(s)
  s ? NKF.nkf("-m0 -S -e", s) : nil
end
