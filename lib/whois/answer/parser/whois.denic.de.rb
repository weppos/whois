#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client.
#
#
# Category::    Net
# Package::     Whois
# Author::      Aaron Mueller <mail@aaron-mueller.de>
# License::     MIT License
#
#--
#
#++


require 'whois/answer/parser/base'


module Whois
  class Answer
    class Parser
      class WhoisDenicDe < Base

        def disclaimer
          ast['Disclaimer']
        end

        def domain
          ast['Domain']
        end

        def domain_id
          nil
        end

        def status
          ast['Status']
        end

        def registered?
          !ast['NotFound']
        end

        def available?
          ast['NotFound']
        end

        def created_on
          nil
        end

        def expires_on
          nil
        end

        def updated_on
          ast['Changed'] ? Time.parse(ast['Changed']) : nil
        end

        def registrar
          return nil unless ast['Zone-C']
          Answer::Registrar.new(
              :id => nil,
              :name => ast['Zone-C'].name,
              :organization => ast['Zone-C'].organization,
              :url => nil
          )
        end

        def registrant
          ast['Holder']
        end

        def admin
          ast['Admin-C']
        end

        def technical
          ast['Tech-C']
        end

        def nameservers
          ast['Nserver']
        end

        
        protected

          def ast
            @ast ||= parse
          end

          def parse
            Scanner.new(content.to_s).parse
          end


        class Scanner

          def initialize(content)
            @input = StringScanner.new(content.to_s)
          end

          def parse
            @ast = {}
            while !@input.eos?
              trim_newline  ||
              parse_content
            end
            @ast
          end

          private

            def trim_newline
              @input.scan(/\n/)
            end

            def parse_content
              parse_disclaimer ||
              parse_not_found ||
              parse_pair(@ast) ||
              parse_contact ||
              trim_newline ||
              error('Unexpected token')
            end

            def parse_disclaimer
              if @input.match?(/% Copyright \(c\)2008 by DENIC\n/)
                8.times { @input.scan(/%(.*)\n/) } # strip junk
                lines = []
                while @input.match?(/%/) && @input.scan(/%(.*)\n/)
                  lines << @input[1].strip unless @input[1].strip == ""
                end
                @ast['Disclaimer'] = lines.join(" ")
                true
              end
              false
            end

            def parse_pair(node)
              if @input.scan(/([^  \[]*):(.*)\n/)
                key, value = @input[1].strip, @input[2].strip
                if node[key].nil?
                  node[key] = value
                else
                  node[key].is_a?(Array) || node[key] = [node[key]]
                  node[key] << value
                end
                true
              else
                false
              end
            end

            def parse_contact
              if @input.scan(/\[(.*)\]\n/)
                contact_name = @input[1]
                contact = {}
                while parse_pair(contact)
                end
                @ast[contact_name] = Answer::Contact.new(
                    :id => nil,
                    :name => contact['Name'],
                    :organization => contact['Organisation'],
                    :address => contact['Address'],
                    :city => contact['City'],
                    :zip => contact['Pcode'],
                    :state => nil,
                    :country => nil,
                    :country_code => contact['Country'],
                    :phone => contact['Phone'],
                    :fax => contact['Fax'],
                    :email => contact['Email'],
                    :created_on => nil,
                    :updated_on => contact['Changed']
                )
                true
              else
                false
              end
            end

            def parse_not_found
              if @input.match?(/% Object "(.*)" not found in database\n/)
                6.times { @input.scan(/%(.*)\n/) } # strip junk
                return @ast['NotFound'] = true
              end
              @ast['NotFound'] = false
            end

            def error(message)
              raise "#{message}: #{@input.peek(@input.string.length)}"
            end

        end

      end
    end
  end
end
