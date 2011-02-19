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
      # = whois.cnnic.cn parser
      #
      # Parser for the whois.cnnic.cn server.
      #
      class WhoisCnnicCn < Base
        include Ast
        
        property_not_supported :disclaimer
        
        property_supported :domain do
          node('Domain Name') { |raw| raw.downcase }
        end
        
        property_not_supported :domain_id
        
        
        property_supported :status do
          content_for_scanner.scan(/Domain Status:\s+(.+)\n/).flatten
        end

        property_supported :available? do
          (content_for_scanner.strip == "no matching record")
        end

        property_supported :registered? do
          reserved? || !available?
        end


        property_supported :created_on do
          if content_for_scanner =~ /Registration Date:\s+(.+)\n/
            Time.parse($1)
          end
        end

        property_not_supported :updated_on

        property_supported :expires_on do
          if content_for_scanner =~ /Expiration Date:\s+(.+)\n/
            Time.parse($1)
          end
        end
        
        property_supported :registrar do
          if registered?
            sponsor = node("Sponsoring Registrar")
            Answer::Registrar.new(
              :id =>    sponsor,
              :name =>  sponsor,
            )
          end
        end

        property_supported :registrant_contact do
          contact("Registrant", Whois::Answer::Contact::TYPE_REGISTRANT) unless available?
        end

        property_supported :admin_contact do
          contact("Administrative", Whois::Answer::Contact::TYPE_ADMIN) unless available?
        end

        property_not_supported :technical_contact


        property_supported :nameservers do
          content_for_scanner.scan(/Name Server:(.+)\n/).flatten.map do |name|
            Answer::Nameserver.new(name.downcase)
          end
        end
        
        protected
        
          def parse
            Scanner.new(content_for_scanner).parse
          end
          
          def contact(element, type)
              Answer::Contact.new(
                :type         => type,
                :name         => node("#{element} Name"),
                :organization => node("#{element} Organization"),
                :email        => node("#{element} Email")
              )
          end
          
          def reserved?
            content_for_scanner.strip == "the domain you want to register is reserved"
          end
          
          class Scanner

            def initialize(content)
              @input = StringScanner.new(content)
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

              def parse_content
                parse_pair        ||
                parse_section     ||
                error("Unexpected token")
              end

              def trim_newline
                @input.scan(/\n/)
              end

              def parse_pair
                if @input.scan(/(.*?):(.*?)\n/)
                  key, value = @input[1].strip, @input[2].strip
                  @ast[key] = value
                else
                  false
                end
              end

              def parse_section
                if @input.scan(/([^:]*?)\n/)
                  section = @input[1].strip
                  content = parse_section_pairs ||
                            parse_section_items
                  @input.match?(/\n+/) || error("Unexpected end of section")
                  @ast[section] = content
                else
                  false
                end
              end

                def parse_section_items
                  if @input.match?(/(\s+)([^:]*?)\n/)
                    items = []
                    indentation = @input[1].length
                    while item = parse_section_items_item(indentation)
                      items << item
                    end
                    items
                  else
                    false
                  end
                end

                  def parse_section_items_item(indentation)
                    if @input.scan(/\s{#{indentation}}(.*)\n/)
                      @input[1]
                    else
                      false
                    end
                  end

                def parse_section_pairs
                  contents = {}
                  while content = parse_section_pair
                    contents.merge!(content)
                  end
                  if !contents.empty?
                    contents
                  else
                    false
                  end
                end

                  def parse_section_pair
                    if @input.scan(/(\s+)(.*?):(\s+)(.*?)\n/)
                      key = @input[2].strip
                      values = [@input[4].strip]
                      indentation = @input[1].length + @input[2].length + 1 + @input[3].length
                      while value = parse_section_pair_newlinevalue(indentation)
                        values << value
                      end
                      { key => values.join("\n") }
                    else
                      false
                    end
                  end

                    def parse_section_pair_newlinevalue(indentation)
                      if @input.scan(/\s{#{indentation}}(.*)\n/)
                        @input[1]
                      else
                        false
                      end
                    end

              def error(message)
                if @input.eos?
                  raise "Unexpected end of input."
                else
                  raise "#{message}: #{@input.peek(@input.string.length)}"
                end
              end
          end
        
      end
    end
  end
end
