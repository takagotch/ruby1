require 'sdl'               # A

SDL.init SDL::INIT_VIDEO    # B
$SCREEN = SDL::setVideoMode(640,480,16,SDL::SWSURFACE)    # C

img = SDL::Surface.loadBMP('suika000.bmp')                # D
SDL.blitSurface(img.displayFormat, 0,0,0,0, $SCREEN, 0,0) # E

$SCREEN.updateRect(0,0,0,0) # F
loop do;  sleep 1; end      # G

exit
