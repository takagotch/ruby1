# draw_bmp2.rb
require 'sdl'

SDL.init( SDL::INIT_VIDEO )
screen = SDL.setVideoMode( 640, 480, 16, SDL::SWSURFACE )

image = SDL::Surface.loadBMP( 'sample.bmp' ) # (1)
image.setColorKey( SDL::SRCCOLORKEY|SDL::RLEACCEL , image.getPixel( 0, 0 ) ) # (2)
image = image.displayFormat # (3)

for i in 1..150
  SDL.blitSurface( image, 0, 0, 32, 32, screen, rand(640), rand(480) ) # (4)
end
screen.updateRect( 0, 0, 0, 0 )

loop do
  while event = SDL::Event2.poll
    case event
    when SDL::Event2::Quit
      exit
    end
  end

  sleep 0.05
end
