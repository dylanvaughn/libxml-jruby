module LibXMLJRuby
  module XML
    class Document
      class << self
        def file(filename)
          XML::Parser.file(filename)
        end
      end
      
      attr_accessor :java_obj

      def initialize(xml_version = 1.0)
        @xml_version = xml_version
      end
    end    
  end
end
