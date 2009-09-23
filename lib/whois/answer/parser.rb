#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client.
#
#
# Category::    Net
# Package::     Whois
# Author::      Simone Carletti <weppos@weppos.net>
# License::     MIT License
#
#--
#
#++


module Whois
  class Answer

    #
    # = Parser
    #
    class Parser

      @@allowed_methods = [
        :disclaimer,
        :domain, :domain_id,
        :referral_whois, :referral_url,
        :status, :registered?, :available?,
        :created_on, :updated_on, :expires_on,
        :registrar, :registrant, :admin, :technical,
        :nameservers,
      ]

      def self.allowed_methods
        @@allowed_methods
      end

      attr_reader :answer

   
      def initialize(answer)
        @answer = answer
      end

      def parsers
        @parsers ||= init_parsers
      end


      protected


        # FIXME: only for now, forwards the request to the first parser.
        # This is the standard behaviour of the previous implementation.
        def method_missing(method, *args, &block)
          if parsers.empty?
            super
          else
            parsers.first.send(method, *args, &block)
          end
        end

        # Loops through all answer parts and initializes a parser
        # for any available part.
        def init_parsers
          answer.parts.map { |part| parser_for(part) }
        end

        def parser_for(part)
          self.class.parser_klass(part.host).new(part)
        end


      def self.parser_klass(host)
        file = "whois/answer/parser/#{host}.rb"
        require file

        name = host_to_parser(host)
        Parser.const_get(name)

      rescue LoadError
        raise ParserNotFound,
          "Unable to find a parser for the server `#{host}'"
      end

      def self.host_to_parser(host)
        host.to_s.
          gsub(/\./, '_').
          gsub(/(?:^|_)(.)/)  { $1.upcase }
      end

    end

  end
end