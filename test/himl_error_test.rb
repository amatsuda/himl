# frozen_string_literal: true

require 'test_helper'

class HimlErrorTest < Test::Unit::TestCase
  private def parse(template)
    Himl::Parser.new.call(template).to_erb
  end

  private def assert_syntax_error(message = '', &block)
    assert_raise SyntaxError, message, &block
  end

  def test_close_mismatch_1
    assert_syntax_error { parse(<<-TEMPLATE) }
<div>
      </div>
TEMPLATE
  end

  def test_close_mismatch_2
    assert_syntax_error { parse(<<-TEMPLATE) }
  <div>
</div>
TEMPLATE
  end

  def test_erb_end_only
    assert_syntax_error { parse(<<-TEMPLATE) }
    <% end %>
TEMPLATE
  end

  def test_erb_end_mismatch_1
    assert_syntax_error { parse(<<-TEMPLATE) }
<% if true %>
    <% end %>
TEMPLATE
  end

  def test_erb_end_mismatch_2
    assert_syntax_error { parse(<<-TEMPLATE) }
  <% if true %>
<% end %>
TEMPLATE
  end
end
