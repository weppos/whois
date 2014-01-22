#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'ostruct'


# SuperStruct is an enhanced version of the Ruby Standard library {Struct}.
#
# Compared with the original version, it provides the following additional features:
# * ability to initialize an instance from Hash
# * ability to pass a block on creation
#
class SuperStruct < Struct

  # Overwrites the standard {Struct} initializer
  # to add the ability to create an instance from a {Hash} of parameters.
  #
  # @overload initialize({ Symbol => Object })
  #   Initializes the object with a key/value hash.
  #   @param [{ Symbol => Object }] values
  #   @return [SuperStruct]
  # @overload initialize([ value1, value1, ... ])
  #   Initializes the object with given values.
  #   @param [Array] values
  #   @return [SuperStruct]
  # @overload initialize(value1, value1, ...)
  #   Initializes the object with given values.
  #   @return [SuperStruct]
  #
  # @yield  self
  #
  # @example
  #   attributes = { :foo => 1, :bar => "baz" }
  #   Struct.new(attributes)
  #   # => #<Struct foo=1, bar="baz">
  #
  def initialize(*args)
    if args.first.is_a? Hash
      initialize_with_hash(args.first)
    elsif args.size == 0
      super
    else
      raise ArgumentError
    end
    yield(self) if block_given?
  end

private

  def initialize_with_hash(attributes = {})
    attributes.each do |key, value|
      self[key] = value
    end
  end

end