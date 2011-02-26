require File.join(File.dirname(__FILE__), '..', 'helper')
require 'nokogiri'

# Tests for RenderHelper mixin using SiteItem, which mixes it in
class TestRenderHelper < Test::Unit::TestCase
  def test_back_link
    assert_equal '../index.html', SiteDir.new('pics', [], '/tmp').back_link(1)
    assert_equal '../index.html', SiteDir.new('pics', [], '/tmp').back_link
    assert_equal '../pics.html', SiteDir.new('pics/people', [], '/tmp').back_link(1)
    assert_equal '../../index.html', SiteDir.new('pics/people', [], '/tmp').back_link(2)
    assert_equal '../people.html', SiteDir.new('pics/people/friends', [], '/tmp').back_link(1)
    assert_equal '../../pics.html', SiteDir.new('pics/people/friends', [], '/tmp').back_link(2)
    assert_equal '../../../index.html', SiteDir.new('pics/people/friends', [], '/tmp').back_link(3)

    # Test too many levels up and non-Integer arg
    assert_equal '../index.html', SiteDir.new('pics', [], '/tmp').back_link(2)
    assert_equal '../index.html', SiteDir.new('pics', [], '/tmp').back_link(3)
    assert_equal '../index.html', SiteDir.new('pics', [], '/tmp').back_link(nil)
    assert_equal '', SiteDir.new('', [], '/tmp').back_link(1)
    assert_equal '', SiteDir.new('', [], '/tmp').back_link(nil)
  end

  def test_parent_directory_link_tag
    sd = SiteDir.new('pics/people/friends', [], '/tmp')

    basic_link_doc = Nokogiri::HTML(sd.parent_directory_link_tag(1))
    links = basic_link_doc.css('a')
    assert_equal 1, links.size
    assert_equal '../people.html', links[0].attribute('href').value
    assert_equal 'people', links[0].content

    basic_link_doc = Nokogiri::HTML(sd.parent_directory_link_tag(2))
    links = basic_link_doc.css('a')
    assert_equal 1, links.size
    assert_equal '../../pics.html', links[0].attribute('href').value
    assert_equal 'pics', links[0].content

    basic_link_doc = Nokogiri::HTML(sd.parent_directory_link_tag(3))
    links = basic_link_doc.css('a')
    assert_equal 1, links.size
    assert_equal '../../../index.html', links[0].attribute('href').value
    assert_equal 'my files', links[0].content
  end

  def test_parent_directory_link_tag_with_additional_attributes
    sd = SiteDir.new('pics/people/friends', [], '/tmp')
    id = 'the-id'
    css_class = 'the-css-class'

    link_doc = Nokogiri::HTML(sd.parent_directory_link_tag(1, :class => css_class))
    links = link_doc.css('a')
    assert_equal 1, links.size
    link = links[0]
    assert_equal '../people.html', link.attribute('href').value
    assert_equal 'people', link.content
    assert_equal css_class, link.attribute('class').value

    link_doc = Nokogiri::HTML(sd.parent_directory_link_tag(1, :id => id, :class => css_class))
    links = link_doc.css('a')
    assert_equal 1, links.size
    link = links[0]
    assert_equal '../people.html', link.attribute('href').value
    assert_equal 'people', link.content
    assert_equal id, link.attribute('id').value
    assert_equal css_class, link.attribute('class').value
  end

  def test_each_parent_directory_link_tag_with_root
    links = ''
    sd = SiteDir.new('pics/people/friends', [], '/tmp')
    sd.each_parent_directory_link_tag {|link| links << link}
    links_doc = Nokogiri::HTML(links)
    links = links_doc.css('a')
    assert_equal 3, links.size

    root_link = links_doc.css('a').find {|a| a.content == 'my files'}
    assert_equal '../../../index.html', root_link.attribute('href').value
    pics_link = links_doc.css('a').find {|a| a.content == 'pics'}
    assert_equal '../../pics.html', pics_link.attribute('href').value
    people_link = links_doc.css('a').find {|a| a.content == 'people'}
    assert_equal '../people.html', people_link.attribute('href').value
  end

  def test_each_parent_directory_link_tag_without_root
    links = ''
    sd = SiteDir.new('pics/people/friends', [], '/tmp')
    sd.each_parent_directory_link_tag(false) {|link| links << link}
    links_doc = Nokogiri::HTML(links)
    links = links_doc.css('a')
    assert_equal 2, links.size

    pics_link = links_doc.css('a').find {|a| a.content == 'pics'}
    assert_equal '../../pics.html', pics_link.attribute('href').value
    people_link = links_doc.css('a').find {|a| a.content == 'people'}
    assert_equal '../people.html', people_link.attribute('href').value
  end
end
