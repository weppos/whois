if defined?(ActiveSupport::VERSION) && ActiveSupport::VERSION::MAJOR == 3
  require 'active_support/core_ext/array/wrap'
  require 'active_support/core_ext/class/attribute'
  require 'active_support/core_ext/object/blank'
else
  require 'whois/core_ext/array/wrap'
  require 'whois/core_ext/class/attribute'
  require 'whois/core_ext/object/blank'
end