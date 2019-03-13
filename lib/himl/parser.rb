# frozen_string_literal: true

require 'nokogiri'

module Himl
  class Parser
    class Document < Nokogiri::XML::SAX::Document
      Tag = Struct.new(:name, :indentation, :line, :block_end) do
        def end_tag
          if has_block?
            "#{' ' * indentation}<% #{block_end} %>\n"
          else
            "#{' ' * indentation}</#{name}>\n"
          end
        end

        def erb_tag?
          name == ERB_TAG
        end

        def has_block?
          block_end
        end

        def block_start=(start)
          self.block_end = case start
          when 'do'
            'end'
          when '{'
            '}'
          end
        end
      end

      ErbEndMarker = Class.new(Tag)
      ErbBlockStartMarker = Class.new(Tag)

      ROOT_NODE = 'THE_HIML_ROOT_NODE'
      ERB_TAG = 'HIML_ERB_TAG'
      ERB_TAG_REGEXP = /<%(?:=|==|-|#|%)?(.*?)(?:[-=])?%>/
      BLOCK_REGEXP = /\s*((\s+|\))do|\{)(\s*\|[^|]*\|)?\s*\Z/
      VOID_TAGS = %w(br hr).freeze  #TODO: more tags

      # Copied from Haml
      MID_BLOCK_KEYWORDS = %w[else elsif rescue ensure end when]
      START_BLOCK_KEYWORDS = %w[if begin case unless]

      attr_accessor :context

      def initialize(template)
        @original_template, @tags, @end_tags = template, [], []
        template = template.gsub(ERB_TAG_REGEXP, "<#{ERB_TAG}>\\1</#{ERB_TAG}>")
        @lines = "<#{ROOT_NODE}>\n#{template}</#{ROOT_NODE}>\n".lines
      end

      def template
        @lines.join
      end

      def erb_template
        lines = @original_template.lines

        @end_tags.reverse_each do |index, tag|
          lines.insert index - 1, tag
        end

        lines.join
      end

      def start_element(name, *)
        @current_tag = name

        close_tags unless name == ROOT_NODE

        @tags << Tag.new(name, current_indentation, current_line) unless VOID_TAGS.include? name.downcase
      end

      def end_element(name)
        last_tag = @tags.last
        return if last_tag.name == ROOT_NODE

        if (name == ERB_TAG) && last_tag.is_a?(ErbEndMarker)
          raise SyntaxError "end of block indentation mismatch at line: #{current_line}, column: #{current_indentation}" if last_tag.indentation != @tags[-2].indentation

          @tags.pop
          @tags.pop
        end

        if name == last_tag.name
          if ((last_tag.indentation == current_indentation) || (last_tag.line == current_line))
            @tags.pop
          else
            raise SyntaxError, "end tag indentation mismatch for <#{name}> at line: #{current_line}, column: #{current_indentation}"
          end
        end
        @tags << ErbBlockStartMarker.new(nil, last_tag.indentation, last_tag.line, last_tag.block_end) if (last_tag.name == ERB_TAG) && last_tag.has_block?
      end

      def characters(string)
        if (last_tag = @tags.last).erb_tag?
          case string.strip
          when 'end', '}'
            @tags.pop
            @tags << ErbEndMarker.new(nil, last_tag.indentation, last_tag.line)
          end
        end

        erb_tag = @tags.reverse_each.detect(&:erb_tag?)
        if erb_tag && (match = BLOCK_REGEXP.match(string))
          erb_tag.block_start = match[1].strip
        end
      end

      def close_document!
        @current_tag = nil
        close_tags

        raise SyntaxError, "Unclosed tag: #{@tags.last}" if @tags.last.name != ROOT_NODE
      end

      private

      def current_indentation
        line = @lines[current_line]
        line.slice(0, context.column).rindex('<')
      end

      def current_line
        (context.column == 1) && (context.line > 1) ? context.line - 2 : context.line - 1
      end

      def last_non_empty_line
        @lines[0, current_line].each_with_index.reverse_each {|str, i| break i + 1 unless str.chomp.empty? }
      end

      def close_tags
        while (@tags.last.name != ROOT_NODE) && (current_indentation <= @tags.last.indentation)
          if (@current_tag == ERB_TAG) && (ErbBlockStartMarker === @tags.last) && (@tags.last.indentation == current_indentation)
            break
          else
            @end_tags << [last_non_empty_line, @tags.last.end_tag]
            @tags.pop
          end
        end
      end
    end

    def call(template)
      parse_template template
    end

    def to_erb
      @document.erb_template
    end

    private

    def parse_template(template)
      @document = Document.new template
      @parser = Nokogiri::XML::SAX::Parser.new(@document)
      @parser.parse @document.template do |ctx|
        @document.context = ctx
      end

      @document.close_document!
    end
  end
end
