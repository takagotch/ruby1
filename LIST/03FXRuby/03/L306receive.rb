#!/usr/local/bin/ruby

require 'fox'
require 'fox/responder'                                                 #1a
include Fox

class MyWindow < FXMainWindow
  include Responder                                                     #1b
  ID_EXIT, ID_LAST = enum(FXMainWindow::ID_LAST, 2) 			#2
  def initialize(app)
    super(app, "Hello, FXRuby world.")
    FXButton.new(self, "Hello, FXRuby world.", nil, self, ID_EXIT)  	#3
    FXMAPFUNC(SEL_COMMAND, ID_EXIT, "onExit")                           #4
  end

  def onExit(sender, selector, event)                                   #5
    getApp.stop
  end
end

app = FXApp.new
app.init(ARGV)
window = MyWindow.new(app)
app.create
window.show
app.run
