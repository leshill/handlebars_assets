# frozen_string_literal: true

require 'test_helper'
require_relative 'shared/adapter_tests'

module HandlebarsAssets
  class HandlebarsProcessorTest < Minitest::Test
    include AdapterTests

    def teardown
      HandlebarsAssets::Config.reset!
      HandlebarsAssets::Handlebars.reset!
    end

    def render_it(scope, source)
      HandlebarsAssets::HandlebarsProcessor.call(filename: scope.pathname.to_s, data: source)[:data]
    end
  end
end
