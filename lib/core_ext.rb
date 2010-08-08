unless :to_proc.respond_to?(:to_proc)
  class Symbol
    # Turns the symbol into a simple proc, 
    # which is especially useful for enumerations.
    #
    # Examples
    #
    #   # The same as people.collect { |p| p.name }
    #   people.collect(&:name)
    #
    #   # The same as people.select { |p| p.manager? }.collect { |p| p.salary }
    #   people.select(&:manager?).collect(&:salary)
    #
    # Extracted from ActiveSupport.
    #
    # Returns a Proc which incapsulates the method business logic.
    def to_proc
      Proc.new { |*args| args.shift.__send__(self, *args) }
    end
  end
end


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