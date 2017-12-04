# testsprite_with_sound.rb
require 'sdl'

SDL.init( SDL::INIT_VIDEO ) # (1)
SDL::Mixer.open( SDL::Mixer::DEFAULT_FREQUENCY, SDL::Mixer::DEFAULT_FORMAT,
		SDL::Mixer::DEFAULT_CHANNELS, 1024 ) # (2)

$sound = SDL::Mixer::Wave.load 'sample.wav' # (3)
screen = SDL::setVideoMode(640,480,16,SDL::SWSURFACE)

image = SDL::Surface.loadBMP("icon.bmp")
image.setColorKey( SDL::SRCCOLORKEY ,0)
$image = image.displayFormat

BLACK = [ 0, 0, 0 ]

def plus_minus
  return ( rand(2)==0 )? 1 : -1
end

class Icon  
  def initialize
    @x = rand( 640 ) ; @y = rand( 480 )
    @dx = plus_minus * ( rand(5)+2 )
    @dy = plus_minus * ( rand(5)+2 )
  end

  def move
    is_reflect = false
    @x += @dx; @y += @dy
    if @x < 0 or @x > 640 then
      @dx *= -1
      is_reflect = true
    end
    if @y < 0 or @y > 480 then
      @dy *= -1
      is_reflect = true
    end

    if is_reflect then
      SDL::Mixer.playChannel( 0, $sound, 1 ) # (4)
    end
  end

  def draw(screen)
    SDL.blitSurface $image, 0, 0, 0, 0, screen, @x, @y
  end
end

icons = []
for i in 1..5
  icons << Icon.new
end

loop do
  while event = SDL::Event2.poll 
    case event
    when SDL::Event2::Quit, SDL::Event2::KeyDown
      exit
    end
  end

  screen.fillRect 0, 0, 640, 480, BLACK
  icons.each do |icon|
    icon.move    
    icon.draw( screen )
  end

  screen.updateRect 0, 0, 0, 0
end
