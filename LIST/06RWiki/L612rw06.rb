require 'drb/drb'
require 'bts-index'

class BTSEntry2 < BTSEntry
  def initialize(name)
    super(name)
    visit_property
  end
  attr_reader :open, :limit, :done, :close, :status, :owner

  private
  def visit_property
    @status = visit_status(@hash['ó‘Ô'])
    @open = visit_time(@hash['”­¶'])
    @limit = visit_time(@hash['YØ'])
    @done = visit_time(@hash['ŽÀŽ{'])
    @close = visit_time(@hash['I—¹'])
    @owner = visit_owner(@hash['’S“–'])
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

if __FILE__ == $0
  DRb.start_service
  $rwiki = DRbObject.new(nil, 'druby://localhost:8470')
  name = ARGV.shift || 'todo-001'
  entry = BTSEntry2.new(name)
  p entry
end
