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


require 'strscan'


module Whois
  class Answer
    class Parser

      # The Ast module tries to emulate a super-simple Abstract Syntax Tree structure
      # including method for accessing ast nodes.
      #
      # == Usage
      #
      # Include the Ast module and provide a <tt>parse</tt> instance method.
      # <tt>parse</tt> should returns a Hash representing the AST.
      #
      #   def parse
      #     Scanner.new.parse
      #   end
      #   # => { "created_on" => "2009-12-12", ... }
      #
      # Now you can access the AST using the <tt>node</tt> method.
      #
      #   node "created_on"
      #   # => "2009-12-12"
      #
      #   node? "created_on"
      #   # => true
      #
      #   node? "created_at"
      #   # => false
      #
      module Ast

        def ast
          @ast ||= parse
        end

        def node(key, &block)
          if block_given?
            value = ast[key]
            value = yield(value) unless value.nil?
            value
          else
            ast[key]
          end
        end

        def node?(key)
          !ast[key].nil?
        end

      end

    end
  end
end