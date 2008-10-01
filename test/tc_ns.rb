require File.dirname(File.basename(__FILE__)) + '/test/test_helper'

class TestNS < Test::Unit::TestCase
  def test_ns
    node = XML::Node.new('foo')
    ns = XML::NS.new(node, 'http://www.mynamespace.com', 'my_namepace')
    assert_equal('my_namepace', ns.prefix)
    assert_equal('http://www.mynamespace.com', ns.href)
  end
  
  def test_default_ns
    node = XML::Node.new('foo')
    ns = XML::NS.new(node, 'http://www.mynamespace.com', nil)
    assert_equal(nil, ns.prefix)
    assert_equal('http://www.mynamespace.com', ns.href)
  end
end
