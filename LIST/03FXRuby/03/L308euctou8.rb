#!/usr/local/bin/ruby -Ke

require 'fox'
require 'fox/responder'
require 'uconv'
include Fox

class MyWindow < FXMainWindow
  include Responder
  def initialize(app)
    super(app, Uconv::euctou8("FXRuby サンプルプログラム"))
    FXButton.new(self, Uconv::euctou8("ボタンを押すと終了します"), 
	nil, app, FXApp::ID_QUIT)
  end
end

app = FXApp.new
app.init(ARGV)
window = MyWindow.new(app)
app.create
window.show
app.run
