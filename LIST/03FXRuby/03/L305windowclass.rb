#!/usr/local/bin/ruby

require 'fox'
include Fox

class MyWindow < FXMainWindow
  def initialize(app)
    super(app, "Hello, FXRuby world.")
    FXButton.new(self, "Hello, FXRuby world.", nil, app, FXApp::ID_QUIT)
  end
end

app = FXApp.new
app.init(ARGV)
window = MyWindow.new(app)
app.create
window.show
app.run
