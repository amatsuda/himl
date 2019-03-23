# frozen_string_literal: true

require 'test_helper'

require 'himl/tilt'
require 'tempfile'

class TiltTest < Test::Unit::TestCase
  private def file_with_content(content)
    Tempfile.open do |tmp|
      tmp.print content
      tmp
    end
  end

  private def parse(content, scope=nil, **locals, &block)
    file = file_with_content(content)
    scope ||= Object.new
    Tilt::HimlTemplate.new(file).render(scope, locals, &block)
  end

  def test_without_args
    assert_equal <<~HTML, parse(<<~TEMPLATE)
    <div>
      <h1>Hello, world</h1>
    </div>
    HTML
    <div>
      <h1>Hello, world</h1>
    TEMPLATE
  end

  def test_with_locals
    assert_equal <<~HTML, parse(<<~TEMPLATE, name1: 'Alice', name2: 'Bob')
    <div>
      <ul>
        <li>Hello, Alice</li>
        <li>Hello, Bob</li>
      </ul>
    </div>
    HTML
    <div>
      <ul>
        <li>Hello, <%= name1 %></li>
        <li>Hello, <%= name2 %></li>
    TEMPLATE
  end

  def test_with_locals_and_code
    assert_equal <<~HTML, parse(<<~TEMPLATE, names: %w[Alice Bob])
    <div>
      <ul>
          <li>Hello, Alice</li>
          <li>Hello, Bob</li>
      </ul>
    </div>
    HTML
    <div>
      <ul>
        <%- names.each do |name| -%>
          <li>Hello, <%= name %></li>
        <%- end -%>
    TEMPLATE
  end

  def test_with_scope
    charlie = Object.new.tap {|o| o.instance_variable_set(:@name, 'Charlie') }
    assert_equal <<~HTML, parse(<<~TEMPLATE, charlie)
    <div>
      <ul>
        <li>Hello, Charlie</li>
      </ul>
    </div>
    HTML
    <div>
      <ul>
        <li>Hello, <%= @name %></li>
    TEMPLATE
  end

  def test_with_block
    assert_equal <<~HTML, (parse(<<~TEMPLATE) { "hello" })
    hello
    HTML
    <%= yield %>
    TEMPLATE
  end

  def test_registration
    file = Tempfile.new(['', '.himl'])
    assert_equal Tilt::HimlTemplate, Tilt.new(file.path).class
  end
end
