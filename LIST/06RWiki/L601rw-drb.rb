require 'drb/drb'
require 'rw-lib'

if __FILE__ == $0
  DRb.start_service()
  rwiki = DRbObject.new(nil, 'druby://localhost:8470')

  it = ARGV.shift || 'druby'

  p rwiki.find(it)
  rwiki.find_all(it) do |pg|
    p pg.name
  end

  p rwiki.include?(it)
end
