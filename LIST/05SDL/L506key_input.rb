# key_input.rb
require 'sdl'

SDL.init( SDL::INIT_VIDEO )
screen = SDL.setVideoMode( 640, 480, 16, SDL::SWSURFACE )

x = 320
y = 240

V = 4

loop do
  while event = SDL::Event2.poll
    case event 
    when SDL::Event2::Quit
      exit
    end
  end
  
  SDL::Key.scan  # (1)

  # (2)
  x += V if SDL::Key.press?( SDL::Key::RIGHT )
  x -= V if SDL::Key.press?( SDL::Key::LEFT )
  y += V if SDL::Key.press?( SDL::Key::DOWN )
  y -= V if SDL::Key.press?( SDL::Key::UP )

  # ��ʂ���݂͂����Ȃ��悤�ɂ���
  x = 30 if x < 30
  x = 610 if x > 610
  y = 30 if y < 30
  y = 450 if y > 450

  screen.fillRect( 0, 0, 640, 480, [ 0, 0, 0 ] )
  screen.fillRect( x-10, y-10, 20, 20, [ 0, 0, 255 ] )
  screen.updateRect( 0, 0, 0, 0 )
  
end
