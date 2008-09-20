class LibXMLJRuby::XML::Parser
  class ParseError < RuntimeError; end

  VERNUM = 0
  VERSION = '0'
  
  @default_tree_indent_string = '  '
  @check_lib_versions = ''
  @features = []
  
  class << self        
    attr_accessor :debug_entities, :default_compression, 
                  :default_keep_blanks, :default_line_numbers,
                  :default_substitute_entities, 
                  :default_tree_indent_string,
                  :default_validity_checking, :default_warnings,
                  :features, :indent_tree_output,
                  :check_lib_versions
    
    def register_error_handler(handler = nil, &block)
      
    end

    def file(filename)
      p = new
      p.filename = filename
      p.parse
    end
    
    def string(string)
      p = new
      p.string = string
      p.parse
    end
    
    def io(io)
      p = new
      p.io = io
      p.parse
    end
  end
  
  def initialize
    @source_type = nil
    @parsed = false
  end
  
  attr_reader :string, :filename, :io
  
  def string=(string = nil)
    raise TypeError if string.nil?
    @source_type = String
    @string = string
  end
  
  def filename=(filename)
    @source_type = File
    @filename = filename
  end

  def io=(io)
    raise TypeError if StringIO === io
    @source_type = IO
    @io = io
  end
  
  def parse
    raise ParseError, "You cannot parse twice" if @parsed
    raise ParseError, "No input specified, please specify an input" unless @source_type
    doc = send("parse_#{@source_type.to_s.downcase}")
    @parsed = true
    doc
  end
  
  private
  def parse_string
    raise ParseError if @string.empty?
  end
  
  def parse_file
    factory = DocumentBuilderFactory.new_instance
    builder = factory.new_document_builder
    
    begin
      jdoc = builder.parse(@filename)
    rescue
      raise ParseError
    end
    
    doc = LibXMLJRuby::XML::Document.new
    doc.java_obj = jdoc
    doc
  end
  
  def parse_io
    
  end
end
