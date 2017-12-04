# init.rb
require 'sdl'

SDL.init( SDL::INIT_AUDIO )
SDL::Mixer.open

while line = gets do
  case line    
  when /load\s+(\w+)/
    begin
      music = SDL::Mixer::Music.load( $1 )
    rescue
      print $!, "\n"
    end
  when /p(lay)?/
    begin
      SDL::Mixer.playMusic( music )
    rescue
      print "Music file are not read yet\n"
    end
  when /pa(use)?/
    SDL::Mixer.pauseMusic
  when /ha(lt)?/
    SDL::Mixer.haltMusic
  when /resume/
    SDL::Mixer.resumeMusic
  when /rewind/
    SDL::Mixer.rewindMusic
  when /q(uit)?/
    exit 
  when /h(elp)?/
    print "usage:\n"
    print "\n"
    print "load <filename>\n"
    print "play\n"
    print "pause\n"
    print "resume\n"
    print "rewind\n"
    print "halt\n"
    print "help\n"
    print "quit\n"
  else
    print "invalid command\n"
  end
  
end

