module LibXMLJRuby
  module XML
    module XPath
      NODESET = nil
      
      class Object
        include Enumerable
        
        def initialize(expr, document, nslist = nil)
          @expr, @document = expr, document
          @nslist = nslist          
        end
        
        def each(&block)
          set.each(&block)
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
          @set ||= XML::Node::Set.from_java(evaluate_expression)
        end
        
        def [](index)
          set[index]
        end
        
        private
        def xpath_factory
          @xpath_factory ||= XPathFactory.new_instance
        end
        
        def xpath
          @xpath = xpath_factory.newXPath
        end
        
        def namespace_context
          resolver = PrefixResolverDefault.new(document.owner_document)
          ctx = NamespaceContext.new
          ctx.instance_variable_set(:"@resolver", resolver)
          def ctx.getNamespaceURI(prefix)
            @resolver.getNamespaceForPrefix(prefix)
          end
          
          def ctx.getPrefixes(val)
            nil
          end
          
          def ctx.getPrefix(uri)
            nil
          end
          
          ctx
        end
        
        def compiled_expression
          # xpath.namespace_context = namespace_context unless @nslist.empty?
          @compiled_expression ||= xpath.compile(@expr)
        end
        
        def evaluate_expression
          xpath.namespace_context = namespace_context
          @evaluated_expression ||= compiled_expression.evaluate(document, XPathConstants::NODESET)
        end
        
        def document
          @document.respond_to?(:java_obj) ? @document.java_obj : @document
        end
      end
    end
  end
end