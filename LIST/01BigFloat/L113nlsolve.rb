#!/usr/local/bin/ruby -Ks

#
# nlsolve.rb
#

require "BigFloat"
require "newton"
include Newton

class Function
  def initialize()
    @zero = BigFloat::new("0.0")
    @one  = BigFloat::new("1.0")
    @two  = BigFloat::new("2.0")
    @ten  = BigFloat::new("10.0")
    @eps  = BigFloat::new("1.0e-16")
  end
  def zero;@zero;end
  def one ;@one ;end
  def two ;@two ;end
  def ten ;@ten ;end
  def eps ;@eps ;end
  def values(x)
    f = []
    f1 = x[0]*x[0] + x[1]*x[1] - @two # f1 = x**2 + y**2 - 2 => 0
    f2 = x[0] - x[1]                  # f2 = x    - y        => 0
    f <<= f1
    f <<= f2
    f
  end
end
 f = BigFloat::limit(100) # �v�Z�r���̍ő包�����P�O�O���ɐ�������B
 f = Function.new         # �֐��v�I�u�W�F�N�g�̐����B
 x = [f.zero,f.zero]      # �����l�̓[��
 n = nlsolve(f,x)
 p x
