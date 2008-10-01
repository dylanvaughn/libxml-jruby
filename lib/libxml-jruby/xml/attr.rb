module LibXMLJRuby
  module XML
    class Attr
      class << self
        def from_java(java_obj)
          return nil unless java_obj
          a = allocate
          a.java_obj = java_obj
          a
        end
      end
      
      attr_accessor :java_obj
      
      def initialize(node, name, value, ns = nil)
        self.java_obj = node.java_obj
        java_obj.set_attribute(name, value)
      end
      
      def remove!
        java_obj.owner_element.remove_attribute(name)
      end
      
      def parent?
        !!parent
      end
      
      def parent
        XML::Node.from_java(java_obj.owner_element)
      end
      
      def name
        java_obj.name
      end
      
      def value
        java_obj.value
      end
      
      def value=(value)
        raise TypeError if value.nil?
        java_obj.value = value
      end
    end
  end
end
