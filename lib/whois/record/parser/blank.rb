#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base'


module Whois
  class Record
    class Parser

      # The Blank parser isn't a real parser. It's just a fake parser
      # that acts as a parser but doesn't provide any special capability.
      #
      # It doesn't register itself in the parser_registry,
      # it doesn't scan any string, it only exists to be initialized
      # in case a record needs to create a parser for a WHOIS server
      # not yet supported.
      #
      class Blank < Base

        Whois::Record::Parser::PROPERTIES.each do |method|
          define_method(method) do
            raise ParserNotFound, "Unable to find a parser for the server `#{part.host}'"
          end
        end

      end

    end
  end
end