#!/usr/local/bin/ruby -Ku

require "fox"
require "fox/responder"
require "uconv"
require "kconv"

include Fox

class ToggleController < FXWindow
  include Responder
  
  def initialize(app, target = nil, id_from = nil, id_to = nil)
    super(app)
    @target = target
    @selected = nil

    @childs = Hash.new

    if id_from && id_to
      FXMAPFUNCS(SEL_COMMAND, id_from, id_to, "onCommand")
    end
  end

  def add(child, id = nil)
    child.target = self
    id = child.selector if id == nil

    if id
      if @childs[id] == nil
	@childs[id] = Array.new
      end

      if !@childs[id].include?(child)
	@childs[id] << child
      end
    end
  end

  def onCommand(sender, sel, ev)
    self.selected = SELID(sel)
    @target.handle(self, sel, ev)
  end

  def selected=(id)
    if @selected && @childs[@selected]
      @childs[@selected].each do | c |
	c.handle(self, MKUINT(ID_UNCHECK, SEL_COMMAND), nil)
      end
    end

    @selected = id
    if @childs[@selected]
      @childs[@selected].each do | c |
	c.handle(self, MKUINT(ID_CHECK, SEL_COMMAND), nil)
      end
    end
  end

  attr_reader :selected
end

class TxtViewWindow < FXMainWindow
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

    @encodes = ToggleController.new(self, self, ID_ENCODE_SJIS, ID_ENCODE_UTF16)

    @encodes.add FXMenuCommand.new(encodemenu, "SJIS(&S)", nil, self, ID_ENCODE_SJIS, 0)

    @encodes.add FXMenuCommand.new(encodemenu, "EUC(&E)", nil, self, ID_ENCODE_EUC, 0)
    @encodes.add FXMenuCommand.new(encodemenu, "JIS(&J)", nil, self, ID_ENCODE_JIS, 0)
    @encodes.add FXMenuCommand.new(encodemenu, "UTF-8(&U)", nil, self, ID_ENCODE_UTF8, 0)
    @encodes.add FXMenuCommand.new(encodemenu, "UTF-16(&6)", nil, self, ID_ENCODE_UTF16, 0)

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

    icon = FXPNGIcon.new(app, File.open("sjis.png", "rb").read)
    @encodes.add FXButton.new(fileToolbar, "\tSJIS", icon,
			      self, ID_ENCODE_SJIS,
			      BUTTON_TOOLBAR|FRAME_RAISED)
    icon = FXPNGIcon.new(app, File.open("euc.png", "rb").read)
    @encodes.add FXButton.new(fileToolbar, "\tEUC", icon,
			      self, ID_ENCODE_EUC,
			      BUTTON_TOOLBAR|FRAME_RAISED)
    icon = FXPNGIcon.new(app, File.open("jis.png", "rb").read)
    @encodes.add FXButton.new(fileToolbar, "\tJIS", icon,
			      self, ID_ENCODE_JIS,
			      BUTTON_TOOLBAR|FRAME_RAISED)
    icon = FXPNGIcon.new(app, File.open("UTF-8.png", "rb").read)
    @encodes.add FXButton.new(fileToolbar, "\tUTF-8", icon,
			      self, ID_ENCODE_UTF8,
			      BUTTON_TOOLBAR|FRAME_RAISED)
    icon = FXPNGIcon.new(app, File.open("UTF-16.png", "rb").read)
    @encodes.add FXButton.new(fileToolbar, "\tUTF-16", icon,
			      self, ID_ENCODE_UTF16,
			      BUTTON_TOOLBAR|FRAME_RAISED)


    @encodes.selected = ID_ENCODE_SJIS

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
	self.title = AppName + " - " + Uconv::sjistou8(@filename)
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
	encode = @encodes.selected
	
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
