require 'drb/drb'
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
  end
  attr_reader :name, :number

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

== ���
* �S��: ((<user>))
* ���: ((<todo-open>))
* ����: #{Time.now.strftime("%Y-%m-%d")}
* �Y��: #{(Time.now + 7 * 24 * 60 * 60).strftime("%Y-%m-%d")}
* ���{: 
* �I��: 

== �ڍ�
EOS
  end
end

class BTSIndex
  def initialize(prefix='todo-')
    @prefix = prefix
    escaped = Regexp.escape(prefix)
    @reg = Regexp.new("^#{escaped}(\\d\\d\\d)$") ## Regexp����񂾂���� "
    @page = $rwiki.page(@prefix + 'index')
  end
  attr_reader :page

  def find_all_items
    ## �����N����ToDo�̍��ڂ����o�����ڔԍ����ɕ��ׂ�
    link = @page.links.find_all { |name| is_item?(name) }
    ary = []
    link.each do |name| 
      entry = BTSEntry.new(name) 
      ary.push(entry) unless entry.is_empty?
    end
    ary.sort { |a, b| a.number <=> b.number }
  end

  def prepare_index
    entry = find_all_items

    ## �����ɋ�̍��ڂ�ǉ�����
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

class BTSIndexFormat
  def initialize(name='todo-index')
    @name = name
  end

  def to_rd(entry)
    body = "= #{@name}\n\n"
    entry.reverse_each do |e|
      body.concat("* ((<#{e.name}>)) [#{e['���']}] #{e[:summary]}\n")
    end
    body
  end
end

if __FILE__ == $0
  DRb.start_service
  $rwiki = DRbObject.new(nil, 'druby://localhost:8470')

  idx = BTSIndex.new
  format = BTSIndexFormat.new

  ## �����炵���ڎ������
  entry = idx.prepare_index
  
  ## RD�ȕ�����������ăy�[�W���X�V
  idx.page.src = format.to_rd(entry)
end
