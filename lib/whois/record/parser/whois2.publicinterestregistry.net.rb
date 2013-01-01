#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
# Copyright (c) 2012 Paul Makepeace <paul@badger.com>
#++


require 'whois/record/parser/base_afilias'


module Whois
  class Record
    class Parser

      # Parser for the whois2.publicinterestregistry.net server.
      # ICANN registrars use whois2.publicinterestregistry.net,
      # a whitelisted, non-rate-limited server.
      class Whois2PublicinterestregistryNet < BaseAfilias
      end

    end
  end
end
