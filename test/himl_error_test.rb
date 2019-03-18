# frozen_string_literal: true

require 'test_helper'

class HimlErrorTest < Test::Unit::TestCase
  private def parse(template)
    Himl::Parser.new.call(template).to_erb
  end

  private def assert_syntax_error(message = '', &block)
    assert_raise SyntaxError, message, &block
  end

  def test_close
    assert_syntax_error { parse(<<-TEMPLATE) }
<div>
  </div>
TEMPLATE
  end
end
