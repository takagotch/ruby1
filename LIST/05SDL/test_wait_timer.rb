require 'sdl'
require 'wait_timer'


SDL.init( 0 )

timer = WaitTimer.new( 50 )

timer.reset
for i in 1..1000

  print "st_s #{SDL.getTicks}\n"
  sleep ( rand*0.018 )
  print "st_e #{SDL.getTicks}\n"
  timer.wait do
    print "s\n"
    sleep ( rand*0.005 )
  end
  p timer
end
