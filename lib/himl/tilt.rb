# frozen_string_literal: true

require 'tilt'
require 'tilt/erb'
require 'himl/parser'

module Tilt
  class HimlTemplate < ERBTemplate
    def prepare
      parser = Himl::Parser.new
      parser.call(@data)
      @data = parser.to_erb
      options[:trim] = '-<>' unless options.key?(:trim)
      super
    end
  end
  register 'himl', HimlTemplate
end
