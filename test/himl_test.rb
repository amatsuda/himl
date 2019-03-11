# frozen_string_literal: true

require 'test_helper'

class HimlTest < Test::Unit::TestCase
  private def parse(template)
    parser = Himl::Parser.new
    parser.call(template)
    parser.to_erb
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

  def test_nested_opens
    assert_equal <<-HTML, parse(<<-TEMPLATE)
<a>
  <b>
  </b>
</a>
HTML
<a>
  <b>
TEMPLATE
  end

  def test_open_close_open
    assert_equal <<-HTML, parse(<<-TEMPLATE)
<a>
</a>
<b>
</b>
HTML
<a>
</a>
<b>
TEMPLATE
  end

  def test_auto_close_on_dedent
    assert_equal <<-HTML, parse(<<-TEMPLATE)
<a>
  <b>
  </b>
</a>
<c>
</c>
HTML
<a>
  <b>
<c>
TEMPLATE
  end

  def test_close_in_same_line
    assert_equal <<-HTML, parse(<<-TEMPLATE)
<a>hello</a>
HTML
<a>hello</a>
TEMPLATE
  end

  def test_erb
    assert_equal <<-HTML, parse(<<-TEMPLATE)
<a>
  <%= 'hello' %>
  <b>
  </b>
</a>
HTML
<a>
  <%= 'hello' %>
  <b>
TEMPLATE
  end

  def test_erb_with_block_without_end
    assert_equal <<-HTML, parse(<<-TEMPLATE)
<% @users.each do |user| %>
<% end %>
HTML
<% @users.each do |user| %>
TEMPLATE
  end

  def test_erb_with_curly_block_without_end
    assert_equal <<-HTML, parse(<<-TEMPLATE)
<% @users.each {|user| %>
<% } %>
HTML
<% @users.each {|user| %>
TEMPLATE
  end

  def test_erb_with_block_with_end
    assert_equal <<-HTML, parse(<<-TEMPLATE)
<% @users.each do |user| %>
<% end %>
HTML
<% @users.each do |user| %>
<% end %>
TEMPLATE
  end

  def test_erb_with_block_with_end_2
    assert_equal <<-HTML, parse(<<-TEMPLATE)
<% @users.each do |user| %>
  <p>
    <%= user.name %>
  </p>
<% end %>
HTML
<% @users.each do |user| %>
  <p>
    <%= user.name %>
<% end %>
TEMPLATE
  end

  def test_erb_with_curly_block_with_end
    assert_equal <<-HTML, parse(<<-TEMPLATE)
<% @users.each {|user| %>
<% } %>
HTML
<% @users.each {|user| %>
<% } %>
TEMPLATE
  end

  def test_blank_line_before_dedent
    assert_equal <<-HTML, parse(<<-TEMPLATE)
<div id="a">
  <div id="b">
  </div>
</div>

<div id="c">
</div>
HTML
<div id="a">
  <div id="b">

<div id="c">
TEMPLATE
  end
end
