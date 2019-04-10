# frozen_string_literal: true

module Himl
  class Handler
    ERB_HANDLER = ActionView::Template.handler_for_extension('erb')

    def self.call(template, source = nil)
      new.call(template, source || template.source)
    end

    def call(template, source)
      erb = Himl::Parser.new.call(source).to_erb

      escape = ERB_HANDLER.respond_to?(:escape_ignore_list) ? ERB_HANDLER.escape_ignore_list.include?(template.type) : ERB_HANDLER.escape_whitelist.include?(template.type)

      ERB_HANDLER.erb_implementation.new(
        erb,
        escape: escape,
        trim: (ERB_HANDLER.erb_trim_mode == "-")
      ).src
    end
  end
end
