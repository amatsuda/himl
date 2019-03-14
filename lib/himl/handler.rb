# frozen_string_literal: true

module Himl
  class Handler
    def self.call(template, source = nil)
      new.call(source || template.source)
    end

    def call(source)
      parser = Himl::Parser.new
      parser.call(source)
      erb = parser.to_erb
      erb_handler = Template.handler_for_extension('erb')

      erb_handler.erb_implementation.new(
        erb,
        escape: (erb_handler.escape_ignore_list.include? template.type),
        trim: (erb_handler.erb_trim_mode == "-")
      ).src
    end
  end
end
