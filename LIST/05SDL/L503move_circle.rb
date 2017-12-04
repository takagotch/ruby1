# move_circle.rb
require 'sdl'
include Math

SDL.init( SDL::INIT_VIDEO )
screen = SDL.setVideoMode( 640, 480, 16, SDL::SWSURFACE )

R = 100
angle = 0.0

loop do
  case event = SDL::Event2.poll
  when SDL::Event2::Quit
    exit
  end

  angle += PI/100.0
  screen.fillRect( 0, 0, 640, 480, [ 0, 0, 0 ] ) # (1)
  screen.drawCircle( 320+R*cos(angle), 240+R*sin(angle), 20, [ 0, 255, 0 ] ) # (2)
  screen.updateRect( 0, 0, 0, 0 ) # (3)
end
