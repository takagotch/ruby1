require 'sdl'

ScreenW = 640
ScreenH = 480
SDL.init(SDL::INIT_VIDEO)
$SCREEN = SDL::setVideoMode(ScreenW,ScreenH,16,SDL::SWSURFACE)

imgs = []
Dir.glob('suika*.bmp').sort.each do|bmp|
  i = SDL::Surface.loadBMP(bmp)                                # H1
  i.setColorKey( SDL::SRCCOLORKEY ,i.format.mapRGB(254,0,254)) # H2
  imgs << i.displayFormat
end

idx = 0
loop do
  while event = SDL::Event2.poll
    case event
    when SDL::Event2::Quit, SDL::Event2::MouseButtonDown
      exit
    when SDL::Event2::KeyDown
      exit if event.sym == SDL::Key::ESCAPE
    end
  end

  $SCREEN.fillRect(0,0,ScreenW,ScreenH, $SCREEN.format.mapRGB(4,110,250)) # I1
  SDL.blitSurface(imgs[idx].displayFormat, 0,0,0,0, $SCREEN, 0,0)         # I2
  if idx < imgs.size - 1
    idx += 1
  else
    idx  = 0
  end
  $SCREEN.updateRect(0,0, 0,0)                                            # I3

  sleep 0.2
end

