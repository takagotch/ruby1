#���X�g3.19�@ISBN�̑Ó����`�F�b�N

def isbn_check(isbn)
  if /^(\d+)-(\d+)-(\d+)-([\dX])$/ !~ isbn
    return false
  end

  isbn_num = $1+$2+$3
  check_digit = ($4 != 'X') ? $4.to_i : 10

  sum = 0
  for i in 1..9 
    sum = sum + isbn_num[i-1, 1].to_i*i
  end

  sum.divmod(11)[1] == check_digit
end

p isbn_check('4-274-06385-2') # Ruby�v���O���~���O����
p isbn_check('4-274-06461-1') # Ruby�A�v���P�[�V�����v���O���~���O
p isbn_check('4-274-06460-3') # Ruby Gem Box
p isbn_check('4-274-06472-7') # Ruby de CGI
p isbn_check('4-274-11111-2') # ����Ȃ̂Ȃ�
