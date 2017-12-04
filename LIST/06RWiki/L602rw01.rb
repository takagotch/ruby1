require 'drb/drb'

DRb.start_service()
rwiki = DRbObject.new(nil, 'druby://localhost:8470')

pg = rwiki.page('top')
puts pg.src
