require 'date'

class DateTime
  # Don't remove method if exists or it will conflict with ActiveRecord.
  # See http://github.com/weppos/whois/issues#issue/24
  unless method_defined?(:to_time)
    # Attempts to convert self to a Ruby Time object; returns self if out of range of Ruby Time class
    # If self has an offset other than 0, self will just be returned unaltered, since there's no clean way to map it to a Time.
    #
    # Extracted from ActiveSupport.
    def to_time
      self.offset == 0 ? ::Time.utc(year, month, day, hour, min, sec) : self
    end
  end
end