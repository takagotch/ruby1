#!/usr/local/bin/ruby

require 'fox'
include Fox

class MyWindow < FXMainWindow
  def initialize(app)
    super(app, "Layout test.")
    FXButton.new(self, "button 1", nil, nil, 0, 
	BUTTON_NORMAL|LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
    FXButton.new(self, "button 2 long caption", nil, nil, 0, 
	BUTTON_NORMAL|LAYOUT_SIDE_TOP |LAYOUT_RIGHT)
    FXButton.new(self, "button 3", nil, nil, 0, 
	BUTTON_NORMAL|LAYOUT_SIDE_RIGHT | LAYOUT_FILL_Y)
    FXButton.new(self, "button 4", nil, nil, 0, 
	BUTTON_NORMAL|LAYOUT_FILL_X)
    FXButton.new(self, "button 5 long long long caption", nil, nil, 0, 
	BUTTON_NORMAL|LAYOUT_FILL_X)
    FXButton.new(self, "button 6", nil, nil, 0,
	BUTTON_NORMAL|LAYOUT_FILL_X)
    FXButton.new(self, "Quit", nil, app, FXApp::ID_QUIT)
  end
end

app = FXApp.new
app.init(ARGV)
window = MyWindow.new(app)
app.create
window.show
app.run
