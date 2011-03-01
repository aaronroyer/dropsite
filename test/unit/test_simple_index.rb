require File.join(File.dirname(__FILE__), '..', 'helper')
require 'nokogiri'

class TestSimpleIndex < Test::Unit::TestCase
  def test_file_names_and_icons
    entries = [
      SiteFile.new('pic.jpg'),
      SiteFile.new('stuff.pdf'),
      SiteFile.new('tps-report.doc'),
    ]
    sd = SiteDir.new('', entries, Site.new('/tmp'))
    sd.render

    doc = Nokogiri::HTML(sd.content)
    entry_rows = doc.css('tr.entry')

    assert_equal entries.size, entry_rows.size
    assert_file_has_icon 'pic.jpg', 'image', entry_rows
    assert_file_has_icon 'stuff.pdf', 'pdf', entry_rows
    assert_file_has_icon 'tps-report.doc', 'word', entry_rows
  end

  protected

  def assert_file_has_icon(file_name, icon_name, entry_rows)
    row = entry_rows.find {|er| er.css('a').first.content.strip == file_name}
    assert_equal "dropsite/dropsite-assets/simple_index/images/icons/#{icon_name}.png",
      row.css('img').first.attribute('src').value
  end
end
