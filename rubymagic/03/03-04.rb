#���X�g3.4�@���p���Ŋ���ꂽ������ւ̃}�b�`�i���̂P�j

re = /".*"/

teststr = ['"Ruby"',
           '�I�u�W�F�N�g�w���X�N���v�g���� "Ruby"',
           '"Ruby"��"Perl"��"Python"']

while s = teststr.shift
  puts s
  puts s.scan(re)
  puts "------------------------------"
end
