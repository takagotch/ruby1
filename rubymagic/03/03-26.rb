#���X�g3.26�@���[���A�h���X�փ}�b�`���鐳�K�\���̃e�X�g

def mailcheck(mailaddr)
  if /^[\w!#\$%&'*+\-\/=?^`{|}~]+@[\w!#\$%&'*+\-\/=?^`{|}~]+(?:\.[\w!#\$%&'*+\-\/=?^`{|}~]+)*$/ =~ mailaddr
    puts "\"#{mailaddr}\" is valid."
  else
    puts "\"#{mailaddr}\" is invalid."
  end
end

mailcheck('fortress@anet.ne.jp')
mailcheck('fortress')
mailcheck('fortress@.ne.jp')
mailcheck('for<tress@anet.ne.jp')
mailcheck('fortress@an>t.ne.jp')
mailcheck('fortress@anet')
