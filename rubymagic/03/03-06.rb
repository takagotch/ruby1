#���X�g3.6�@���p���Ŋ���ꂽ������ւ̃}�b�`�i���̂Q�j

re = /".*?"/

teststr = ['"Ruby"',
           '�I�u�W�F�N�g�w���X�N���v�g���� "Ruby"',
           '"Ruby"��"Perl"��"Python"']

while s = teststr.shift
  puts s
  puts s.scan(re)
  puts "------------------------------"
end
