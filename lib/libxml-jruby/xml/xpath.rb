module LibXMLJRuby
  module XML
    module XPath
      NODESET = nil
      
      class Object
        def initialize(expr, document, nslist = nil)
          @expr, @document = expr, document
          @nslist = nslist          
        end
        
        def each(&block)
          set.each(block)
        end
        
        def length
          set.length
        end
        
        def first
          set.first
        end
        
        def xpath_type
          XML::XPath::NODESET
        end
        
        def set
          @set ||= XML::Node::Set.new(evaluate_expression)
        end
        
        private
        def xpath_factory
          @xpath_factory ||= XPathFactory.new_instance
        end
        
        def xpath
          @xpath = xpath_factory.newXPath
        end
        
        def namespace_context
          # FiXME (I need to figure out how to implement this from a string)
        end
        
        def compiled_expression
          # xpath.namespace_context = namespace_context unless @nslist.empty?
          xpath.compile(@expr)
        end
        
        def evaluate_expression
          compiled_expression.evaluate(@document.java_obj, XPathConstants::NODESET)
        end
      end
    end
  end
end