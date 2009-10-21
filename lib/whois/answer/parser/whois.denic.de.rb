#
# = Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
#
# Category::    Net
# Package::     Whois
# Author::      Aaron Mueller <mail@aaron-mueller.de>, Simone Carletti <weppos@weppos.net>
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

        register_method :disclaimer do
          ast['Disclaimer']
        end

        register_method :domain do
          ast['Domain']
        end

        register_method :domain_id do
          nil
        end

        register_method :status do
          ast['Status']
        end

        register_method :registered? do
          !(ast['NotFound'] || ast['Invalid'])
        end

        register_method :available? do
          ast['NotFound'] && !ast['Invalid']
        end

        register_method :created_on do
          nil
        end

        register_method :expires_on do
          nil
        end

        register_method :updated_on do
          ast['Changed'] ? Time.parse(ast['Changed']) : nil
        end

        register_method :registrar do
          return nil unless ast['Zone-C']
          Answer::Registrar.new(
              :id => nil,
              :name => ast['Zone-C'].name,
              :organization => ast['Zone-C'].organization,
              :url => nil
          )
        end

        register_method :registrant do
          ast['Holder']
        end

        register_method :admin do
          ast['Admin-C']
        end

        register_method :technical do
          ast['Tech-C']
        end

        register_method :nameservers do
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
              parse_invalid ||
              parse_not_found ||
              parse_pair(@ast) ||
              parse_contact ||
              trim_newline ||
              error('Unexpected token')
            end

            def parse_disclaimer
              if @input.match?(/% Copyright \(c\) *\d{4} by DENIC\n/)
                @input.scan_until(/% Terms and Conditions of Use\n/)
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

            def parse_invalid
              if @input.match?(/% ".*" is not a valid domain name\n/)
                 @input.scan(/%.*\n/)
                 return @ast['Invalid'] = true
              end 
              @ast['Invalid'] = false
            end 

            def error(message)
              raise "#{message}: #{@input.peek(@input.string.length)}"
            end

        end

      end
    end
  end
end
