# frozen_string_literal: true

begin
  require 'rails'

  module Himl
    class Railtie < ::Rails::Railtie
      initializer 'himl' do
        ActiveSupport.on_load :action_view do
          require_relative 'handler'

          ActionView::Template.register_template_handler :himl, Himl::Handler
        end
      end
    end
  end
rescue LoadError
  # do nothing
end
