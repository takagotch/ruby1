require 'drb/drb'

DRb.start_service()
rwiki = DRbObject.new(nil, 'druby://localhost:8470')

add = <<EOS

== Test 

* ((<todo-index>))
EOS

todo_index = <<EOS
= ToDo-index

* ((<top>))
EOS


pg = rwiki.page('top')
pg.src = pg.src + add

pg = rwiki.page('todo-index')
pg.src = todo_index
