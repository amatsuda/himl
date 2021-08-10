# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "himl"

require 'test/unit'
require 'byebug'
