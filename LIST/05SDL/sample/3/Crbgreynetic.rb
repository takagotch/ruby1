require 'sdl'
require 'Win32API'

def msgbox(msg,title=$0,opt=0+0x40)
  Win32API.new("user32","MessageBox","LPPI","I").call(0,msg,title,opt)
end
def findwindow(classname,caption)
  Win32API.new("user32", "FindWindow", "PP","N").call( classname, caption) != 0
end

class RbSCR
  def initialize
    if findwindow('SDL_app', $0) then
      msgbox("still Run")
      exit
    end
    
    @@SRC_W = 640
    @@SRC_H = 480
    @@SRC_D = 16
    @@RECTSIZE = @@SRC_W / 4
    @dst_w = @dst_h = 0

    SDL.init(SDL::INIT_VIDEO)
    SDL::WM.setCaption($0,$0)
    @screen = SDL::setVideoMode(@@SRC_W,@@SRC_H,@@SRC_D,
      SDL::SWSURFACE|SDL::ANYFORMAT) #|SDL::FULLSCREEN)
    @cursor = SDL::Mouse.state
    SDL::Mouse.hide
    @screen.fillRect 0,0,@@SRC_W,@@SRC_H,[255,0,0]
    @screen.flip
  end
  
  def finalize
    SDL::Mouse.warp(@cursor[0],@cursor[1])
    SDL::Mouse.show
  end
  def draw
    color = @screen.mapRGB rand(256),rand(256),rand(256)
    @dst_w = rand(@@RECTSIZE) + 1
    @dst_h = rand(@@RECTSIZE) + 1
    @screen.fillRect rand(@@SRC_W-@dst_w), rand(@@SRC_H-@dst_h),
      @dst_w, @dst_h, color
      @screen.updateRect 0,0,0,0
  end
end

def saver_start
  scr = RbSCR.new
  loop do
    while event = SDL::Event2.poll
      case event
      when SDL::Event2::KeyDown,
           SDL::Event2::KeyUp,
           SDL::Event2::MouseButtonDown,
           SDL::Event2::MouseButtonUp,
           SDL::Event2::Quit
#           SDL::Event2::MouseMotion,
        scr.finalize
        exit
      end
    end
    
    scr.draw
    sleep 0.01
  end
end

saver_start

=begin
# main
begin
  case ARGV[0]
  when /^\/s/i
    saver_start
  else
    #when /^\/p/i
    #  ENV['SDL_WINDOWID'] = ARGV[1]
    #  saver_start
    #when /^\/c/i
    #when /^\/a/i
    STDERR.puts "no Parameter"
  end
end
=end
