require 'sdl'

SDL.init SDL::INIT_VIDEO
$SCREEN = SDL::setVideoMode(640,480,16,SDL::SWSURFACE)

img = SDL::Surface.loadBMP('suika000.bmp')
SDL.blitSurface(img.displayFormat, 0,0,0,0, $SCREEN, 0,0)

$SCREEN.updateRect(0,0,0,0)

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

