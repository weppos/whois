#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
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

      @@registrable_methods = [
        :disclaimer,
        :domain, :domain_id,
        :referral_whois, :referral_url,
        :status, :registered?, :available?,
        :created_on, :updated_on, :expires_on,
        :registrar, :registrant, :admin, :technical,
        :nameservers,
      ]

      # Returns an array containing the name of all methods
      # that can be registered and should be implemented by
      # server-specific parsers.
      def self.registrable_methods
        @@registrable_methods
      end

      attr_reader :answer


      def initialize(answer)
        @answer = answer
      end

      def parsers
        @parsers ||= init_parsers
      end


      protected

        def method_missing(method, *args, &block)
          if Parser.registrable_methods.include?(method)
            if parsers.empty?
              raise ParserError, "Unable to select a parser because the answer is empty"
            elsif parser = select_parser(method)
              parser.send(method, *args, &block)
            else
              raise PropertyNotSupported, "Unable to find a parser for `#{method}'"
            end
          else
            super
          end
        end

        # Loops through all answer parts, for each parts tries to guess
        # the appropriate Whois::Answer::Parser::<parser> if it exists
        # and returns the final array of server-specific parsers.
        def init_parsers
          answer.parts.map { |part| self.class.parser_for(part) }
        end

        def select_parser(method)
          parsers.reverse.each do |parser|
            return parser if parser.method_registered?(method)
          end
          nil
        end


      def self.parser_for(part)
        parser_klass(part.host).new(part)
      end

      def self.parser_klass(host)
        file = "whois/answer/parser/#{host}"
        require file

        name = host_to_parser(host)
        Parser.const_get(name)

      rescue LoadError
        require "whois/answer/parser/blank"
        Parser::Blank
      end

      def self.host_to_parser(host)
        host.to_s.
          gsub(/\./, '_').
          gsub(/(?:^|_)(.)/)  { $1.upcase }
      end

    end

  end
end