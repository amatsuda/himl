# Himl

Himl is an HTML-based Indented Markup Language for Ruby.


## What's This?

Himl is a yet another template engine for Haml-lovers and non Haml-lovers, deriving HTML validity from Haml and syntax intuitiveness from ERB.


## Motivation

Haml is a great template engine that liberates us from annoying HTML bugs.
By automatically closing the HTML tags, Haml always produces perfectly structured 100% valid HTML responses.
Actually, I've never experienced the HTML closing tag mismatch error over the past 10 years or so, thanks to Haml.

However, the Haml (or Slim or whatever equivalent) syntax is very much different from that of HTML.
And to be honest, I still rarely can complete my template markup works without consulting the Haml online reference manual.

Oh, why do we have to learn another markup language syntax where we just want to generate HTML documents?
HTML has tags. HTML has indentations. Why can't we just use them?


## Syntax

Himl syntax is a hybrid of ERB and Haml.
Himl is basically just a kind of ERB. Indeed, Himl documents are compiled to ERB internally, then rendered by the ERB handler.

So, the following Himl template opening and closing a tag will be compiled to exactly the same ERB template.

Himl
```erb
<div>
</div>
```

ERB
```erb
<div>
</div>
```

You can omit closing tags. Then Himl auto-closes them, just like Haml does.

Himl
```erb
<div>
```
ERB
```erb
<div>
</div>
```

For nesting tags, use whitespaces just like you do in the Haml templates.

Himl
```erb
<section>
  <div>
```

ERB
```erb
<section>
  <div>
  </div>
</section>
```

Of course you can include dynamic Ruby code in the ERB way.

Himl
```erb
<section>
  <div>
    <%= post.content %>
```

ERB
```erb
<section>
  <div>
    <%= post.content %>
  </div>
</section>
```

Ruby blocks in the ERB tag can also automatically be closed.

Himl
```erb
<ul>
  <%= @users.each do |user| %>
    <li>
      <%= user.name %>
```

ERB
```erb
<ul>
  <%= @users.each do |user| %>
    <li>
      <%= user.name %>
    </li>
  <% end %>
</ul>
```

Or manually be closed.

Himl
```erb
<ul>
  <%= @users.each do |user| %>
    <li>
      <%= user.name %>
  <% end %>
```

ERB
```erb
<ul>
  <%= @users.each do |user| %>
    <li>
      <%= user.name %>
    </li>
  <% end %>
</ul>
```

You can open and close tags in the same line.

Himl
```erb
<section>
  <h1><%= post.title %></h1>
```

ERB
```erb
<section>
  <h1><%= post.title %></h1>
</section>
```

There's no special syntax for adding HTML attributes to the tags. You see, it's just ERB.

Himl
```erb
<section class="container">
  <div class="content">
```

ERB
```erb
<section class="container">
  <div class="content">
  </div>
</section>
```

More detailed syntax may be covered in [the tests](https://github.com/amatsuda/himl/blob/master/test/himl_test.rb).


## Document Validations

Himl's strongest advantage is not that you just can reduce the template LOC, but the engine validates the structure of the document and detects some syntax errors.
For example, Himl raises `SyntaxError` while parsing these templates.

Mismatched closing tag
```erb
<div>
  hello?
  </div>
```

Mismatched ERB `end` expression
```erb
  <% if @current_user.admin? %>
    TOP SECRET
<% end %>
```

Extra ERB `end` expression
```erb
<% @books.each do |book| %>
  <% book.read %>
<% end %>
<% end %>
```


## Example

Following is a comparison of ERB, Haml, and Himl templates that renders similar HTML results (the Haml example is taken from the [Haml documentation](http://haml.info/)).
You'll notice that Himl consumes the same LOC with the Haml version for expressing the structure of this document, without introducing any new syntax from the ERB version.

### ERB Template
```erb
<section class="container">
  <h1><%= post.title %></h1>
  <h2><%= post.subtitle %></h2>
  <div class="content">
    <%= post.content %>
  </div>
</section>

```

### Haml Template
```haml
%section.container
  %h1= post.title
  %h2= post.subtitle
  .content
    = post.content
```

### Himl Template
```erb
<section class="container">
  <h1><%= post.title %></h1>
  <h2><%= post.subtitle %></h2>
  <div class="content">
    <%= post.content %>
```


## Installation

Bundle 'himl' gem to your project.


## Usage

The gem contains the Himl template handler for Rails.
You need no extra configurations for your Rails app to render `*.himl` templates.

## Tilt support

The gem comes with [tilt](https://github.com/rtomayko/tilt) support and
thus can be used with frameworks such as [Hanami](https://hanamirb.org).

Use following `gem` line:

```rb
gem 'tilt' # if needed
gem 'himl', require: 'himl/tilt'
```

Now you can render Himl templates via Tilt:

```rb
puts Tilt['himl'].new { <<TEMPLATE }.render(self, name: 'John')
<div>
  <h1>Hello, <%= name %></h1>
TEMPALTE
```

and will get

```html
<div>
  <h1>Hello, John</h1>
</div>
```

## Runtime Performance

Since every Himl template is converted to ERB, then cached as a Ruby method inside the view frameworks (such as Action View in Rails), Himl runtime performance in production is exactly the same with that of ERB.


## Contributing

Pull requests are welcome on GitHub at https://github.com/amatsuda/himl.


## Other Template Engines That I Maintain

### [jb](https://github.com/amatsuda/jb)

A faster and simpler and stronger alternative to Jbuilder.

### [string_template](https://github.com/amatsuda/string_template)

The ultimate fastest template engine for Rails in the world.

### [Haml](https://github.com/haml/haml)

The one that you may be currently using everyday.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
