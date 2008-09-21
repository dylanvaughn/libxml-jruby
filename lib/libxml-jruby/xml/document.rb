module LibXMLJRuby
  module XML
    class Document
      class << self
        def file(filename)
          XML::Parser.file(filename).parse
        end
      end
      
      attr_accessor :java_obj

      def initialize(xml_version = 1.0)
        @xml_version = xml_version
      end
      
      def find(expr, nslist = nil)
        XML::XPath::Object.new(expr, self, nslist)
      end
      
      def find_first(expr, nslist = nil)
        XML::XPath::Object.new(expr, self, nslist).first
      end
    end    
  end
end
