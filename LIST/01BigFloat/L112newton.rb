#
# newton.rb 
#
# �֐��I�u�W�F�N�g f = 0 �� Newton �@�ŉ����B
#
# �Ăяo���`���F
#   n = nlsolve(f,x)
# ����
#   f ... Jacobian �s�� ���v�Z���邽�߂̊֐��I�u�W�F�N�g�B
#       [f���Œ���p�ӂ��Ȃ���΂����Ȃ����\�b�h]
#         f.values(x) ��x�ł̊֐��x�N�^�[���v�Z�B
#         f.zero      0.0 ��Ԃ��B
#         f.one       1.0 ��Ԃ��B
#         f.two       1.0 ��Ԃ��B
#         f.ten      10.0 ��Ԃ��B
#         f.eps      ��������萔
#   x ... �����l
#
require "ludcmp"
require "jacobian"

module Newton
  include LUSolve
  include Jacobian
  
  def norm(fv,zero=0.0)
    s = zero
    n = fv.size
    for i in 0...n do
      s += fv[i]*fv[i]
    end
    s
  end

  def nlsolve(f,x)
    nRetry = 0
    n = x.size

    f0 = f.values(x)
    zero = f.zero
    one  = f.one
    two  = f.two
    p5 = one/two
    d  = norm(f0,zero)
    minfact = f.ten*f.ten*f.ten
    minfact = one/minfact
    e = f.eps
    while d >= e do
      nRetry += 1
      # �������Ă��Ȃ��̂Ŕ��W�����v�Z����B
      dfdx = jacobian(f,f0,x)
      # dfdx*dx = -f0 �������āA�ω��� dx ���v�Z����B
      dx = lusolve(dfdx,f0,ludecomp(dfdx,n,zero,one),zero)
      fact = two
      xs = x.dup
      begin
        fact *= p5
        if fact < minfact then
          raize "�֐��l�̂Q��a�����������邱�Ƃ��ł��܂���B"
        end
        for i in 0...n do
          x[i] = xs[i] - dx[i]*fact
        end
        f0 = f.values(x)
        dn = norm(f0,zero)
      end while(dn>=d)
      p x  # �����󋵂����邽�߂̃f�o�b�O�o��
      d = dn
    end
    nRetry
  end
end
