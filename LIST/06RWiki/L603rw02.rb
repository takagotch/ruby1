require 'drb/drb'

DRb.start_service()
rwiki = DRbObject.new(nil, 'druby://localhost:8470')

add = <<EOS

== Test 

今は#{Time.now.strftime("%H:%M")}だよ。

* ((<todo-index>))

EOS

pg = rwiki.page('top')
pg.src = pg.src + add
