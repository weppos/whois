if defined?(ActiveSupport::VERSION) && ActiveSupport::VERSION::MAJOR == 3
  require 'active_support/core_ext/array/wrap'
  require 'active_support/core_ext/date_time/conversions'
  require 'core_ext/class/attribute'
else
  require 'core_ext/array/wrap'
  require 'core_ext/date_time/conversions'
  require 'core_ext/class/attribute'
end