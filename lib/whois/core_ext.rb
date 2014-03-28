# These extensions are handy Ruby features imported from ActiveSupport
# I don't want to make ActiveSupport a dependency
# but I really need those methods. Credits to the Rails Core team for them.
if defined?(ActiveSupport::VERSION) && ActiveSupport::VERSION::MAJOR >= 4
  require 'active_support/core_ext/object/blank'
  require 'active_support/core_ext/class/attribute'
  require 'active_support/core_ext/array/wrap'
  require 'active_support/core_ext/time/calculations'
else
  require 'whois/core_ext/object/blank'
  require 'whois/core_ext/class/attribute'
  require 'whois/core_ext/array/wrap'
  require 'whois/core_ext/time/calculations'
end
