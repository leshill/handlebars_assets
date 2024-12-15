# frozen_string_literal: true

require 'test_helper'
require_relative 'shared/adapter_tests'

module HandlebarsAssets
  class HandlebarsTemplateTest < Minitest::Test
    include AdapterTests

    def teardown
      HandlebarsAssets::Config.reset!
      HandlebarsAssets::Handlebars.reset!
    end

    def render_it(scope, source)
      template = HandlebarsAssets::HandlebarsTemplate.new(scope.pathname.to_s) { source }
      template.render(scope, {})
    end
  end
end
