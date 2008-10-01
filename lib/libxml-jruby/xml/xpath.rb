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
          @xpath ||= xpath_factory.newXPath
        end
        
        def resolver
          PrefixResolverDefault.new(doc_element)
        end
        
        def doc_element
          if document.respond_to?(:getDocumentElement)
            document.getDocumentElement
          elsif document.respond_to?(:getOwnerDocument)
            document.getOwnerDocument
          else
            nil
          end
        end
        
        def namespace_context          
          CustomNamespaceContext.new(resolver)
        end
        
        def evaluate_expression
          xpath.setNamespaceContext(namespace_context)
          xpath.evaluate(@expr, document, XPathConstants::NODESET)
        end
        
        def document
          @document.respond_to?(:java_obj) ? @document.java_obj : @document
        end
        
        class CustomNamespaceContext
          include NamespaceContext
          
          attr_reader :resolver

          def initialize(resolver)
            @resolver = resolver
          end

        	def getNamespaceURI(prefix)
        		resolver.getNamespaceForPrefix(prefix)
        	end

        	def getPrefixes(val)
        		nil
        	end

        	def getPrefix(uri)
            nil
        	end
        end
      end
    end
  end
end