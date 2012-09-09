require 'date'

class DateTime
  # Ruby 1.9 has DateTime#to_time which internally relies on Time. We define our own #to_time which allows
  # DateTimes outside the range of what can be created with Time.
  # remove_method :to_time if instance_methods.include?(:to_time)

  # Attempts to convert self to a Ruby Time object; returns self if out of range of Ruby Time class.
  # If self has an offset other than 0, self will just be returned unaltered, since there's no clean way to map it to a Time.
  def to_time
    self.offset == 0 ? ::Time.utc(year, month, day, hour, min, sec, sec_fraction * (RUBY_VERSION < '1.9' ? 86400000000 : 1000000)) : self
  end unless method_defined?(:to_time)

end
