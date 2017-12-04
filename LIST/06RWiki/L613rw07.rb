require 'erb/erbl'
require 'erb/erbu'

class BTSCellFormat
  include ERbUtil

  def initialize(url)
    @url = url
    @status_fig = {:open => '¡', :done => '¢', :close => '›' }
    @bgcolor = { 
      :open => '#ffaaaa', :done => '#dddddd', :close => '#aaaaaa',
      :over => '#ff4444', nil => '#ffffff' 
    }
    @erb = ERbLight.new(format)
  end

  def to_html(entry)
    link = anchor(entry.name)
    heading = @status_fig[entry.status] + " " + entry.name
    range = make_range(entry)
    owner = entry.owner
    bgcolor = make_bgcolor(entry)
    summary = make_summary(entry)
    @erb.result(binding)
  end
  
  private
  def today
    now = Time.now
    Time.local(now.year, now.month, now.day)
  end

  def make_summary(entry)
    str = entry[:summary].to_s
    if /^\s*(.{0,8})/ =~ str
      $1 + 'c'
    else
      ''
    end
  end

  def make_bgcolor(entry)
    if entry.status == :open && entry.limit && entry.limit < today
      @bgcolor[:over]
    else	
      @bgcolor[entry.status]
    end
  end

  def make_range(entry)
    left = entry.open ? entry.open.strftime("'%y/%m/%d") : ''
    it = entry.done || entry.close
    right = it ? it.strftime("'%y/%m/%d") : ''
    [left, right].join("-")
  end

  def format
    <<EOS
<td bgcolor="<%=bgcolor%>" align="center" width="20%">
<a href="<%=link%>"><%=h heading%></a><br />
<%=range%><br />
w<%=summary%>x<br />
<%=h owner%>
</td>
EOS
  end

  def anchor(name)
    name = name.gsub(/([^ a-zA-Z0-9_.-]+)/n) do
      '%' + $1.unpack('H2' * $1.size).join('%').upcase
    end.tr(' ', '+')
    @url + 'cmd=view;name=' + name
  end
end

if __FILE__ == $0
  require 'rw06'

  DRb.start_service
  $rwiki = DRbObject.new(nil, 'druby://localhost:8470')
  name = ARGV.shift || 'todo-001'

  ## url‚Í©•ª‚ÌŠÂ‹«‚É‡‚í‚¹‚Äİ’è‚·‚é
  url = 'http://localhost/cgi-bin/rw-cgi.rb?'

  format = BTSCellFormat.new(url)
  entry = BTSEntry2.new(name)

  puts format.to_html(entry)
end
