# draw_line.rb
require 'sdl'

SDL.init( SDL::INIT_VIDEO )
screen = SDL.setVideoMode( 640, 480, 16, SDL::SWSURFACE )

screen.drawLine( 50, 50, 600, 440, [ 255, 0, 0 ] )
screen.updateRect( 0, 0, 0, 0 )

loop do
  case event = SDL::Event2.poll
  when SDL::Event2::Quit
    exit
  end

end
