if defined?(ActiveSupport::VERSION) && ActiveSupport::VERSION::MAJOR == 3
  require 'active_support/core_ext/array/wrap'
  require 'whois/core_ext/class/attribute'
else
  require 'whois/core_ext/array/wrap'
  require 'whois/core_ext/class/attribute'
end