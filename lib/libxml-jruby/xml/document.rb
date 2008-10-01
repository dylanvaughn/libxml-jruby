module LibXMLJRuby
  module XML
    class Document
      class << self
        def file(filename)
          XML::Parser.file(filename).parse
        end
        
        def from_java(java_obj)
          d = new
          d.java_obj = java_obj
          d
        end
      end
      
      attr_accessor :java_obj # org.w3c.dom.Document

      def initialize(xml_version = 1.0)
        @xml_version = xml_version
        @xpath_cache = {}
      end
      
      def validate(dtd)
        dtd.validate(self)
      end
      
      def find(expr, nslist = nil)
        @xpath_cache[[expr, nslist]] ||= XML::XPath::Object.new(expr, self, nslist)
      end
      
      def find_first(expr, nslist = nil)
        find(expr, nslist).first
      end
      
      def child?
        java_obj.hasChildNodes
      end
      
      def parent?
        !!java_obj.parent_node
      end
      
      def root
        @root ||= Node.from_java(java_obj.document_element)
      end
    end    
  end
end
