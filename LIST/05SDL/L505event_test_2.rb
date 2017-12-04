# event_test_2.rb
require 'sdl'

SDL.init( SDL::INIT_VIDEO )
screen = SDL.setVideoMode( 640, 480, 16, SDL::SWSURFACE )

x = 320
y = 240
loop do
  while event = SDL::Event2.poll    # (1)
    case event                  
    when SDL::Event2::Quit      
      exit
    when SDL::Event2::KeyDown   
      case event.sym            
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
  end
  
  # ‰æ–Ê‚©‚ç‚Í‚Ý‚¾‚³‚È‚¢‚æ‚¤‚É‚·‚é
  x = 30 if x < 30
  x = 610 if x > 610
  y = 30 if y < 30
  y = 450 if y > 450

  screen.fillRect( 0, 0, 640, 480, [ 0, 0, 0 ] )
  screen.fillRect( x-10, y-10, 20, 20, [ 0, 0, 255 ] )
  screen.updateRect( 0, 0, 0, 0 )
  
end
