#
# jacobian.rb
#
# �֐��I�u�W�F�N�g f �� x �ɂ����� Jacobian �s�� ���v�Z����B
# fx �� x �ɂ�����֐��l�x�N�^�[�B
#
# �Ăяo���`���F
#   dfdx =  jacobian(f,fx,x)
# ����
#   f ... Jacobian �s�� ���v�Z����֐��I�u�W�F�N�g�B
#         f.values(x) �Ŋ֐��x�N�^�[���v�Z�ł���Ηǂ��B
#   fx... �ϐ��l�� x �̎��̊֐��l�x�N�^�[�B
#   x ... Jacobian �s����v�Z���鎞�_�̉E�Ӄx�N�^�[�B
#
module Jacobian
  def isEqual(a,b,zero=0.0,e=1.0e-8)
    aa = a.abs
    bb = b.abs
    if aa == zero &&  bb == zero then
          true
    else
          if ((a-b)/(aa+bb)).abs < e then
             true
          else
             false
          end
    end
  end

  def dfdxi(f,fx,x,i)
  #
  # �֐��x�N�^�[ f �� x[i] �Ŕ�������B
  #
    nRetry = 0
    n = x.size
    xSave = x[i]
    ok = 0
    ratio = f.ten*f.ten*f.ten
    dx = x[i].abs/ratio
    dx = fx[i].abs/ratio if isEqual(dx,f.zero,f.zero,f.eps)
    dx = f.one/f.ten     if isEqual(dx,f.zero,f.zero,f.eps)
    until ok>0 do
      s = f.zero
      deriv = []
      #
      # ���l�������邽�߂� x[i] �̕ω���(dx)���v�Z����B
      # 
      if(nRetry>100) then
         raize "Jacobian �����قł��B x[" + i.to_s + "] �ɑ΂��ĕω����܂���B"
      end
      dx = dx*f.two
      x[i] += dx
      fxNew = f.values(x)
      for j in 0...n do
        if !isEqual(fxNew[j],fx[j],f.zero,f.eps) then
           ok += 1
           deriv <<= (fxNew[j]-fx[j])/dx
        else
           deriv <<= f.zero
        end
      end
      x[i] = xSave
    end
    deriv
  end

  def jacobian(f,fx,x)
    n = x.size
    dfdx = Array::new(n*n)
    for i in 0...n do
      df = dfdxi(f,fx,x,i)
      for j in 0...n do
         dfdx[j*n+i] = df[j]
      end
    end
    dfdx
  end
end
