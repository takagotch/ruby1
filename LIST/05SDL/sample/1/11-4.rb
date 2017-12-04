require 'sdl'

class RandomFilename
  def initialize filepattern
    @files = Dir.glob(filepattern)
    @stack = @files.clone
  end
  def get
    @stack = @files.clone if @stack.size == 0
    @stack.delete_at(rand(@stack.size) )
  end
end

ScreenW = 640
ScreenH = 480
SDL.init SDL::INIT_VIDEO

SDL::WM.setCaption("this is Watermeron", "suika")
SDL::WM.icon= SDL::Surface.loadBMP("icon_suika.bmp")

$SCREEN = SDL::setVideoMode(ScreenW,ScreenH,16,SDL::SWSURFACE)

rf = RandomFilename.new('suika*.bmp')

Thread.start do
  loop do
    img = SDL::Surface.loadBMP(rf.get)
    255.times do|i|
      $SCREEN.fillRect(0,0,ScreenW,ScreenH,0)
      img.setAlpha(SDL::SRCALPHA,i%256)
      $SCREEN.put(img,($SCREEN.w - img.w)/2, ($SCREEN.h - img.h)/2 )
      $SCREEN.flip
      
      sleep 0.2    # J
    end
    sleep 5
  end
end

loop do
  while event = SDL::Event2.poll
    case event
    when SDL::Event2::Quit, SDL::Event2::MouseButtonDown
      exit
    when SDL::Event2::KeyDown
      exit if event.sym == SDL::Key::ESCAPE
    end
  end
  sleep 1
end

