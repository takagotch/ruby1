#!/usr/local/bin/ruby -Ku

require 'fox'
require 'fox/responder'
include Fox

class MyWindow < FXMainWindow
  include Responder
  def initialize(app)
    super(app, "FXRuby �T���v���v���O����")
    FXButton.new(self, "�{�^���������ƏI�����܂�", nil, app, FXApp::ID_QUIT)
  end
end

app = FXApp.new
app.init(ARGV)
window = MyWindow.new(app)
app.create
window.show
app.run
