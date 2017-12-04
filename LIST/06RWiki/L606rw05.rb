require 'drb/drb'

DRb.start_service()
rwiki = DRbObject.new(nil, 'druby://localhost:8470')

pg = rwiki.page('top')

puts '== revlinks 1'
pg.revlinks.each do |n|
  puts n
end

revlinks = pg.revlinks
revlinks[0..-1] = nil  ## revlinks‚ð‹ó‚É‚µ‚Ä
revlinks.push('dirty') ## 'dirty' ‚ð’Ç‰Á‚·‚é

puts '== change'
p revlinks

puts '== revlinks 2'
pg.revlinks.each do |n|
  puts n
end
