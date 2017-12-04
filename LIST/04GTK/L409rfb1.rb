#!/usr/bin/ruby

require 'gtk'

#
# Ruby File Browser
#

class Rfb < Gtk::Window
  def initialize
    super(Gtk::WINDOW_TOPLEVEL)						#(1-1)
    signal_connect("destroy") { exit }
    pane = Gtk::HPaned.new						#(1-2)
    tscroll = Gtk::ScrolledWindow.new(nil,nil)				#(1-3)
    tree = Gtk::Tree.new						#(1-4)
    tscroll.add_with_viewport(tree)					#(2-1)
    item = Gtk::TreeItem.new("/")					#(2-2)
    tree.append(item)							#(2-3)
    @root = Gtk::Tree.new						#(2-4)
    item.set_subtree(@root)						#(2-5)
    lscroll = Gtk::ScrolledWindow.new(nil,nil)				#(1-5)
    @list = Gtk::CList.new(						#(1-6)
      ['ファイル名','モード','UID','GID','サイズ','最終更新日'])
    @list.signal_connect("click_column") {|w,c|			---+	#(4-1)
      @list.sort_column = c					   |
      @list.sort						   |
    }								---+
    @list.signal_connect("select_row") {|w,r,c,b|		---+	#(4-2)
      entry = @list.get_text(r,c)				   |	#(4-3)
      view_exec("#{@listed}/#{entry}")				   |
    }								---+
    lscroll.add(@list)
    pane.add1(tscroll)							#(1-7)
    pane.add2(lscroll)							#(1-8)
    add(pane)								#(1-9)
    dir_update(@root,"/.")
    list_update("/.")
    show_all
    item.expand
  end
  #
  # ツリーリストの作成
  #
  def dir_update(tree,dir)
    first = nil							---+	#(3-1)
    tree.foreach {|item|					   |
      if(first)							   |
        tree.remove(item)					   |
      else							   |
        first = item						   |
      end							   |
    }								---+
    list = []
    Dir.foreach(dir) {|entry| list << entry }				#(3-2)
    list.sort!
    list.each {|entry|							#(3-3)
      if(entry !~ /^\.+/)
        file = dir+"/"+entry
        if(FileTest::directory?(file))					#(3-4)
          item = Gtk::TreeItem.new(entry)				#(3-5)
          item.show
          tree.append(item)
          childs = 0						---+	#(3-6)
          begin							   |
            Dir.foreach(file) {|entry|				   |
              if(entry !~ /^\.+/)				   |
                if(FileTest::directory?(file+"/"+entry))	   |
                  childs += 1					   |
                end						   |
              end						   |
            }							   |
          rescue						   |
          end							   |
          if(childs != 0)					   |
            subtree = Gtk::Tree.new				   |
            item.set_subtree(subtree)				---+
            item.signal_connect(				---+	#(4-4)
              "expand",subtree,file) {|item,tree,file|		   |
              dir_update(tree,file)				   |
            }							---+
          end
          item.signal_connect(					---+	#(4-5)
            "select",subtree,file) {|item,tree,file|		   |
            @listed = file					   |
            list_update(file)					   |
          }							---+
        end
      end
    }
    tree.remove(first) if(first)					#(3-1)
  end
  #
  # ファイル一覧の作成
  #
  def list_update(dir)
    @list.clear
    list = []
    begin
      Dir.foreach(dir) {|entry| list << entry }
    rescue
    end
    list.sort!
    i = 0
    list.each {|entry|
      if(entry !~ /^\.+/)
        file = dir+"/"+entry
        if(not FileTest::directory?(file))
          begin
            stat = File::stat(file)
            mode = ""
            mode << (((stat.mode & 0x001) != 0) ? "x" : "-")
            mode << (((stat.mode & 0x002) != 0) ? "w" : "-")
            mode << (((stat.mode & 0x004) != 0) ? "r" : "-")
            mode << (((stat.mode & 0x008) != 0) ? "x" : "-")
            mode << (((stat.mode & 0x010) != 0) ? "w" : "-")
            mode << (((stat.mode & 0x020) != 0) ? "r" : "-")
            mode << (((stat.mode & 0x040) != 0) ? "x" : "-")
            mode << (((stat.mode & 0x080) != 0) ? "w" : "-")
            mode << (((stat.mode & 0x100) != 0) ? "r" : "-")
            mode << (((stat.mode & 0x200) != 0) ? "d" : "-")
            mode.reverse!
            uid = sprintf("%5d",stat.uid)
            gid = sprintf("%5d",stat.gid)
            size = sprintf("%10d",stat.size)
            tm = stat.mtime
            date = sprintf(
              '%04d.%02d.%02d %02d:%02d:%02d',
              tm.year, tm.month, tm.mday,
              tm.hour, tm.min, tm.sec)
            @list.append([entry,mode,uid,gid,size,date])
          rescue
            @list.append([entry,"--------","?????",
              "?????","??????????","???????????????????"])
          end
          i += 1
        end
      end
    }
  end
  #
  # ファイルの表示／実行
  #
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

#
# メイン
#

browser = Rfb.new
Gtk.main
