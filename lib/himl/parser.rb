# frozen_string_literal: true

require 'nokogiri'

module Himl
  class Parser
    class Document < Nokogiri::XML::SAX::Document
      Tag = Struct.new(:name) do
        def end_tag
          "</#{name}>\n"
        end
      end

      def initialize(template)
        @lines, @tags, @end_tags = template.lines, [], []
      end

      def template
        @lines.join
      end

      def start_element(name, *)
        @tags << Tag.new(name)
      end

      def end_element(name)
        @tags.pop if name == @tags.last.name
      end

      def close_tags
        while @tags.any?
          @end_tags << @tags.last.end_tag
          @tags.pop
        end
      end

      def weave_end_tags
        @end_tags.reverse_each do |tag|
          @lines.append tag
        end
      end

      def verify!
        raise SyntaxError if @tags.any?
      end
    end

    def call(template)
      parse_template template
    end

    def to_html
      @document.weave_end_tags
      @document.template
    end

    private

    def parse_template(template)
      @document = Document.new template
      @parser = Nokogiri::XML::SAX::Parser.new(@document)
      @parser.parse template

      @document.close_tags

      @document.verify!
    end
  end
end
