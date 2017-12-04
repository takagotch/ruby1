#!/usr/local/bin/ruby -Ku

require "fox"
require "fox/responder"
require "uconv"
require "kconv"

include Fox

class TxtViewWindow < FXMainWindow
  include Fox
  include Responder

  ID_FILE_OPEN, ID_ENCODE_SJIS, ID_ENCODE_EUC, ID_ENCODE_JIS, 
    ID_ENCODE_UTF8, ID_ENCODE_UTF16, ID_LAST = enum(FXMainWindow::ID_LAST, 7)

  AppName = "TxtView"

  def initialize(app)
    icon = FXPNGIcon.new(app, File.open("txtview.png", "rb").read)
    super(app, AppName, icon, icon, DECOR_ALL, 0, 0, 600, 400, 0, 0, 0, 0, 0, 0)

    # menu
    filemenu = FXMenuPane.new(self)

    FXMenuCommand.new(filemenu, "開く(&O)\tCtrl-O", nil, self, ID_FILE_OPEN, 0)
    FXMenuCommand.new(filemenu, "終了(&Q)\tCtrl-Q", nil, app, FXApp::ID_QUIT, 0)

    encodemenu = FXMenuPane.new(self)
    @encodemenu = Array.new
    @encodemenu <<
      (sjis = FXMenuCommand.new(encodemenu, "SJIS(&S)", nil, self, ID_ENCODE_SJIS, 0))
    @encodemenu <<
      FXMenuCommand.new(encodemenu, "EUC(&E)", nil, self, ID_ENCODE_EUC, 0)
    @encodemenu <<
      FXMenuCommand.new(encodemenu, "JIS(&J)", nil, self, ID_ENCODE_JIS, 0)
    @encodemenu <<
      FXMenuCommand.new(encodemenu, "UTF-8(&U)", nil, self, ID_ENCODE_UTF8, 0)
    @encodemenu <<
      FXMenuCommand.new(encodemenu, "UTF-16(&6)", nil, self, ID_ENCODE_UTF16, 0)

    sjis.checkRadio()

    # メニューバー
    menubar = FXMenubar.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X|FRAME_RAISED)
    FXMenuTitle.new(menubar, "ファイル(&F)", nil, filemenu)
    FXMenuTitle.new(menubar, "エンコード(&E)", nil, encodemenu)

    # ツールバー
    fileToolbar=FXToolbar.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X|FRAME_RAISED)

    icon = FXPNGIcon.new(app, File.open("open.png", "rb").read)
    FXButton.new(fileToolbar, "\tOpen File", icon,
		 self, ID_FILE_OPEN,
		 BUTTON_TOOLBAR|FRAME_RAISED)
    icon = FXPNGIcon.new(app, File.open("quit.png", "rb").read)
    FXButton.new(fileToolbar, "\tQuit txtview", icon,
		 app, FXApp::ID_QUIT,
		 BUTTON_TOOLBAR|FRAME_RAISED)

    # テキスト
    @text = FXText.new(self, nil, 0, 
		       LAYOUT_FILL_X|LAYOUT_FILL_Y|TEXT_READONLY)

    # message map
    FXMAPFUNC(SEL_COMMAND, ID_FILE_OPEN, "onFileOpen")
    FXMAPFUNCS(SEL_COMMAND, ID_ENCODE_SJIS, ID_ENCODE_UTF16, "onEncode")
  end

  def create
    super

    if ARGV
      readFile(ARGV[0])
    end
  end

  def dispText(str, encode = ID_ENCODE_SJIS)
    if str
      case encode
      when ID_ENCODE_SJIS
	str = Uconv::sjistou8(str)
      when ID_ENCODE_EUC
	str = Uconv::euctou8(str)
      when ID_ENCODE_JIS
	str = Uconv::euctou8(Kconv.kconv(str, Kconv::EUC, Kconv::JIS))
      when ID_ENCODE_UTF16
	str = Uconv::u16tou8(str)
      else
      end
      # DOS 改行を削除
      str = str.gsub(/\r\n/, "\n")
      @text.text = str
	
      # タイトルバーに表示
      if @filename
	self.title = AppName + " - " + Uconv::sjistou8(@filename) # + " - " + encode
      end
    end
  end

  def readFile(filename)
    # ファイル名はSJIS 
    @filename = filename
    @contents = ""
    begin
      open(filename, "r") do |fp| 
	@contents = fp.read
	encode = ID_ENCODE_SJIS
	
	# メニューから選択されているものを取得
	@encodemenu.each do |mc| 
	  if mc.isRadioChecked != 0
	    encode = mc.selector
	  end
	end
	
	dispText(@contents, encode)
      end
    rescue
    end
  end

  def onFileOpen(sender, sel, ptr)
    open = FXFileDialog.new(self, "ファイルを開く")
    if open.execute() != 0
      readFile(Uconv::u8tosjis(open.filename))
    end
    return 1    
  end

  def onEncode(sender, sel, ptr)
    dispText(@contents, SELID(sel))

    @encodemenu.each { |mc| mc.uncheckRadio() }
    sender.checkRadio()

    return 1
  end
end

application = FXApp.new
application.init(ARGV)

main = TxtViewWindow.new(application)
FXTooltip.new(application)

application.create()
main.show(PLACEMENT_SCREEN)
application.run()
