#!/usr/bin/env ruby

require "rexml/document"
require "uconv"

class Rxsh
  class Error < StandardError
  end
  
  NAME = /^[\w:][\w\d.:-]*$/u
  NCNAME = /^[\w][\w\d.-]*$/u

  ENCODING = %w(euc sjis)

  SUCCESS_MSG = "Success"

  def initialize(encoding=nil)
    set_enc(encoding)
    @current = nil
    @xmldoc = nil
    methods.each do |method|
      if method =~ /_usage$/
        type.send("private", method.intern)
      end
    end
  end
  private :initialize

  def set_enc(enc)
    @encoding = ENCODING.include?(enc) ? enc : nil
  end
  def set_enc_usage
    { "args" => "encoding",
      "comment" => "set encoding."}
  end

  def enc
    @encoding
  end
  def enc_usage
    { "args" => "",
      "comment" => "return encoding."}
  end

  def start
    print "rxsh> "
    $stdin.each do |input|
      input.strip!
      break if input =~ /^exit$/
      puts(from_u8(eval_input(input))) unless input.empty?
      write
      print "rxsh> "
    end
    puts 
  end

  def write(indent=0)
    if @xmldoc
      File.open(@xmldoc, "w") do |file|
        @current.document.write(file, indent.to_i)
      end
    end
    SUCCESS_MSG
  end
  def write_usage
    { "args" => "[indent=0]",
      "comment" => "write xml to file."}
  end

  def pwd
    Dir.pwd
  end
  def pwd_usage
    { "args" => "",
      "comment" => "print working directory."}
  end

  def pwn
    in_xmldoc?
    to_xpath(@current)
  end
  def pwn_usage
    { "args" => "",
      "comment" => "print working node."}
  end

  def pwx
    in_xmldoc?
    @xmldoc
  end
  def pwx_usage
    { "args" => "",
      "comment" => "print working XML document."}
  end

  def mkxml(filename, root_element,
            version=nil, encoding=nil, standalone=nil)
    valid_name?(root_element)
    begin
      File.open(filename, "w") do |file|
        doc = REXML::Document.new()
        doc << REXML::XMLDecl.new(version, encoding, standalone)
        doc << REXML::Element.new(root_element)
        doc.write(file, 0)
      end
      SUCCESS_MSG
    rescue
      raise Rxsh::Error, $!.message
    end
  end
  def mkxml_usage
    { "args" => "filename root_element " +
      "[version=nil [encoding=nil [standalone=nil]]]",
      "comment" => "make XML document."}
  end

  def cd(path=".")
    begin
      Dir.chdir(path)
      pwd
    rescue
      raise Rxsh::Error, $!.message
    end
  end
  def cd_usage
    { "args" => "[path=.]",
      "comment" => "change directory."}
  end

  def cn(xpath="/")
    in_xmldoc?
    @current = valid_xpath_to_element?(xpath)
    pwn
  end
  def cn_usage
    { "args" => "[xpath=/]",
      "comment" => "change node."}
  end

  def cx(xmldoc)
    begin
      File.open(xmldoc, "r") do |file|
        @current = REXML::Document.new(file, {:compress_whitespace => :all})
      end
    rescue REXML::ParseException
      raise Rxsh::Error, "Bad XML document: '#{xmldoc}'."
    rescue
      raise Rxsh::Error, $!.message
    end
    @xmldoc = File.expand_path(xmldoc)
  end
  def cx_usage
    { "args" => "xmldoc",
      "comment" => "change XML document."}
  end

  def find(xpath=".", name=nil)
    msg = ""
    search(xpath, name) do |node|
      msg << "#{to_xpath(node)}\n"
    end
    msg
  end
  def find_usage
    { "args" => "[xpath=. [name=nil]]",
      "comment" => "search node. " +
      "search by attribute if name starts with '@'."}
  end

  def ln(xpath="*")
    msg = ""
    each_element_info(xpath) do |elem, info|
      msg << "#{elem}\n"
      info.each do |key, value|
        msg << "\t#{key}\n"
        msg << "\t#{value}\n"
      end
    end
    msg
  end
  def ln_usage
    { "args" => "[xpath=*]",
      "comment" => "list nodes."}
  end

  def lp
    in_xmldoc?
    msg = "Target\tContent\n"
    REXML::XPath.each(@current, "/child::processing-instruction()") do |pi|
      msg << "#{pi.target}\t#{pi.content}\n"
    end
    msg
  end
  def lp_usage
    { "args" => "",
      "comment" => "list PIs."}
  end

  def lx(path=".")
    begin
      list = []
      Dir.foreach(path) do |filename|
        if filename =~ /\.x[^.]+$/ or (dir = File.directory?(filename))
          filename << "*" if dir
          list << filename
        end
      end
      list.sort.join("\n")
    rescue
      raise Rxsh::Error, $!.message
    end
  end
  def lx_usage
    { "args" => "[path=.]",
      "comment" => "list XML documents."}
  end

  def aa(xpath, name, value)
    in_xmldoc?
    valid_name?(name)
    elem = valid_xpath_to_element?(xpath)
    elem.add_attribute(name, value)
    SUCCESS_MSG
  end
  def aa_usage
    { "args" => "path_to_element attr_name attr_value",
      "comment" => "add attribute."}
  end

  def acd(xpath, content, whitespace=nil)
    in_xmldoc?
    elem = valid_xpath_to_element?(xpath)
    REXML::CData.new(content, whitespace, elem)
    content
  end
  def acd_usage
    { "args" => "path_to_element content [whitespace=nil]",
      "comment" => "add CDATA section."}
  end

  def aco(xpath, content)
    in_xmldoc?
    elem = valid_xpath_to_element?(xpath)
    REXML::Comment.new(content, elem)
  end
  def aco_usage
    { "args" => "path_to_element content",
      "comment" => "add comment."}
  end

  def ae(name)
    in_xmldoc?
    in_root_node?
    valid_name?(name)
    @current.add_element(name)
    SUCCESS_MSG
  end
  def ae_usage
    { "args" => "element_name",
      "comment" => "add element."}
  end

  def an(xpath, prefix, uri=nil)
    in_xmldoc?
    elem = valid_xpath_to_element?(xpath)
    valid_name?(prefix, NCNAME) unless uri.nil?
    elem.add_namespace(prefix, uri)
    SUCCESS_MSG
  end
  def an_usage
    { "args" => "path_to_element prefix [uri=nil]",
      "comment" => "add namespace. " +
      "prefix is set uri as default namespace if uri equals nil."}
  end

  def ap(target, *content)
    in_xmldoc?
    doc = @current.document
    content = content.join(" ") 
    doc.insert_before(doc.root, REXML::Instruction.new(target, content))
    SUCCESS_MSG
  end
  def ap_usage
    { "args" => "target [content='']",
      "comment" => "add PI."}
  end

  def at(xpath, content)
    in_xmldoc?
    elem = valid_xpath_to_element?(xpath)
    elem.add_text(content)
    SUCCESS_MSG
  end
  def at_usage
    { "args" => "path_to_element content",
      "comment" => "add text."}
  end

  def da(xpath, name)
    in_xmldoc?
    elem = valid_xpath_to_element?(xpath)
    elem.delete_attribute(name)
    SUCCESS_MSG
  end
  def da_usage
    { "args" => "xpath_to_element delete_attr_name",
      "comment" => "delete attribute."}
  end

  def dcd(xpath)
    delete_node(xpath, REXML::CData)
  end
  def dcd_usage
    { "args" => "xpath_to_element",
      "comment" => "delete CDATAs."}
  end

  def dco(xpath)
    delete_node(xpath, REXML::Comment)
  end
  def dco_usage
    { "args" => "xpath_to_element",
      "comment" => "delete comments."}
  end

  def de(name)
    in_xmldoc?
    in_root_node?
    name = name.to_i if name =~ /^\d+$/u
    @current.delete_element(name)
    SUCCESS_MSG
  end
  def de_usage
    { "args" => "delete_element_name",
      "comment" => "delete element by name or index."}
  end

  def dn(xpath, namespace="xmlns")
    in_xmldoc?
    elem = valid_xpath_to_element?(xpath)
    elem.delete_namespace(namespace)
    SUCCESS_MSG
  end
  def dn_usage
    { "args" => "xpath_to_element [delete_namespace=xmlns]",
      "comment" => "delete namespace."}
  end

  def dp(target)
    in_xmldoc?
    @current.document.delete_if do |node|
      node.instance_of? REXML::Instruction and node.target == target
    end
    SUCCESS_MSG
  end
  def dp_usage
    { "args" => "delete_target",
      "comment" => "delete PI."}
  end

  def dt(xpath)
    delete_node(xpath, REXML::Text)
  end
  def dt_usage
    { "args" => "xpath_to_element",
      "comment" => "delete texts."}
  end

  def me(from_xpath, to_xpath, force=false)
    ce(from_xpath, to_xpath, force)
    @current.elements.delete(from_xpath)
    SUCCESS_MSG
  end
  def me_usage
    { "args" => "xpath_to__from_element__ " + 
      "xpath_to__to_element__ [force=false]",
      "comment" => "move element by name or index."}
  end

  def ce(from_xpath, to_xpath, force=false)
    in_xmldoc?
    from_element = valid_xpath_to_element?(from_xpath)
    to_xpath = to_xpath.to_i if to_xpath =~ /^\d+$/u
    to_element = from_element.deep_clone
    to_xpath =~ /([^\/]*)\/?$/u
    to_element.name = $1
    valid_name?(to_element.expanded_name)
    make_elems(to_xpath) if force
    @current.elements[to_xpath] = to_element
    SUCCESS_MSG
  end
  def ce_usage
    { "args" => "xpath_to__from_element__ " +
      "xpath_to__to_element__, [force=false]",
      "comment" => "copy element by name or index."}
  end

  def help
    usage(true)
  end
  def help_usage
    { "args" => "",
      "comment" => "print verbose usage."}
  end
  def exit_usage
    { "args" => "",
      "comment" => "exit rxsh."}
  end

  private
  def eval_input(input)
    begin
      input = input.split(/\s+/)
      if input[0][0] == ?!
        input = input.join(" ")
        input.slice!(0)
        to_u8(`#{input}`)
      elsif type.public_instance_methods.include? input[0]
        input[1..-1] = input[1..-1].collect {|x| to_u8(x)}
        send(input[0], *input[1..-1])
      else
        raise
      end
    rescue Rxsh::Error
      to_u8($!.message)
    rescue
      to_u8("#{$!.message}\n#{usage}")
    end
  end

  def usage(verbose=false)
    msg = "USAGE"
    type.private_instance_methods.sort.each do |method|
      unless (method =~ /(.+)_usage$/).nil?
        info = send(method)
        unless info.nil?
          msg << format("\t%6s %s\n", $1 ,info["args"])
          msg << "\t\tComment: #{info['comment']}\n" if verbose
        end
      end
    end
    msg
  end

  def in_xmldoc?
    raise Rxsh::Error, "You are not in XML document." if @current.nil?
  end

  def in_root_node?
    if @current.kind_of? REXML::Document
      raise Rxsh::Error, "Can't do under root node." 
    end
  end

  def valid_xpath_to_element?(xpath)
    xpath = xpath.to_i if xpath =~ /^\d+$/u
    if (elem = @current.elements[xpath]).nil?
      raise Rxsh::Error, "Bad XPath to element: '#{xpath}'."
    end
    elem
  end

  def valid_name?(name, pattern=NAME)
    if pattern.match(name).nil?
      raise Rxsh::Error, "Bad name: '#{name}'."
    end
  end

  def to_u8(string)
    unless @encoding.nil?
      Uconv.send("#{@encoding}tou8", string)
    else
      string
    end
  end

  def from_u8(string)
    unless @encoding.nil?
      Uconv.send("u8to#{@encoding}", string)
    else
      string
    end
  end

  def to_xpath(element)
    if element.nil?
      ""
    elsif element.instance_of? REXML::Document
      "/"
    else
      parent_xpath = to_xpath(element.parent)
      parent_xpath = "" if parent_xpath == "/"
      "#{parent_xpath}/#{element.expanded_name}"
    end
  end

  def delete_node(xpath, node_type)
    in_xmldoc?
    elem = valid_xpath_to_element?(xpath)
    elem.delete_if do |node|
      node.instance_of? node_type
    end
    SUCCESS_MSG
  end

  def each_element_info(xpath)
    in_xmldoc?
    @current.each_element(xpath) do |elem|
      unless elem.kind_of? REXML::Document
        yield elem_info(elem), extra_elem_info(elem)
      end
    end
  end
  
  def elem_info(elem)
    elem.parent.elements.index(elem).to_s + "  " +
      elem.fully_expanded_name + "  " +
      elem.elements.size.to_s
  end
  
  def extra_elem_info(elem)
    attrs = ""
    text = ""
    comment = ""
    cdata = ""
    elem.attributes.each do |name, value|
      attrs << "  #{name} => #{value}"
    end
    REXML::XPath.each(elem, "./child::node()") do |node|
      value = node.to_s.strip
      unless value.empty?
        case node
        when REXML::CData
          cdata
        when REXML::Text
          text
        when REXML::Comment
          comment
        else
          ""
        end << "  '#{value}'"
      end
    end
    { "Attributes and Namespace declarations" => attrs,
      "Texts" => text,
      "Comments" => comment,
      "CDATA sections" => cdata }
  end
  
  def search(xpath, name, &block)
    in_xmldoc?
    node_type = (name[0] == ?@ ? "attribute" : "element") unless name.nil?
    query = "#{xpath}//*" + case node_type
                            when "attribute"
                              "[#{name}]"
                            when "element"
                              "[name()='#{name}']"
                            else
                              ""
                            end
    REXML::XPath.each(@current, query, &block)
  end

  def make_elems(xpath, elem=nil)
    begin
      if @current.elements[xpath].nil?
        if xpath =~ /^(.*)\/([^\/]*)\/?/u
          make_elems($1, make_parent($2, elem))
        else
          @current << make_parent(xpath, elem)
        end
      else
        @current.elements[xpath] << elem unless elem.nil?
      end
    rescue Exception
      raise Rxsh::Error, $!.message
    end      
  end
  
  def make_parent(name, child)
    parent = REXML::Element.new(name)
    parent << child unless child.nil?
    parent
  end

end

if $0 == __FILE__
  Rxsh.new(ARGV[0]).start
end
