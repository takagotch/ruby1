# move_circle_with_wait.rb
require 'sdl'
include Math

SDL.init( SDL::INIT_VIDEO )
screen = SDL.setVideoMode( 640, 480, 16, SDL::SWSURFACE )

R = 100
angle = 0.0

interval = 1.0 / 60.0 # (1)

loop do
  start_time = SDL.getTicks / 1000.0 # (2)
  while event = SDL::Event2.poll
    case event 
    when SDL::Event2::Quit
      exit
    end
  end

  angle += PI/150.0
  screen.fillRect( 0, 0, 640, 480, [ 0, 0, 0 ] ) 
  screen.drawCircle( 320+R*cos(angle), 240+R*sin(angle), 20, [ 0, 255, 0 ] )
  screen.updateRect( 0, 0, 0, 0 )
  
  now_time = SDL.getTicks / 1000.0 # (3)
  if now_time - start_time < interval then
    sleep interval - ( now_time - start_time ) # (4)
  end
  
end

