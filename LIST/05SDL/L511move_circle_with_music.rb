# move_circle_with_music.rb
require 'sdl'
include Math

SDL.init( SDL::INIT_VIDEO|SDL::INIT_AUDIO ) # (1)
SDL::Mixer.open  # (2)
music = SDL::Mixer::Music.load( 'sample.mod' ) # (3)

screen = SDL.setVideoMode( 640, 480, 16, SDL::SWSURFACE )

R = 100
angle = 0.0

SDL::Mixer.playMusic( music, -1 ) # (4)
loop do

  while event = SDL::Event2.poll
    case event 
    when SDL::Event2::Quit
      exit
    when SDL::Event2::KeyDown
      case event.sym
      when SDL::Key::ESCAPE
	exit
      when SDL::Key::SPACE
	if SDL::Mixer.pauseMusic? then # (5)
	  SDL::Mixer.resumeMusic
	else
	  SDL::Mixer.pauseMusic
	end
      end    
    end
  end

  angle += PI/100.0
  screen.fillRect( 0, 0, 640, 480, [ 0, 0, 0 ] ) 
  screen.drawCircle( 320+R*cos(angle), 240+R*sin(angle), 20, [ 0, 255, 0 ] )
  screen.updateRect( 0, 0, 0, 0 ) 
end
