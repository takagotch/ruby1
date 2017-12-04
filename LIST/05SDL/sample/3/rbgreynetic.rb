require 'sdl'
require 'Win32API'

def msgbox(msg,title=$0,opt=0+0x40)
  Win32API.new("user32","MessageBox","LPPI","I").call(0,msg,title,opt)
end
def findwindow(classname,caption)
  Win32API.new("user32", "FindWindow", "PP","N").call( classname, caption) != 0
end

if ARGV.size == 0 then                     # A. Å´
  msgbox("no Parameter")
  exit
end
unless /^\/s/i === ARGV[0] then
  msgbox("Parameter error")
  exit
end                                        # A. Å™

if findwindow('SDL_app', $0) then          # B-1.
#  msgbox("still Run")
  exit
end

src_w = 640
src_h = 480
src_d = 16
dst_w = dst_h = 0

RECTSIZE = src_w / 4

SDL.init(SDL::INIT_VIDEO)
SDL::WM.setCaption($0,$0)                  # B-2.
cursor = SDL::Mouse.state                  # C-1.
SDL::Mouse.hide                            # D-1.
$SCREEN = SDL::setVideoMode(src_w,src_h,src_d,
      SDL::SWSURFACE|SDL::ANYFORMAT|SDL::FULLSCREEN)
$SCREEN.fillRect 0,0,src_w,src_h,[255,0,0]
$SCREEN.flip

loop do
  while event = SDL::Event2.poll
    case event
    when SDL::Event2::KeyDown,             # E.Å´
         SDL::Event2::KeyUp,
         SDL::Event2::MouseMotion,
         SDL::Event2::MouseButtonDown,
         SDL::Event2::MouseButtonUp,
         SDL::Event2::Quit                 # E.Å™
      SDL::Mouse.warp(cursor[0],cursor[1]) # C-2.
      SDL::Mouse.show                      # D-2.
      exit
    end
  end
  
  color = $SCREEN.mapRGB rand(256),rand(256),rand(256)
  dst_w = rand(RECTSIZE) + 1
  dst_h = rand(RECTSIZE) + 1
  $SCREEN.fillRect rand(src_w-dst_w), rand(src_h-dst_h), dst_w, dst_h, color
  $SCREEN.updateRect 0,0,0,0
end

