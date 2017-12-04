module BTSLoader
  module_function
  def load(src)
    info = {}
    forward = :h1
    src.each_line do |ln|
      forward = send(forward, ln.chomp, info)
    end
    return info
  end
  
  def h1(line, info)
    case line
    when /^=\s+(\S.*)\s*$/, /^=\s*([^=].*)\s*$/
      info[:title] = $1
      :summary
    else
      :h1
    end
  end

  def summary(line, info)
    case line
    when /^=/
      h2_or_status(line, info)
    when /^\s*(.+)\s*$/
      info[:summary] = $1
      :h2_or_status
    else
      :summary
    end
  end

  def h2_or_status(line, info)
    case line
    when /^==\s*èÛë‘\s*$/
      :property
    else
      :h2_or_status
    end
  end

  def property(line, info)
    case line
    when /^\s*\*\s+(.+?):\s*(.*)\s*$/ 
      info[$1] = $2
      :property
    when /^\s*$/
      :property
    when /^\s*(.+)\s*$/
      info[:description] = line + "\n"
      :description
    else
      :property
    end
  end

  def description(line, info)
    info[:description].concat(line + "\n")
    :description
  end
end

if __FILE__ == $0
  src = File.open(ARGV.shift) {|f| f.read}
  info = BTSLoader.load(src)
  info.each do |k, v|
    p [k, v]
  end
end
