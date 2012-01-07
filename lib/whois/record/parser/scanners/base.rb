#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


module Whois
  class Record
    class Parser
      module Scanners

        class Base

          class_attribute :tokenizers
          self.tokenizers = []

          def self.tokenizer(name, &block)
            define_method(name, &block)
          end


          def initialize(content)
            @input = StringScanner.new(content)
          end

          def parse
            # The temporary store.
            # Scanners may use this to store pointers, states or other flags.
            @tmp = {}

            # A super-simple AST store.
            @ast = {}

            tokenize until @input.eos?

            @ast
          end


          tokenizer :skip_empty_line do
            @input.skip(/^\n/)
          end

          tokenizer :skip_newline do
            @input.skip(/\n/)
          end

          tokenizer :scan_keyvalue do
            if @input.scan(/(.+?):(.*?)\n/)
              key, value = @input[1].strip, @input[2].strip
              if @ast[key].nil?
                @ast[key] = value
              else
                @ast[key] = [@ast[key]] unless @ast[key].is_a?(Array)
                @ast[key] << value
              end
            end
          end

          private

          def tokenize
            tokenizers.each do |tokenizer|
              return if send(tokenizer)
            end
            unexpected_token
          end

          def unexpected_token
            error!("Unexpected token")
          end

          def error!(message)
            raise ParserError, "#{message}: #{@input.peek(@input.string.length)}"
          end

        end

      end
    end
  end
end