module LibXMLJRuby
  module XML
    class Dtd
      def initialize(schema)
        @schema = schema
      end
      
      def validate(doc)
        validator.validate(doc)
      end
      
      def schema_factory
        SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema")
      end
      
      def schema
        schema = schema_factory.newSchema(StreamSource.new(ByteArrayInputStream.new(@schema.to_java_bytes)))        
      end
      
      def validator
        schema.newValidator
      end
    end
  end
end