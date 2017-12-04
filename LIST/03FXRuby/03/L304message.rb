#!/usr/local/bin/ruby

require 'fox'
include Fox

app = FXApp.new
app.init(ARGV)
window = FXMainWindow.new(app, "Hello, FXRuby world.")
FXButton.new(window, "Hello, FXRuby world.", nil, app, FXApp::ID_QUIT)       #1
app.create
window.show
app.run
