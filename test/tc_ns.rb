require File.dirname(File.basename(__FILE__)) + '/test/test_helper'

class TestNS < Test::Unit::TestCase
  def test_ns
    node = XML::Node.new('foo')
    ns = XML::NS.new(node, 'http://www.mynamespace.com', 'my_namepace')
    assert(ns.prefix, 'my_namepace')
    assert(ns.href, 'http://www.mynamespace.com')
  end
  
  def test_default_ns
    node = XML::Node.new('foo')
    ns = XML::NS.new(node, 'http://www.mynamespace.com', nil)
    assert(ns.prefix, nil)
    assert(ns.href, 'http://www.mynamespace.com')
  end
end
