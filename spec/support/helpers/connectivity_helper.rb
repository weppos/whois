module RSpecSupportConnectivityHelpers
  def need_connectivity
    if connectivity_available?
      yield
    end
  end

  def connectivity_available?
    ENV["ONLINE"].to_i == 1
  end
end

RSpec.configure do |config|
  config.extend RSpecSupportConnectivityHelpers
end
