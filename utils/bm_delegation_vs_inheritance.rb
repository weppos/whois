$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'benchmark'
require 'delegate'

class Foo < Delegate%CLASS{String}
  attr_reader :optional
  def initialize(mandatory, optional = nil)
    super(String.new(mandatory))
    @optional = optional
  end
end

class Bar < String
  attr_reader :optional
  def initialize(mandatory, optional = nil)
    super(mandatory)
    @optional = optional
  end
end

class Baz
  attr_reader :optional
  def initialize(mandatory, optional = nil)
    @string   = mandatory.to_s
    @optional = optional
  end

  def match(*args)
    @string.match(*args)
  end

  def gsub(*args)
    @string.gsub(*args)
  end

  def gsub!(*args)
    @string.gsub!(*args)
  end
end

class Option < Struct.new(:qui, :quo, :qua)
  def to_s
    "-" * 100
  end
end


TIMES   = 100_000
CONTENT = <<-LOREM
Lorem ipsum dolor sit amet, consectetur adipisicing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris
nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in
reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
Excepteur sint occaecat cupidatat non proident,
sunt in culpa qui officia deserunt mollit anim id est laborum.
LOREM

Benchmark.bmbm do |x|
  x.report("inheritance =~") do
    TIMES.times do
      s = Foo.new(CONTENT, Option.new)
      s =~ /Duis/
    end
  end
  x.report("delegation  =~")  do
    TIMES.times do
      s = Bar.new(CONTENT, Option.new)
      s =~ /Duis/
    end
  end
  x.report("composition =~")  do
    # TIMES.times do
    #   s = Baz.new(CONTENT, Option.new)
    #   s =~ /Duis/
    # end
  end
  x.report("inheritance match") do
    TIMES.times do
      s = Foo.new(CONTENT, Option.new)
      s.match(/Status:/)
    end
  end
  x.report("delegation  match")  do
    TIMES.times do
      s = Bar.new(CONTENT, Option.new)
      s.match(/Status:/)
    end
  end
  x.report("composition match")  do
    TIMES.times do
      s = Baz.new(CONTENT, Option.new)
      s.match(/Status:/)
    end
  end
  x.report("inheritance gsub") do
    TIMES.times do
      s = Foo.new(CONTENT, Option.new)
      s.gsub(/ /, '_')
    end
  end
  x.report("delegation  gsub")  do
    TIMES.times do
      s = Bar.new(CONTENT, Option.new)
      s.gsub(/ /, '_')
    end
  end
  x.report("composition gsub")  do
    TIMES.times do
      s = Baz.new(CONTENT, Option.new)
      s.gsub(/ /, '_')
    end
  end
  x.report("inheritance gsub!") do
    TIMES.times do
      s = Foo.new(CONTENT, Option.new)
      s.gsub!(/ /, '_')
    end
  end
  x.report("delegation  gsub!")  do
    TIMES.times do
      s = Bar.new(CONTENT, Option.new)
      s.gsub!(/ /, '_')
    end
  end
  x.report("composition gsub!")  do
    TIMES.times do
      s = Baz.new(CONTENT, Option.new)
      s.gsub!(/ /, '_')
    end
  end
  x.report("inheritance option") do
    TIMES.times do
      s = Foo.new(CONTENT, Option.new)
      s.optional.to_s
    end
  end
  x.report("delegation  option")  do
    TIMES.times do
      s = Bar.new(CONTENT, Option.new)
      s.optional.to_s
    end
  end
  x.report("composition option")  do
    TIMES.times do
      s = Baz.new(CONTENT, Option.new)
      s.optional.to_s
    end
  end
end
