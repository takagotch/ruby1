# event_test.rb
require 'sdl'

SDL.init( SDL::INIT_VIDEO )
screen = SDL.setVideoMode( 640, 480, 16, SDL::SWSURFACE )

x = 320
y = 240
loop do
  event = SDL::Event2.poll        # (1)
  case event                      # (2)
  when SDL::Event2::Quit          # (3)
    exit
  when SDL::Event2::KeyDown       # (4)
    case event.sym                # (5)
    when SDL::Key::ESCAPE
      exit
    when SDL::Key::UP
      y -= 10
    when SDL::Key::DOWN
      y += 10
    when SDL::Key::RIGHT
      x += 10
    when SDL::Key::LEFT
      x -= 10
    end
  end
  
  # 画面からはみださないようにする
  x = 30 if x < 30
  x = 610 if x > 610
  y = 30 if y < 30
  y = 450 if y > 450

  screen.fillRect( 0, 0, 640, 480, [ 0, 0, 0 ] )
  screen.fillRect( x-10, y-10, 20, 20, [ 0, 0, 255 ] )
  screen.updateRect( 0, 0, 0, 0 )
  
end
