module LibXMLJRuby
  module XML
    class Node
      ATTRIBUTE_NODE = org.w3c.dom.Node.ATTRIBUTE_NODE
      CDATA_SECTION_NODE = org.w3c.dom.Node.CDATA_SECTION_NODE
      COMMENT_NODE = org.w3c.dom.Node.COMMENT_NODE
      DOCUMENT_FRAG_NODE = org.w3c.dom.Node.DOCUMENT_FRAGMENT_NODE
      DOCUMENT_NODE = org.w3c.dom.Node.DOCUMENT_NODE
      DOCUMENT_TYPE_NODE = org.w3c.dom.Node.DOCUMENT_TYPE_NODE
      ELEMENT_NODE = org.w3c.dom.Node.ELEMENT_NODE      
      ENTITY_NODE = org.w3c.dom.Node.ENTITY_NODE
      ENTITY_REFERENCE_NODE = org.w3c.dom.Node.ENTITY_REFERENCE_NODE
      NOTATION_NODE = org.w3c.dom.Node.NOTATION_NODE
      PROCESSING_INSTRUCTION_NODE = org.w3c.dom.Node.PROCESSING_INSTRUCTION_NODE
      TEXT_NODE = org.w3c.dom.Node.TEXT_NODE
      
      class << self
        def from_java(java_obj)
          return nil if java_obj.nil?
          n = allocate
          n.java_obj = java_obj
          n
        end
      end
      
      include Enumerable
      
      attr_accessor :java_obj # org.w3c.dom.Element(Node?)
      
      def initialize(name, content = nil)
        jdoc = DocumentBuilderFactory.new_instance.new_document_builder.new_document
        self.java_obj = jdoc.createElement(name)
        self.content = content
      end

      def name
        java_obj.node_name ||= @name
      end
      
      def content
        java_obj.text_content ||= @content
      end
      
      def name=(name)
        @name = name
        java_obj.node_name = @name if @name
      end

      def content=(content)
        @content = content
        java_obj.node_value = @value if @value
      end
      
      def child_add(node)
        java_obj.getOwnerDocument.adoptNode(node.java_obj)
        java_obj.appendChild(node.java_obj) # should this be importNode?
      end
      
      def copy(deep = false)
        XML::Node.from_java(java_obj.cloneNode(deep))
      end
      
      def <<(node)
        
      end
      
      def each(&block)
        children.each(&block)
      end
      
      def each_element
        if block_given?
          each do |node|
            yield(node) if node.node_type == ELEMENT_NODE
          end
        else
          select do |node|
            node.node_type == org.w3c.dom.Node.ELEMENT_NODE
          end
        end
      end
      
      def find(expr)
        XML::XPath::Object.new(expr, java_obj)
      end
      
      def find_first(expr)
        raise TypeError if java_obj.nil?
        find(expr).first
      end
      
      def node_type
        java_obj.node_type
      end
      
      def node_type_name
        case node_type
          # Most common choices first
          when ATTRIBUTE_NODE
            'attribute'
          when DOCUMENT_NODE
            'document_xml'
          when ELEMENT_NODE
            'element'
          when TEXT_NODE
            'text'
          
          # Now the rest  
          when ATTRIBUTE_DECL
            'attribute_decl'
          when CDATA_SECTION_NODE
            'cdata'
          when COMMENT_NODE
            'comment'
          when DOCB_DOCUMENT_NODE
            'document_docbook'
          when DOCUMENT_FRAG_NODE
            'fragment'
          when DOCUMENT_TYPE_NODE
            'doctype'
          when DTD_NODE
            'dtd'
          when ELEMENT_DECL
            'elem_decl'
          when ENTITY_DECL
            'entity_decl'
          when ENTITY_NODE
            'entity'
          when ENTITY_REF_NODE
            'entity_ref'
          when HTML_DOCUMENT_NODE
            'document_html'
          when NAMESPACE_DECL
            'namespace'
          when NOTATION_NODE
            'notation'
          when PI_NODE
            'pi'
          when XINCLUDE_START
            'xinclude_start'
          when XINCLUDE_END
            'xinclude_end'
          else
            raise(UnknownType, "Unknown node type: %n", node.node_type);
        end          
      end
      
      def first
        child
      end
      
      def children
        @children ||= XML::Node::Set.from_java(java_obj.getChildNodes).to_a
      end
      
      def child?
        !!child
      end
      
      def prev?
        !!prev
      end
      
      def next?
        !!self.next
      end
      
      def parent?
        !!parent
      end
      
      def parent
        @parent ||= XML::Node.from_java(java_obj.parent_node)
      end
      
      def prev
        @prev ||= XML::Node.from_java(java_obj.previous_sibling)
      end
      
      def last
        @last ||= XML::Node.from_java(java_obj.last_child)
      end
      
      def child
        @child ||= XML::Node.from_java(java_obj.first_child)
      end
            
      def next
        @next ||= XML::Node.from_java(java_obj.next_sibling)
      end 
      
      def attributes
        @attributes ||= XML::Attributes.from_java(java_obj)
      end
      
      def [](name)
        attributes[name]
      end
      
      def []=(name, value)
        attributes[name] = value
      end
      
      def ==(other)
        eql?(other)
      end
      
      def eql?(other)
        return false if other.nil?
        raise TypeError unless self.class === other
        (java_obj.eql?(other.java_obj) || self.to_s == other.to_s)
      end
      
      def equal?(other)
        self.class === other && java_obj.equal?(other.java_obj)
      end
            
      def doc
        @doc ||= XML::Document.from_java(java_obj.owner_document)
      end
      
      def to_s
        transformer = TransformerFactory.newInstance.newTransformer
        result = StreamResult.new(StringWriter.new)
        source = DOMSource.new(java_obj)
        transformer.transform(source, result)
        result.getWriter.toString
      end
      
      def document?
        doc == self
      end
            
      alias :properties :attributes
      
      class Set
        class << self
          def from_java(java_obj)
            s = new
            s.java_obj = java_obj
            s
          end
        end
        
        include Enumerable
        
        attr_accessor :java_obj
        
        def initialize
          @java_obj = java_obj
          @node_cache = {}
        end
        
        def length
          java_obj.length
        end
        
        def empty?
          java_obj.length < 1
        end
        
        def [](index)
          @node_cache[index] ||= XML::Node.from_java(java_obj.item(index))
        end
        
        def first
          self[0]
        end
        
        def each
          i = 0
          while(i < java_obj.length)
            yield self[i]
            i += 1
          end
        end
      end
    end
  end
end