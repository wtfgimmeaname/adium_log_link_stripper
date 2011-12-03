require 'relinkwish'
require 'test/unit'

class RelinkwishTest < Test::Unit::TestCase

  def setup
    @relinkwish = Relinkwish.new
  end

  def test_extract_links_when_line_has_multiple_links
    line = %{<message sender="aim4vince" time="2011-01-19T13:00:40-08:00"><div><a href="http://vimeo.com/18056906" style="color: #000000; font-family: Helvetica; font-size: 12pt;">http://vimeo.com/18056906</a></div></message>}
    line += line
    expected_links = [
      "http://vimeo.com/18056906",
      "http://vimeo.com/18056906"
    ]

    links = @relinkwish.extract_links(line)
    assert_equal expected_links, links
  end

  def test_extract_links_when_line_has_one_link
    line = %{<message sender="aim4vince" time="2011-01-19T13:00:40-08:00"><div><a href="http://vimeo.com/18056906" style="color: #000000; font-family: Helvetica; font-size: 12pt;">http://vimeo.com/18056906</a></div></message>}
    expected_links = [
      "http://vimeo.com/18056906"
    ]

    links = @relinkwish.extract_links(line)
    assert_equal expected_links, links
  end

  def test_extract_links_when_line_has_no_links
    line = %{adsf asdf asdf }
    expected_links = []

    links = @relinkwish.extract_links(line)
    assert_equal expected_links, links
  end

end
