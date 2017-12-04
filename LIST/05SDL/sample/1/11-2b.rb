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

idx = 0
img_w = imgs[idx].w
img_h = imgs[idx].h
$SCREEN.fillRect(0,0,ScreenW,ScreenH, $SCREEN.format.mapRGB(4,110,250))
$SCREEN.updateRect(0,0, 0,0)

loop do
  while event = SDL::Event2.poll
    case event
    when SDL::Event2::Quit, SDL::Event2::MouseButtonDown
      exit
    when SDL::Event2::KeyDown
      exit if event.sym == SDL::Key::ESCAPE
    end
  end

  $SCREEN.fillRect(0,0,img_w,img_h, $SCREEN.format.mapRGB(4,110,250))
  SDL.blitSurface(imgs[idx].displayFormat, 0,0,0,0, $SCREEN, 0,0)
  idx = idx < imgs.size - 1 ? idx + 1 : 0
  $SCREEN.updateRect(0,0, img_w,img_h)

  sleep 0.2
end

