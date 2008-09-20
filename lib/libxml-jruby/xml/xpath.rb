module LibXMLJRuby
  module XML
    module XPath
      NODESET = nil
      
      class Object
        def initialize(expr, document)
          @expr, @document = expr, document
          @nodes = []
        end
        
        def length
          @nodes.length
        end
        
        def first
          
        end
        
        def xpath_type
          XML::XPath::NODESET
        end
        
        private
        def xpath_factory
          @xpath_factory ||= XPathFactory.new_instance
        end
        
        def xpath
          @xpath = xpath_factory.newXPath
        end
        
        def compiled_expression
          xpath.compile(@expr)
        end
        
        def evaluate_expression
          compiled_expression.evaluate(document.java_obj)
        end
      end
    end
  end
end