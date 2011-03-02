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


class Array

  # Wraps its argument in an array unless it is already an array (or array-like).
  #
  # Specifically:
  #
  # * If the argument is +nil+ an empty list is returned.
  # * Otherwise, if the argument responds to +to_ary+ it is invoked, and its result returned.
  # * Otherwise, returns an array with the argument as its single element.
  #
  #   Array.wrap(nil)       # => []
  #   Array.wrap([1, 2, 3]) # => [1, 2, 3]
  #   Array.wrap(0)         # => [0]
  #
  # Extracted from ActiveSupport.
  def self.wrap(object)
    if object.nil?
      []
    elsif object.respond_to?(:to_ary)
      object.to_ary
    else
      [object]
    end
  end unless respond_to?(:wrap)

end
