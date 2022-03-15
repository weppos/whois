# frozen_string_literal: true

module RSpecSupportConnectivityHelpers
  def need_connectivity
    yield if connectivity_available?
  end

  def connectivity_available?
    ENV["ONLINE"].to_i == 1
  end
end

RSpec.configure do |config|
  config.extend RSpecSupportConnectivityHelpers
end
