require 'drb/drb'

DRb.start_service()
rwiki = DRbObject.new(nil, 'druby://localhost:8470')

add = <<EOS

== Test 

¡‚Í#{Time.now.strftime("%H:%M")}‚¾‚æB

* ((<todo-index>))

EOS

pg = rwiki.page('top')
pg.src = pg.src + add
