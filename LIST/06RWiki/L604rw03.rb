require 'drb/drb'

DRb.start_service()
rwiki = DRbObject.new(nil, 'druby://localhost:8470')

pg = rwiki.page('TEST')

puts '== links'
pg.links.each do |n|
  puts n
end

puts '== revlinks'
pg.revlinks.each do |n|
  puts n
end
