require 'sdl'

ScreenW = 640
ScreenH = 480
SDL.init(SDL::INIT_VIDEO)
$SCREEN = SDL::setVideoMode(ScreenW,ScreenH,16,SDL::SWSURFACE)

imgs = []
Dir.glob('suika*.bmp').sort.each do|bmp|
  i = SDL::Surface.loadBMP(bmp)
  i.setColorKey( SDL::SRCCOLORKEY ,i.format.mapRGB(254,0,254))
  imgs << i.displayFormat
end

class Suika
  def initialize surface,screen
    @screen   = screen
    @screen_w = @screen.w
    @screen_h = @screen.h

    @surface  = surface
    @img_size = @surface.size
    @img_idx  = rand(@img_size - 1)
    @img_w = @surface[@img_idx].w
    @img_h = @surface[@img_idx].h

    @x = rand(@screen_w)
    @y = rand(@screen_h)
    @dx = rand(10) + 6
  end
  def move
    @x += @dx
    @x =  0 if @x >= @screen_w - 1
    SDL.blitSurface(@surface[@img_idx], 0,0, @img_w,@img_h, @screen, @x,@y)
    @img_idx = @img_idx < @img_size - 1 ? @img_idx + 1 : 0
  end
end

# main
wm = []
(1 .. 5).each do
  wm << Suika.new(imgs,$SCREEN)
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

  $SCREEN.fillRect(0,0,$SCREEN.w,$SCREEN.h, $SCREEN.format.mapRGB(4,110,250))
  wm.each do|s|
    Thread.start do
      s.move
    end
  end

  $SCREEN.updateRect(0,0, 0,0)
  ObjectSpace.garbage_collect if $DEBUG

  sleep 0.2
end

