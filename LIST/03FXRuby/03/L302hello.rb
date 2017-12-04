#!/usr/local/bin/ruby

require 'fox'                                               # 1
include Fox                                                 # 2

app = FXApp.new                                             # 3
app.init(ARGV)                                              # 4
window = FXMainWindow.new(app, "Hello, FXRuby world.")      # 5
app.create                                                  # 6
window.show                                                 # 7
app.run                                                     # 8
