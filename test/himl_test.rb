# frozen_string_literal: true

require 'test_helper'

class HimlTest < Test::Unit::TestCase
  private def parse(template)
    parser = Himl::Parser.new
    parser.call(template)
    parser.to_html
  end

  def test_single_open_and_close
    assert_equal <<-HTML, parse(<<-TEMPLATE)
<div>
</div>
HTML
<div>
</div>
TEMPLATE
  end

  def test_single_open
    assert_equal <<-HTML, parse(<<-TEMPLATE)
<div>
</div>
HTML
<div>
TEMPLATE
  end
end
