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
      p
    end
    
    def string(string)
      p = new
      p.string = string
      p
    end
    
    def io(io)
      p = new
      p.io = io
      p
    end
  end
  
  def initialize
    @source_type = nil
    @parsed = false
  end
  
  attr_reader :string, :filename, :io
  
  def string=(string = nil)
    raise TypeError if string.nil?
    @parsed = false
    @source_type = String
    @string = string
  end
  
  def filename=(filename)
    @source_type = File
    @filename = filename
  end

  def io=(io)
    raise TypeError if StringIO === io
    @io = io
    self.string = @io.read
  end
  
  def parse
    raise ParseError, "You cannot parse twice" if @parsed
    raise ParseError, "No input specified, please specify an input" unless @source_type
    doc = send("parse_#{@source_type.to_s.downcase}")
    @parsed = true
    doc
  end
  
  def document_builder_factory
    @dbf ||= DocumentBuilderFactory.new_instance
  end
  
  def document_builder
    # document_builder_factory.namespace_aware = true
    document_builder_factory.new_document_builder
  end
  
  def string_reader
    StringReader.new(@string)
  end
  
  def input_source
    InputSource.new(string_reader)
  end
  
  def parse_string
    raise ParseError if @string.empty?
    builder = document_builder
    
    begin
      jdoc = builder.parse(input_source)
    rescue NativeException
      raise ParseError
    end

    XML::Document.from_java(jdoc)
  end
  
  def parse_file
    builder = document_builder
    
    begin
      jdoc = builder.parse(@filename)
    rescue
      raise ParseError
    end
    
    XML::Document.from_java(jdoc)
  end
  
  def parse_io
    parse_string
  end
end
