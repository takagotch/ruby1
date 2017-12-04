#!/usr/bin/env ruby -Ks

#�ꥹ��2.1��MatchData���饹�Υ���ץ륹����ץ�

re = Regexp.new("�����ʾ�����(.+)��(.+)�Ǥ�")

if m = re.match("�����������ʾ����ϥϥ�ߤȥ�����Ǥ��͡���������������ΤƤ���������������󥫥�Ӥ⤤�����ͤ���")
    
  p m[0]             #=> "�����ʾ����ϥϥ�ߤȥ�����Ǥ�"
  p m[1]             #=> "�ϥ��"
  p m[2]             #=> "�����"
  p m.offset(0)      #=> [6, 36]
  p m.offset(1)      #=> [18, 24]
  p m.offset(2)      #=> [26, 32]
  p m.begin(1)       #=> 18
  p m.end(1)         #=> 24
  p m.length         #=> 3
  p m.size           #=> 3
  p m.pre_match      #=> "������"
  p m.post_match     #=> "�͡���������������ΤƤ���������������󥫥�Ӥ⤤�����ͤ���"
  p m.string         #=> "�����������ʾ����ϥϥ�ߤȥ�����Ǥ��͡���������������ΤƤ���������������󥫥�Ӥ⤤�����ͤ���"
  p m.to_a           #=> ["�����ʾ����ϥϥ�ߤȥ�����Ǥ�", "�ϥ��", "�����"]
end