# frozen_string_literal: true

require 'nokogiri'

module Himl
  class Parser
    class Document < Nokogiri::XML::SAX::Document
      Tag = Struct.new :name

      def initialize
        @tags = []
      end

      def start_element(name, *)
        @tags << Tag.new(name)
      end

      def end_element(name)
        @tags.pop if name == @tags.last.name
      end

      def verify!
        raise SyntaxError if @tags.any?
      end
    end

    def call(template)
      @template = template

      parse_template
    end

    def to_html
      @template
    end

    private

    def parse_template
      document = Document.new
      @parser = Nokogiri::XML::SAX::Parser.new(document)
      @parser.parse @template

      document.verify!
    end
  end
end
