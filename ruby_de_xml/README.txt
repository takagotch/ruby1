== �͂��߂�

���̃A�[�J�C�u�ɂ́uRuby de XML�v�Ŏg�p���Ă���X�N���v�g�A
��2�͖͂̏��Ɍf�ڂ���Ă���XPath�̊֐����t�@�����X��HTML�ŁA
�t�^��REXML 2.4.2�̃c���[API�̃��t�@�����X��HTML�ł����^����Ă��܂��B

���^����Ă���X�N���v�g�A���t�@�����X��Ruby�Ɠ���
���C�Z���X�Ŏg�p�A�Ĕz�z�\�ł��B

���^����Ă���X�N���v�g�A���t�@�����X�̗��p��
�e���̐ӔC�ōs���ĉ������B
�����A�Ȃ�炩�̑��Q�A��Q�������������ꍇ�ł�����
��؂̐ӔC�𕉂�Ȃ����̂Ƃ��܂��B

== ����

�X�N���v�g�A���t�@�����X�Ƃ��ɖ{���Ōf�ڂ���Ă�����̂�
�قȂ镔��������܂��B

�X�N���v�g�ł́A�p�X���قȂ��Ă�����A�{�����ł͎��ʂ̓s���ł�
�܂�Ԃ���������邽�߂Ɏg�p���Ă���ϐ����g�p���Ă��Ȃ������肵�܂��B

���t�@�����X�ł́A�摜���e�L�X�g�x�[�X�ł̐}�ɂȂ��Ă�����A
rd2�Ń����N���쐬���邽�߂�"REXML::Element"��"REXML::Element�N���X"
���̂悤��"�N���X"��"���W���[��"���t���Ă�����ƈꕔ���O��
�ύX����Ă���ӏ�����������A�{�����ł͎��ʂ̓s���ł̐܂�Ԃ���
������邽�߂Ɏg�p���Ă���ϐ����g�p���Ă��Ȃ������肵�܂��B

�ǂ���̏ꍇ���{���Ōf�ڂ��Ă�����̂Ɩ{���I�ɂ͕ς��܂��񂪁A
�{���Ōf�ڂ��Ă�����̂Ƃ܂����������ł͂Ȃ����Ƃ��������������B

== �A�[�J�C�u

�A�[�J�C�u��Windows�p��UNIX�p���p�ӂ���Ă��܂��B

�Ⴂ�͈ȉ��̒ʂ�ł��B

   +----------+-------------+-----------+
   |          |  �����R�[�h | ���s�R�[�h|
   +----------+-------------+-----------+
   |Windows�p |  SJIS       | CR+LF     |
   +----------+-------------+-----------+
   |UNIX�p    |  EUC-JP     | LF        |
   +----------+-------------+-----------+

== ���t�@�����X

���^����Ă����̃��t�@�����X�͓����f�B���N�g�����ɂ���
base.css�Ƃ����t�@�C�����ɋL�q����Ă���CSS��ǂ݂���ł��܂��B
base.css��ҏW���邱�Ƃɂ��\���̎d����ς��邱�Ƃ��ł��܂��B

�֐�/���\�b�h�ꗗ��DOM��p����JavaScript�ō쐬����Ă��܂��B
�֐�/���\�b�h�ꗗ�𐶐��������Ȃ��ꍇ�́AHTML�t�@�C����body�v�f��
�Ō�̎q�v�f��script�v�f����"make_function_list();"�܂���
"make_method_list();"�Ƃ���s�̍s����"//"�����ăR�����g�A�E�g���邩�A
�u���E�U��JavaScript�̋@�\��OFF�ɂ��ĉ������B

== �f�B���N�g���\��

  ruby_de_xml
  |-- 02
  |   |-- base.css
  |   |-- common.js
  |   |-- xpath_reference.html
  |   `-- xpath_speed.rb
  |-- 03
  |   `-- rxsh.rb
  |-- 04
  |   |-- sax2_del1.rb
  |   |-- sax2_del2.rb
  |   |-- sax_speed.rb
  |   |-- stream_ns.rb
  |   |-- stream_ref.rb
  |   `-- streaming_api_speed.rb
  |-- 05
  |   |-- calc_client.rb
  |   |-- calc_conf.rb
  |   |-- calc_server.rb
  |   `-- xmlrpc_get_server_info.rb
  |-- 06
  |   |-- echo_client.rb
  |   |-- echo_server.rb
  |   |-- rxsh.rb
  |   |-- rxsh_cgi.rb
  |   |-- rxsh_client.rb
  |   |-- rxsh_conf.rb
  |   `-- rxsh_server.rb
  |-- README.txt
  |-- ap
  |   |-- base.css
  |   |-- common.js
  |   `-- reference.html
  `-- etc
      `-- mathml.rlx

== ����

�{������ 2002.11
