#--
# Ruby Whois
#
# An intelligent pure Ruby WHOIS client and parser.
#
# Copyright (c) 2009-2012 Simone Carletti <weppos@weppos.net>
#++


require 'whois/record/parser/whois.pir.org.rb'


module Whois
  class Record
    class Parser

      # Parser for the <tt>whois.publicinterestregistry.net</tt> server.
      # Aliases the <tt>whois.pir.org</tt> parser.
      WhoisPublicinterestregistryNet = WhoisPirOrg

    end
  end
end
