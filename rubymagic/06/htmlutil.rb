#ÉäÉXÉg6.6Å@htmlutil.rb

module HTMLUtil
  def html2txt(html)
    charref = [
      [/&lt;/,   '<'],
      [/&gt;/,   '>'],
      [/&amp;/,  '&'],
      [/&apos;/, '\''],
      [/&quot;/, '"'],
      [/&nbsp;/, ' '],
      [/&#\d+;/, ' ']
    ]
    removalTag = [/<script.*?<\/script.*?>/mi, /<!--.*?-->/m, 
                  /<[^>]*?>/m]                             # (1)

    removalTag.each {|re| html.gsub!(re, '')}              # (2)
    charref.each {|e| html.gsub!(e[0], e[1])}              # (3)

    text = ''
    prevsize = 0
    html.each do |line|
      line.gsub!(/(?:^[ \t]+)|(?:\r)/, '')                 # (4)
      text.concat(line) if line.size > 1 || prevsize > 1   # (5)
      prevsize = line.size
    end

    return text
  end
end
