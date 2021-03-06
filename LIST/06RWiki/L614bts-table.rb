require 'drb/drb'
require 'erb/erbl'
require 'erb/erbu'
require 'bts-load'

class BTSEntry
  def initialize(name)
    @name = name
    @number = if /(\d\d\d)/ =~ name
                $1.to_i
              else
                nil
              end

    page = $rwiki.page(name)
    src = page.src
    if src.nil? || src == ''
      src = new_page(name)
      page.src = src
    end
    @hash = BTSLoader.load(src)
    visit_property
  end
  attr_reader :name, :number
  attr_reader :open, :limit, :done, :close, :status, :owner

  def [](key)
    @hash[key]
  end

  def is_empty?
    summary = @hash[:summary]
    summary.nil? || summary == ''
  end

  def new_page(name)
    src = <<EOS
= #{name}

== 状態
* 担当: ((<user>))
* 状態: ((<todo-open>))
* 発生: #{Time.now.strftime("%Y-%m-%d")}
* 〆切: #{(Time.now + 7 * 24 * 60 * 60).strftime("%Y-%m-%d")}
* 実施: 
* 終了: 

== 詳細
EOS
  end

  private
  def visit_property
    @status = visit_status(@hash['状態'])
    @open = visit_time(@hash['発生'])
    @limit = visit_time(@hash['〆切'])
    @done = visit_time(@hash['実施'])
    @close = visit_time(@hash['終了'])
    @owner = visit_owner(@hash['担当'])
  end

  def visit_status(value)
    case value
    when /open/
      :open
    when /done/
      :done
    when /close/
      :close
    else
      nil
    end
  end

  def visit_time(value)
    if /(\d+)-(\d+)-(\d+)/ =~ value
      Time.local($1.to_i, $2.to_i, $3.to_i) rescue nil
    else
      nil
    end
  end

  def visit_owner(value)
    if /\(\(\<(.+)\>\)\)/ =~ value
      $1
    else
      value
    end
  end
end

class BTSIndex
  def initialize(prefix='todo-')
    @prefix = prefix
    escaped = Regexp.escape(prefix)
    @reg = Regexp.new("^#{escaped}(\\d\\d\\d)$") ## Regexpを一回だけ作る "
    @index_page = $rwiki.page(@prefix + 'index')
  end

  def find_all_items
    ## リンクからToDoの項目を取り出し項目番号順に並べる
    link = @index_page.links.find_all { |name| is_item?(name) }
    ary = []
    link.each do |name| 
      entry = BTSEntry.new(name) 
      ary.push(entry) unless entry.is_empty?
    end
    ary.sort { |a, b| a.number <=> b.number }
  end

  def prepare_index
    entry = find_all_items

    ## 末尾に空の項目を追加する
    tail = entry[-1]
    name  = i_to_name(tail ? tail.number+1 : 1)
    entry.push(BTSEntry.new(name))
  end

  private
  def i_to_name(num)
    name = sprintf("%s%03d", @prefix, num)
  end

  def item_number(nm)
    if @reg =~ nm
      $1.to_i
    else
      nil
    end
  end

  def is_item?(nm)
    (item_number(nm)) ? true : false
  end
end

class BTSCellFormat
  include ERbUtil

  def initialize(url, width=20)
    @url = url
    @status_fig = {:open => '■', :done => '△', :close => '○' }
    @bgcolor = { 
      :open => '#ffaaaa', :done => '#dddddd', :close => '#aaaaaa',
      :over => '#ff4444', nil => '#ffffff' 
    }
    @cell_width = width
    @erb = ERbLight.new(format)
  end

  def to_html(entry)
    return '<td>&nbsp;</td>' if entry.nil?

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
      $1 + '…'
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
<td bgcolor="<%=bgcolor%>" align="center" width="<%=@cell_width%>%">
<a href="<%=link%>"><%=h heading%></a><br />
<%=range%><br />
『<%=summary%>』<br />
<%=h owner%>
</td>
EOS
  end

  def anchor(name)
    name = name.gsub(/([^ a-zA-Z0-9_.-]+)/n) do
      '%' + $1.unpack('H2' * $1.size).join('%').upcase
    end.tr(' ', '+')
    @url + '?cmd=view;name=' + name
  end
end

class BTSTableFormat
  def initialize(cell_format_factory, url, width=5)
    @width = width
    @cell_format = cell_format_factory.new(url, 100/@width)
    @erb = ERbLight.new(format)
  end

  def to_html(entry)
    @erb.result(binding)
  end

  def format
    <<EOS
<table><%
  lines = entry.size / @width
  lines.downto(0) do |y|
    %><tr><%
    line = entry[y * @width, @width]
    @width.times do |x|
      %><%=@cell_format.to_html(line[x])%><%
    end
    %></tr><%
  end
%></table>
EOS
  end
end

if __FILE__ == $0
  DRb.start_service
  $rwiki = DRbObject.new(nil, 'druby://localhost:8470')

  ## urlは自分の環境に合わせて設定する
  url = 'http://localhost/cgi-bin/rw-cgi.rb'

  index = BTSIndex.new
  format = BTSTableFormat.new(BTSCellFormat, url)
  ary = index.find_all_items
  puts format.to_html(ary)
end
