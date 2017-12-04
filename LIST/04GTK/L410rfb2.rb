#!/usr/bin/ruby

require 'gtk'

$file_xpm = [								#(1)
"16 16 17 1",
" 	c None",
".	c #303030",
"+	c #DCDCDC",
"@	c #585858",
"/	c #FFFFFF",
"$	c #C3C3C3",
"%	c #A0A0A0",
"&	c #404000",
"*	c #808080",
"=	c #008000",
"-	c #000000",
";	c #FFDCA8",
">	c #00C000",
",	c #004000",
"'	c #C0FFC0",
")	c #FFA858",
"!	c #C0C000",
"    @@@@@@@@@   ",
"    @+++++$@%@  ",
"    @+/////////*/%@ ",
"    @+/////////@$/%.",
" *@&&@@&&-+*@@&.",
" *@&......+/+%*.",
" *@'>>==..+////+%.",
" @&'!*=,..+/++%.",
" @&>*==&..$/+;$.",
" @&>==,.-.$+++%.",
" @&==,,.-.++++%.",
" &......-.$+;;%.",
" &...----.$;;+%.",
"    *++$$$;;++).",
"    @$$$$$%%)%%.",
"    @..........."
]

$closed_folder_xpm = [
"16 16 14 1",
" 	c None",
".	c #FFFFFF",
"+	c #585858",
"@	c #303030",
"/	c #800000",
"$	c #000000",
"%	c #FFA858",
"&	c #C3C3C3",
"*	c #A0A0A0",
"=	c #DCDCDC",
"-	c #C05800",
";	c #FFDCA8",
">	c #808080",
",	c #FFFFFF",
"    @@          ",
"   @;%@@@       ",
"  @++%;;%@@@@@  ",
"  @--+++%;;;;%$ ",
"  @+/---++%;;;$ ",
"  @/+/+/--+++%%$",
"  @+/+/+/+---+%$",
"  @/+/+/+/+/++%$",
"  @,==/+/+/+/+%$",
"  @===&=&/+/++%$",
"  @==&=&&&*&/+%$",
"  @=&=&&&*&**+%$",
"   $@>&&*&***+%$",
"      $@>****+%$",
"         $@>*++$",
"            $@$ "
]

$opened_folder_xpm = [
"16 16 14 1",
" 	c None",
".	c #FFFFFF",
"+	c #000000",
"@	c #FFA858",
"/	c #800000",
"$	c #585858",
"%	c #FFDCA8",
"&	c #808080",
"*	c #303030",
"=	c #C3C3C3",
"-	c #FFFFFF",
";	c #C05800",
">	c #DCDCDC",
",	c #A0A0A0",
"    +++         ",
"    +@&++       ",
"    +@%@&++++   ",
"+++ +@%%%%%%@+  ",
"+$/*/@@@%%%%%@+ ",
"+/$/$/;@@@%%%@&+",
" */$/$/$;@@@%@&+",
" +&/$/$/$/;@@@&+",
"  *,=$/$/$/$@@&+",
"  +&===/$/$/@@&+",
"   *&>==/$/$$@&+",
"    +*,>>-$/$@&+",
"      +*=---%$&+",
"        +*=--&&+",
"          +*=-&+",
"            +**+"
]

class Rfb < Gtk::HPaned
  def initialize
    super()
    @listed = nil
    @prev = nil
    @file_pix,@file_mask = 
      Gdk::Pixmap::create_from_xpm_d(nil,nil,$file_xpm)		#(2)
    @opened_folder_pix,@opened_folder_mask = 
      Gdk::Pixmap::create_from_xpm_d(nil,nil,$opened_folder_xpm)
    @closed_folder_pix,@closed_folder_mask = 
      Gdk::Pixmap::create_from_xpm_d(nil,nil,$closed_folder_xpm)
    style = get_style						#(3)
    style.set_font(						#(4)
      Gdk::Font.font_load("-misc-fixed-medium-r-normal--14-*-*-*-*-*-*-*"))
    # tree box
    tscroll = Gtk::ScrolledWindow.new(nil,nil)
    @tree = Gtk::CTree.new(["Directories"],0)
    @tree.set_selection_mode(Gtk::SELECTION_BROWSE)
    @tree.set_line_style(Gtk::CTree::LINES_DOTTED)
    @tree.column_titles_hide					#(5)
    @tree.set_reorderable(true)
    @tree.set_style(style)
    parent = @tree.insert_node(
      nil,nil,["/"],5,
      @closed_folder_pix,@closed_folder_mask,
      @opened_folder_pix,@opened_folder_mask,false,true)
    @tree.node_set_row_data(parent,"/.")
    @tree.signal_connect("select_row") {|w,r,c,e|
      @tree.each_selection {|node|
	@listed = @tree.node_get_row_data(node)
	list_update(@listed)
      }
    }
    @tree.signal_connect("tree_expand") {|w,node|		#(6)
      @expanding = true
      child = node.children
      while(child)
	nxt = child.sibling
	@tree.remove_node(child)
	child = nxt
      end
      dir_update(node,@tree.node_get_row_data(node),false)
      @listed = @tree.node_get_row_data(node)
      list_update(@listed)
    }
    tscroll.add(@tree)
    tscroll.set_usize(180,-1)					#(7)
    # list box
    hadj = Gtk::Adjustment.new(0,0,0,7,0,0)
    vadj = Gtk::Adjustment.new(0,0,0,16,0,0)
    lscroll = Gtk::ScrolledWindow.new(hadj,vadj)
    @list = Gtk::CList.new(['','Name','Size','Date'])
    @list.set_selection_mode(Gtk::SELECTION_SINGLE)
    @list.set_style(style)
    @list.set_row_height(16)
    @list.set_column_width(0,16)				#(8)
    @list.set_column_width(1,7 * 30)
    @list.set_column_width(2,7 * 10)
    @list.set_column_width(3,7 * 10)
    @list.set_column_justification(1,Gtk::JUSTIFY_LEFT)		#(9)
    @list.set_column_justification(2,Gtk::JUSTIFY_RIGHT)
    @list.set_column_justification(3,Gtk::JUSTIFY_LEFT)
    @list.signal_connect("click_column") {|w,c|
      @list.sort_column = c
      @list.sort
    }
    @list.signal_connect("select_row") {|w,r,c,b|		#(10)
      t = Time.now
      now = [r,t.to_i * 1000 + t.usec / 1000]
      if(@prev)
	if(@prev[0] == now[0] and now[1] - @prev[1] < 500)
	  entry = @list.get_text(r,c)
	  view_exec("#{@listed}/#{entry}")
	end
      end
      @prev = now
    }
    lscroll.add(@list)
    add1(tscroll)
    add2(lscroll)
    dir_update(parent,"/.",false)
    list_update("/.")
  end
  def dir_update(parent,dir,flag)
    list = []
    begin
      Dir.foreach(dir) {|entry| list << entry }
    rescue
    end
    list.sort!
    @tree.freeze
    list.each {|entry|
      if(entry !~ /^\.+/)
	file = dir+"/"+entry
	if(FileTest::directory?(file))
	  child = @tree.insert_node(
	    parent,child,[entry],5,
            @closed_folder_pix,@closed_folder_mask,
            @opened_folder_pix,@opened_folder_mask,false,flag)
	  @tree.node_set_row_data(child,file)
	  childs = 0
	  begin
	    Dir.foreach(file) {|entry|
	      if(entry !~ /^\.+/)
		if(FileTest::directory?(file+"/"+entry))
		  childs += 1
		end
	      end
	    }
	  rescue
	  end
	  if(childs != 0)
	    child = @tree.insert_node(
	      child,nil,["dummy"],5,nil,nil,nil,nil,false,false)
	  end
	end
      end
    }
    @tree.thaw
  end
  def list_update(dir)
    @list.clear
    list = []
    begin
      Dir.foreach(dir) {|entry| list << entry }
    rescue
    end
    list.sort!
    i = 0
    @list.freeze
    list.each {|entry|
      if(entry !~ /^\.+/)
	file = dir+"/"+entry
	if(not FileTest::directory?(file))
	  begin
	    stat = File::stat(file)
	    size = sprintf("%10d",stat.size)
	    tm = stat.ctime
	    date = sprintf(
	      '%04d.%02d.%02d %02d:%02d:%02d',
	      tm.year, tm.month, tm.mday,
	      tm.hour, tm.min, tm.sec)
	    @list.append(["",entry,size,date])
	  rescue
	    @list.append(["",entry,"????","????"])
	  end
	  @list.set_pixmap(i,0,@file_pix,@file_mask)
	  i += 1
	end
      end
    }
    @list.thaw
  end
  def view_exec(arg)
    if(FileTest::executable?(arg))
      fork() {
	pid = fork() {
	  exec(arg)
	}
	exit!(0)
      }
      Process.wait
    else
      fork() {
	pid = fork() {
	  exec("mgedit",arg)
	}
	exit!(0)
      }
      Process.wait
    end
  end
end

class Menu < Gtk::HandleBox					#(11)
  def initialize(main)
    super()
    set_shadow_type(Gtk::SHADOW_ETCHED_IN)
    accel = Gtk::AccelGroup.new
    accel.attach(main)
    quit = Proc.new{ Gtk::main_quit }
    ifp = Gtk::ItemFactory.new(					#(12)
      Gtk::ItemFactory::TYPE_MENU_BAR,"<main>",accel)
    ifp.create_items(
      [["/ファイル(_F)",nil,Gtk::ItemFactory::BRANCH,nil,nil],
       ["/ファイル(_F)/Tearoff1",nil,Gtk::ItemFactory::TEAROFF,nil,nil],
       ["/ファイル(_F)/終了(_Q)","<control>Q",nil,quit,nil]])
    menubar = ifp.get_widget("<main>")
    add(menubar)
  end
end

main = Gtk::Window.new(Gtk::WINDOW_TOPLEVEL)
main.set_usize(650,400)
main.signal_connect("destroy") { Gtk::main_quit }
vbox = Gtk::VBox.new
vbox.pack_start(Menu.new(main),false,false,0)
vbox.pack_start(Rfb.new,true,true,0)
main.add(vbox)
main.show_all
Gtk.main
