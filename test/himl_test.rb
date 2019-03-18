# frozen_string_literal: true

require 'test_helper'

class HimlTest < Test::Unit::TestCase
  private def parse(template)
    Himl::Parser.new.call(template).to_erb
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

  def test_void_tags
    assert_equal <<-HTML, parse(<<-TEMPLATE)
<br>
<hr>
HTML
<br>
<hr>
TEMPLATE
  end

  def test_if
    assert_equal <<-HTML, parse(<<-TEMPLATE)
<% if true %>
  TRUE
<% end %>
HTML
<% if true %>
  TRUE
TEMPLATE
  end

  def test_else
    assert_equal <<-HTML, parse(<<-TEMPLATE)
<% if one %>
  1
<% elsif two %>
  2
<% else %>
  3
<% end %>
HTML
<% if one %>
  1
<% elsif two %>
  2
<% else %>
  3
TEMPLATE
  end

  def test_real_scaffold_index
    assert_equal <<-HTML, parse(<<-TEMPLATE)
<p id="notice"><%= notice %></p>

<h1>Users</h1>

<table>
  <thead>
    <tr>
      <th>Name</th>
      <th colspan="3"></th>
    </tr>
  </thead>

  <tbody>
    <% @users.each do |user| %>
      <tr>
        <td><%= user.name %></td>
        <td><%= link_to 'Show', user %></td>
        <td><%= link_to 'Edit', edit_user_path(user) %></td>
        <td><%= link_to 'Destroy', user, method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
</table>

<br>

<%= link_to 'New User', new_user_path %>
HTML
<p id="notice"><%= notice %></p>

<h1>Users</h1>

<table>
  <thead>
    <tr>
      <th>Name</th>
      <th colspan="3"></th>

  <tbody>
    <% @users.each do |user| %>
      <tr>
        <td><%= user.name %></td>
        <td><%= link_to 'Show', user %></td>
        <td><%= link_to 'Edit', edit_user_path(user) %></td>
        <td><%= link_to 'Destroy', user, method: :delete, data: { confirm: 'Are you sure?' } %></td>

<br>

<%= link_to 'New User', new_user_path %>
TEMPLATE
  end

  def test_real_scaffold_show
    assert_equal <<-HTML, parse(<<-TEMPLATE)
<p id="notice"><%= notice %></p>

<p>
  <strong>Name:</strong>
  <%= @user.name %>
</p>

<%= link_to 'Edit', edit_user_path(@user) %> |
<%= link_to 'Back', users_path %>
HTML
<p id="notice"><%= notice %></p>

<p>
  <strong>Name:</strong>
  <%= @user.name %>

<%= link_to 'Edit', edit_user_path(@user) %> |
<%= link_to 'Back', users_path %>
TEMPLATE
  end

  def test_real_scaffold_form
    assert_equal <<-HTML, parse(<<-TEMPLATE)
<%= form_with(model: user, local: true) do |form| %>
  <% if user.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(user.errors.count, "error") %> prohibited this user from being saved:</h2>

      <ul>
        <% user.errors.full_messages.each do |message| %>
          <li><%= message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div class="field">
    <%= form.label :name %>
    <%= form.text_field :name %>
  </div>

  <div class="actions">
    <%= form.submit %>
  </div>
<% end %>
HTML
<%= form_with(model: user, local: true) do |form| %>
  <% if user.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(user.errors.count, "error") %> prohibited this user from being saved:</h2>

      <ul>
        <% user.errors.full_messages.each do |message| %>
          <li><%= message %></li>

  <div class="field">
    <%= form.label :name %>
    <%= form.text_field :name %>

  <div class="actions">
    <%= form.submit %>
TEMPLATE
  end
end
