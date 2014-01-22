#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2014 Simone Carletti <weppos@weppos.net>
#++


module Whois
  class Record
    module Scanners

      class Base

        class_attribute :tokenizers
        self.tokenizers = []

        def self.tokenizer(name, &block)
          define_method(name, &block)
        end


        attr_reader :settings

        def initialize(settings = nil)
          @settings = settings || {}
        end

        def parse(content)
          # The temporary store.
          # Scanners may use this to store pointers, states or other flags.
          @tmp = {}

          # A super-simple AST store.
          @ast = {}

          @input = StringScanner.new(content)
          tokenize until @input.eos?

          @ast
        end


        tokenizer :skip_empty_line do
          @input.skip(/^\n/)
        end

        tokenizer :skip_blank_line do
          @input.skip(/^[\s]*\n/)
        end

        tokenizer :skip_newline do
          @input.skip(/\n/)
        end

        # Scan a key/value pair and stores the result in the current target.
        # target is the global @ast if no '_section' is set, else '_section' is used.
        tokenizer :scan_keyvalue do
          if @input.scan(/(.+?):(.*?)(\n|\z)/)
            key, value = @input[1].strip, @input[2].strip
            target = @tmp['_section'] ? (@ast[@tmp['_section']] ||= {}) : @ast

            if target[key].nil?
              target[key] = value
            else
              target[key] = Array.wrap(target[key])
              target[key] << value
            end
          end
        end

      protected

        def _scan_lines_to_array(pattern)
          results = []
          while @input.scan(pattern)
            @input[1].strip
            results << @input[1].strip
          end
          results
        end

        def _scan_lines_to_hash(pattern)
          results = {}
          while @input.scan(pattern)
            results.merge! @input[1].strip => @input[2].strip
          end
          results
        end

        def _scan_keyvalues(pattern)
          results = []
          while @input.scan(/(.+?):(.*?)\n/)
            key, value = @input[1].strip, @input[2].strip
            if results[key].nil?
              results[key] = value
            else
              results[key] = Array.wrap(results[key])
              results[key] << value
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