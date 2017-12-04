#
# minimize.rb
#
require "BigFloat"
module Minimizer
  def doFunc(x) # ���̒�`�i�ړI�֐��j
    raise "����ł͌v�Z�ł��܂���BdoFunc(x) �͕K�������Œ�`���ĂˁB"
  end

  # ���ۂ̉�@����
  def solve(x,deltax,epsMove,epsFunc=nil)  # doFunc(x)<=epsFunc �������B
    # �߂�l��doFunc(x)�̍ŏ��l�A�܂��͋ɏ��l�B
    # �����̐���
    #   x       ... �����̔z��A���͎��͏����l�B
    #   deltax  ... �ړ����̔z��
    #   epsMove ... x[i]�̍ŏ��ړ����B�ɏ��_�̔���ɗp����B
    #   epsFunc ... doFunc(x)�̊�]�ŏ��l�Bnil�Ȃ�ɏ��_�܂ŌJ��Ԃ��B
    fvNow   = doFunc(x)
    goodTry = BigFloat.new("1.5")    # ���܂��������Ƃ��A���͍X�ɐL�΂������B
    badTry  = BigFloat.new("-0.5")   # ���s�����Ƃ��A�t�����ɍs�������B
    nx      = x.size
    while (epsFunc==nil)||(fvNow>epsFunc) # �֐��l>epsFunc�͌J��Ԃ��B
      nCount = 0
      deltax.each_with_index {|dx,i|
        xSave = x[i].dup
        begin
          if dx.abs >= epsMove     # ��������H
            x[i]      = xSave + dx # x[i] ���`���b�g�������B
            fvTry = doFunc(x)      # x[i] �� dx �����������Čv�Z����B
            dx   *=  badTry        # �����_���Ȃ�A���͋t�����𒲂ׂ邱�Ƃɂ���B
          else
            nCount += 1            # �������Ȃ�����A�J�E���g����B
            if nCount >= nx        # �S�ē��������Ǐ������Ȃ�Ȃ�=>�ɏ��l
               return fvNow if epsFunc==nil # �ɏ��l�����߂����ꍇ
               raise "�����u�ɏ��l�v�Ƀn�}�����̂ŁA�����܂���B"
            end
            i = -1                 # �u�������Ă��_���������v�Ƃ�����B
            break                  # x[i]�̓_���A���ix[i+1]�j�ɍs�����I
          end
        end while fvTry>=fvNow      # �������Ȃ�܂ŌJ��Ԃ��B
        if i>=0                     # ���߂��I�@�������Ȃ����B
           fvNow = fvTry            # ����fvNow�ȉ���ڎw���B
           deltax[i] *= goodTry     # ���q�ɏ���Ă����Ɛi�񂶂Ⴆ�I
        end
      }
    end
    fvNow
  end
end
