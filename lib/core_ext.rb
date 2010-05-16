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
    # Returns a Proc which incapsulates the method business logic.
    def to_proc
      Proc.new { |*args| args.shift.__send__(self, *args) }
    end
  end
end

class DateTime
  # Ruby 1.9 has DateTime#to_time which internally relies on Time. We define our own #to_time which allows
  # DateTimes outside the range of what can be created with Time.
  remove_method :to_time if instance_methods.include?(:to_time)

  # Attempts to convert self to a Ruby Time object; returns self if out of range of Ruby Time class
  # Extracted from ActiveSupport.
  #
  # If self has an offset other than 0, self will just be returned unaltered, since there's no clean way to map it to a Time.
  def to_time
    self.offset == 0 ? ::Time.utc(year, month, day, hour, min, sec) : self
  end
end