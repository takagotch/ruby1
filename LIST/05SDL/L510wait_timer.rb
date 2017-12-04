# wait_timer.rb
require 'sdl'

class WaitTimer

  def initialize(fps)
    @interval = 1.0/fps
  end

  def reset
    @start_time = SDL.getTicks / 1000.0
    @rest = 0.0
  end

  def wait
    
    if @rest > @interval then
      @rest -= @interval
      @start_time = SDL.getTicks / 1000.0
      return
    end
    
    yield
    
    now_time = SDL.getTicks / 1000.0
    wait_time = @interval - ( now_time - @start_time ) - @rest 
    if wait_time > 0
      sleep wait_time
      @rest = 0.0
    else
      @rest = -wait_time
    end
    @start_time = SDL.getTicks / 1000.0
    
  end

end
