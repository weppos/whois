require 'benchmark'

if ARGV[0].nil? || ARGV[0] == "current"
  $:.unshift(File.dirname(__FILE__) + '/../lib')
else
  require 'rubygems'
  gem 'whois', ARGV[0]
end

require 'whois'
require 'whois/record/parser/whois.nic.it'

TIMES = ARGV[1] || 100_000
BLANK, PRESENT = DATA.read.to_s.split("<!--more-->")

PBLANK   = Whois::Record::Parser::WhoisNicIt.new(Whois::Record::Part.new(BLANK, "whois.nic.it"))
PPRESENT = Whois::Record::Parser::WhoisNicIt.new(Whois::Record::Part.new(PRESENT, "whois.nic.it"))

Benchmark.bmbm do |x|
  x.report("supported with value") do
    TIMES.times do
      PPRESENT.created_on
    end
  end
  x.report("supported without value") do
    TIMES.times do
      PPRESENT.created_on
    end
  end
  x.report("not supported") do
    TIMES.times do
      PPRESENT.domain_id rescue nil
    end
  end

  Whois::Record::Parser::PROPERTIES.each do |property|
    x.report("property #{property}") do
      TIMES.times do
        PPRESENT.send(property) rescue nil
      end
    end
  end
end


__END__


*********************************************************************
* Please note that the following result could be a subgroup of      *
* the data contained in the database.                               *
*                                                                   *
* Additional information can be visualized at:                      *
* http://www.nic.it/cgi-bin/Whois/whois.cgi                         *
*********************************************************************

Domain:             google.it
Status:             ACTIVE
Created:            1999-12-10 00:00:00
Last Update:        2008-11-27 16:47:22
Expire Date:        2009-11-27

Registrant
  Name:             Google Ireland Holdings
  ContactID:        GOOG175-ITNIC
  Address:          30 Herbert Street
                    Dublin
                    2
                    IE
                    IE
  Created:          2008-11-27 16:47:22
  Last Update:      2008-11-27 16:47:22

Admin Contact
  Name:             Tsao Tu
  ContactID:        TT4277-ITNIC
  Organization:     Tu Tsao
  Address:          30 Herbert Street
                    Dublin
                    2
                    IE
                    IE
  Created:          2008-11-27 16:47:22
  Last Update:      2008-11-27 16:47:22

Technical Contacts
  Name:             Technical Services
  ContactID:        TS7016-ITNIC

Registrar
  Organization:     Register.it s.p.a.
  Name:             REGISTER-MNT

Nameservers
  ns1.google.com
  ns4.google.com
  ns2.google.com
  ns3.google.com
<!--more-->
Domain:             google.it
Status:             AVAILABLE
