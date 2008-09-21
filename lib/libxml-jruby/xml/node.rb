module LibXMLJRuby
  module XML
    class Node
      attr_accessor :java_obj
      attr_accessor :name, :content
      
      def initialize(name, content = nil)
        @name, @content = name, content
      end
            
      def <<(node)
        
      end
      
      def find_first(expr)
        raise TypeError if java_obj.nil?
        XPath::Object.new(expr, java_obj).first
      end
      
      class Set
        include Enumerable
        
        attr_reader :java_obj
        
        def initialize(java_obj)
          @java_obj = java_obj
        end
        
        def length
          java_obj.length
        end
        
        def each
          i = 0
          while(i < java_obj.length)
            java_node = java_obj.item(i)
            yield XML::Node.new(java_node.node_name, java_node.node_value)
            i += 1
          end
        end
      end
    end
  end
end