
require "nkf"

def j2e(s)
  s ? NKF.nkf('-e -J -m0', s) : nil
end
