Ruby Magic Ruby で極める正規表現 掲載スクリプト

１．はじめに

　これは『Ruby Magic Ruby で極める正規表現』に掲載したサンプルスクリプト
のアーカイブです。
　Windows 用と UNIX 用を用意しましたので、環境に合わせてご利用ください。

２．利用方法

２．１　Windows
　Windows 用のアーカイブは windows.zip です。ZIP により圧縮されていますので、
ZIP を Winzip など解凍可能なツールで解凍してください。

２．２　UNIX
　UNIX 用アーカイブは unix.tar.gz です。 tar でアーカイブしたものを gzip 
により圧縮しています。コマンドラインから以下のようにして解凍してください。

$ tar zxvf unix.tar.gz

２．３　共通的な事項
　Windows、UNIX いずれの場合も解凍すると書籍の章立てに対応したディレクト
リが出現し、その中に章ごとのスクリプトが格納されています。

　Windows 版とUNIX 版の違いは以下の通りです。
（１）改行コード（Windows 版は CR+LF、UNIX 版は LF）

（２）スクリプトの文字コード（Windows 版はシフトJIS、UNIX 版は日本語EUC)
　ただし、４章の fill.rb については Winodws 版も日本語EUC になっています。
このスクリプトは*必ず*日本語EUC で保存されている必要があり、シフト JIS 
に変換すると動作しませんのでご注意ください。

（３）出力文字コード（Windows 版はシフトJIS、UNIX 版は日本語EUC)
　４章の fill.rb は（２）にある通り Windows 版でも日本語 EUC で保存されてい
ますが、出力コードはシフトJISにしているため Windows でも文字化けせずに動
作します。

３．注意事項

　掲載したスクリプトの一部は本文で紹介した内容と異なっている場合がありま
す。内容としてはスクリプトの方が新しいので、随時、読み替えてください。

　なお、http://www.namaraii.com/ruby/rubymagic.html に本書のサポートページ
を公開する予定ですので、そちらも併せてご参照ください。

４．著作権など

　掲載したスクリプトは Ruby と同じライセンスでご利用可能です。Ruby のラ
イセンスについては、http://www.ruby-lang.org/ja/LICENSE.txt を参照してく
ださい。

2002.9.23 
　竹内　仁
