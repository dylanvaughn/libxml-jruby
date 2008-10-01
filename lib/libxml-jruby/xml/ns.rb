module LibXMLJRuby
  module XML
    class NS
      class << self
        def from_java(java_obj)
          
        end
      end
      
      def initialize(node, href, prefix)
        @node, @href, @prefix = node, href, prefix
      end
      
      attr_reader :href, :prefix
      def href?; !!href; end
      def prefix?; !!prefix; end
    end
  end
end