#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/base_afilias'
require 'whois/record/scanners/whois.discount-domain.com'

module Whois
  class Record
    class Parser

      # Parser for the whois.discount-domain.com server.
      class WhoisDiscountDomainCom < BaseAfilias
      	include Scanners::Scannable

        self.scanner = Scanners::WhoisDiscountDomainCom


        
      end

    end
  end
end