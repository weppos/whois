#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2018 Simone Carletti <weppos@weppos.net>
#++


module Whois
  class Record

    # A single {Whois::Record} fragment. For instance,
    # in case of *thin server*, a {Whois::Record} can be composed by
    # one or more parts corresponding to all responses
    # returned by the WHOIS servers.
    #
    # A part is composed by a +body+ and a +host+.
    #
    # @attr [String] body The body containing the WHOIS output.
    # @attr [String] host The host which returned the body.
    #
    class Part < Struct.new(:body, :host)

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

  end
end
