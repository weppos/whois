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


require 'whois/answer/parser/base'


module Whois
  class Answer
    class Parser

      #
      # = Blank parser
      #
      # The Blank parser isn't a real parser. It's just a fake parser
      # that acts as a parser but doesn't provide any special capability.
      # It doesn't register itself in the parser_registry, it doesn't scan any string,
      # it only exists to be initialized in case an answer needs to create a parser
      # for a whois server not supported yet.
      #
      class Blank < Base

        Whois::Answer::Parser::PROPERTIES.each do |method|
          define_method(method) do
            raise ParserNotFound, "Unable to find a parser for the server `#{part.host}'"
          end
        end

      end

    end
  end
end