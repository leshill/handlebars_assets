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
      environment = Sprockets::Environment.new
      input = {
        environment: environment,
        filename: scope.pathname.to_s,
        data: source,
        metadata: {}
      }
      HandlebarsAssets::HandlebarsProcessor.call(input)
    end
  end
end
