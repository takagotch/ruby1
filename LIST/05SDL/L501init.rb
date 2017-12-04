# init.rb
require 'sdl'

SDL.init( SDL::INIT_VIDEO )
screen = SDL.setVideoMode( 640, 480, 16, SDL::SWSURFACE )

loop do
  case event = SDL::Event2.poll
  when SDL::Event2::Quit
    exit
  end

end
