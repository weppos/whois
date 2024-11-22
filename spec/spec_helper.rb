# frozen_string_literal: true

require "rspec"
require "whois"

SPEC_ROOT = File.expand_path(__dir__) unless defined?(SPEC_ROOT)

# The fixtures are UTF-8 encoded.
# Make sure Ruby uses the proper encoding.
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(SPEC_ROOT, "support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
end
