#! /usr/local/bin/ruby -Ku

require "fox"
require "fox/responder"

include Fox

class TxtViewWindow < FXMainWindow
  include Fox
  include Responder

  def initialize(app)
    icon = FXPNGIcon.new(app, File.open("txtview.png", "rb").read)
    super(app, "TxtView", icon, icon, DECOR_ALL, 0, 0, 600, 400, 0, 0, 0, 0, 0, 0)
    # メニュー
    filemenu = FXMenuPane.new(self)
    FXMenuCommand.new(filemenu, "開く(&O)\tCtrl-O")
    FXMenuCommand.new(filemenu, "終了(&Q)\tCtrl-Q", nil, app, FXApp::ID_QUIT, 0)

    encodemenu = FXMenuPane.new(self)
    FXMenuCommand.new(encodemenu, "SJIS(&S)")
    FXMenuCommand.new(encodemenu, "EUC(&E)")
    FXMenuCommand.new(encodemenu, "JIS(&J)")
    FXMenuCommand.new(encodemenu, "UTF-8(&U)")
    FXMenuCommand.new(encodemenu, "UTF-16(&6)")

    # メニューバー
    menubar = FXMenubar.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X|FRAME_RAISED)
    FXMenuTitle.new(menubar, "ファイル(&F)", nil, filemenu)
    FXMenuTitle.new(menubar, "エンコード(&E)", nil, encodemenu)

    # ツールバー
    fileToolbar=FXToolbar.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X|FRAME_RAISED)
    icon_open = FXPNGIcon.new(app, File.open("open.png", "rb").read)
    FXButton.new(fileToolbar, "\tOpen File", icon_open,
		 nil, 0, BUTTON_TOOLBAR|FRAME_RAISED)
    icon_quit = FXPNGIcon.new(app, File.open("quit.png", "rb").read)
    FXButton.new(fileToolbar, "\tQuit txtview", icon_quit,
		 app, FXApp::ID_QUIT, BUTTON_TOOLBAR|FRAME_RAISED)

    # テキスト
    @text = FXText.new(self, nil, 0, 
		       LAYOUT_FILL_X|LAYOUT_FILL_Y|TEXT_READONLY)
  end
end

application = FXApp.new("TxtView", "taka-hr.dhis.portside.net")
application.init(ARGV)

main = TxtViewWindow.new(application)
FXTooltip.new(application)

application.create()
main.show(PLACEMENT_SCREEN)
application.run()
