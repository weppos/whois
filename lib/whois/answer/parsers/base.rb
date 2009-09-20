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


require 'strscan'
require 'time'
require 'whois/answer/contact'
require 'whois/answer/registrar'


module Whois
  class Answer
    module Parsers

      #
      # = Base Answer Parser
      #
      # This class is intended to be the base abstract class for all
      # server-specific parser implementations.
      #
      # == Available Methods
      #
      # The Base class is for the most part auto-generated via meta programming.
      # This is the reason why RDoc can't detect and document all available methods.
      #
      class Base

        @@allowed_methods = [
          :disclaimer,
          :domain, :domain_id,
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

        allowed_methods.each do |method|
          define_method(method) do
            raise NotImplementedError, "You should overwrite this method."
          end
        end

      end

    end
  end
end