#!/usr/local/bin/ruby -Ku

require 'fox'
include Fox

class MyWindow < FXMainWindow
  def initialize(app)
    super(app, "Layout test.")
    FXButton.new(self, "メニュー", nil, nil, 0, 
	BUTTON_NORMAL|LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
    FXButton.new(self, "ツールバー", nil, nil, 0, 
	BUTTON_NORMAL|LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
    FXButton.new(self, "表示領域", nil, nil, 0, 
	LAYOUT_FILL_X|LAYOUT_FILL_Y)
  end
end

app = FXApp.new
app.init(ARGV)
window = MyWindow.new(app)
app.create
window.show
app.run
