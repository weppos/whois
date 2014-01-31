# Changelog


## Release 3.4.4

- CHANGED: Updated IBC parser and fixtures (.IO, .AC, .SH and .TM).

- CHANGED: Backported several fixture updates.

- CHANGED: Updated whois.pir.org parser to the new response format (GH-300). [Thanks @muffinista]


## Release 3.4.3

- SERVER: Updated .COM, .NET, .CC, .WS TLD definitions.

- FIXED: .HK domains not correctly identified as available (GH-290).

- CHANGED: Updated whois.nic.tv parser to the new response format (GH-283).

- CHANGED: Updated Verisign parsers, extract common parser.

- CHANGED: Updated whois.markmonitor.com parser to the new response format.

- CHANGED: Updated Cocca parsers to the new response format (GH-291).

- CHANGED: Updated whois.nic.dz parser to the new response format.

- CHANGED: Updated whois.rotld.ro parser to the new response format.

- CHANGED: Updated whois.pnina.ps parser to the new response format.

- CHANGED: Updated whois.nic.gl parser to the new response format.


## Release 3.4.2

- CHANGED: Updated whois.registry.net.za parser to the new response format.

- CHANGED: Updated whois.ascio.com parser to the new response format (GH-285). [Thanks @takama]


## Release 3.4.1

- SERVER: Updated .XN--NGBC5AZD IDN TLD definition.

- NEW: whois.whois.kenic.or.ke parser now recognizes invalid status.

- NEW: Added whois.tucows.com parser (GH-260). [Thanks @takama]

- NEW: Added whois.wildwestdomains.com parser (GH-271). [Thanks @gromnsk]

- NEW: Added whois.pairnic.com parser (GH-275). [Thanks @gromnsk]

- NEW: Added whois.1und1.info parser (GH-278). [Thanks @gromnsk]

- FIXED: whois.dk-hostmaster.dk crashes when the status is `reserved` (GH-281). [Thanks @Pietr]

- CHANGED: Updated whois.nic.hu parser to the new response format.

- CHANGED: Updated whois.networksolutions.com parser to the new response format (GH-280). [Thanks @takama]

- CHANGED: Updated whois.gandi.net parser to the new response format.


## Release 3.4.0

- SERVER: Added .XN--MGBX4CD0AB (.ایران, Iran) IDN TLD definition.

- SERVER: Updated .NU (GH-265), .NU (GH-229), .ME, .SE TLD definition.

- SERVER: Added .XN--UNUP4Y (.游戏), .XN--NGBC5AZD (.شبكة), .XN--80ASEHDB (.онлайн), .XN--80ASWG (сайт) IDN TLD definitions.

- SERVER: Updated .XN--J1AMH (.укр) IDN TLD definition.

- NEW: Scanners now accepts customizable settings.

- NEW: Added whois.yoursrs.com parser (GH-266). [Thanks @takama]

- NEW: Added whois.ascio.com parser (GH-262). [Thanks @takama]

- NEW: Added whois.rrpproxy.net parser (GH-259). [Thanks @takama]

- NEW: Added whois.schlund.info parser (GH-270). [Thanks @takama]

- NEW: Added whois.udag.net parser (GH-272). [Thanks @gromnsk]

- NEW: Added whois.nic.bj parser (GH-6).

- FIXED: whois.dns.be crashes when the status is `not allowed`.

- FIXED: whois.nic.io crashes when the domain is reserved.

- FIXED: whois.gandi.net crashes with some domains.

- CHANGED: Changed .NU TLD to the new response format and parser (GH-265).

- CHANGED: Changed .SE TLD to the new response format and parser.

- CHANGED: Updated whois.register.com parser to the new response format (GH-273). [Thanks @gromnsk]


## Release 3.3.1

- SERVER: Updated .KR, .ES (GH-267) TLD definitions.

- NEW: Added whois.nic.es parser (GH-267). [Thanks @takama]

- NEW: Added whois.gandi.net parser (GH-261). [Thanks @takama]

- CHANGED: Updated whois.enom.com parser to the new response format (GH-269). [Thanks @takama]


## Release 3.3.0

- SERVER: Added .CF TLD definition.

- NEW: Added whois.dot.cf parser.

- NEW: Added support for ASN queries (GH-243). [Thanks @linrock]

- FIXED: Added contact support for whois.nic.ch (GH-246). [Thanks @Pietr]

- CHANGED: Deprecated Whois.query. Replaced with Whois.lookup to match client. Fixed README to use Whois.whois instead of Whois.lookup

- FIXED: whois.nic.lk crashes when the update date is `null`.

- FIXED: whois.cira.ca should support `pending delete` status.

- FIXED: whois.fi should support `Grace Period` status (GH-252). [Thanks @Pietr]

- FIXED: additional status for whois.ua (GH-244). [Thanks @Pietr]

- FIXED: whois.jprs.jp should support `Registered` status (GH-253). [Thanks @Pietr]


## Release 3.2.1

- NEW: Added full whois.nic.tr parser.

- CHANGED: Updated whois.nic.hn parser to the new response format.

- CHANGED: Updated whois.nic.as parser to the new response format.

- CHANGED: Updated whois.nic.mg parser to the new response format.

- CHANGED: Updated whois.nic.cd parser to the new response format.

- CHANGED: Updated whois.je parser to the new response format.

- CHANGED: Updated whois.gg parser to the new response format.

- CHANGED: Updated whois.pnina.ps parser to the new response format.

- CHANGED: Deprecate Whois::Record::Contact::TYPE_ADMIN in favor of Whois::Record::Contact::TYPE_ADMINISTRATIVE


## Release 3.2.0

- SERVER: Added .JP.NET (GH-240), XN--J1AMH TLD definitions.

- NEW: Added #domain_id to CoCCA parsers.

- NEW: Added full whois.srs.net.nz parser.

- NEW: Added full whois.fi parser.

- NEW: whois.dns.pl parser now recognizes throttled responses.

- CHANGED: Updated whois.nic.ac, whois.nic.io, and whois.nic.sh parsers to the new response format (GH-238).

- CHANGED: Updated whois1.nic.bi parser to the new response format.

- CHANGED: Updated whois.norid.no parser to the new response format.

- FIXED: whois.jprs.jp crashes when status is `reserved` for ne.jp SLD.

- FIXED: Arin adapter is incorrectly passing an Arin flag to referral queries.


## Release 3.1.3

- SERVER: Updated .GD (GH-227), .TC (GH-228) TLD definitions.

- NEW: Added full whois.meridiantld.net parser (GH-228).

- NEW: Added full whois.nic.gd parser (GH-227).

- CHANGED: whois.nic.it status is :unavailable when the whois status is `unassignable`

- FIXED: whois.denic.de parser crashes when error 55000000010

- FIXED: whois.nic.it crashes when status is `reserved` (GH-233).

- FIXED: whois.ua is mixing two kinds of responses (GH-235).


## Release 3.1.2

- NEW: Added full whois.comlaude.com parser (GH-222). [Thanks @delwyn] 

- NEW: Added #domain, #domain_id to whois.tcinet.ru.

- NEW: Added full whois.eu parser (GH-223). [Thanks @delwyn]

- FIXED: ARIN queries required additional params (GH-220, GH-10). [Thanks @linrock]

- FIXED: Fixed ARPA Reverse DNS lookup.

- FIXED: whois.nic.uk should support status `no longer required` (GH-225).

- FIXED: whois.rotld.ro should support status `UpdateProhibited` (GH-224).

- FIXED: whois.nic.fr parser crashes when the contact has no changed attribute (GH-226).


## Release 3.1.1

- FIXED: Fixed CLI crash (GH-219). [Thanks @linrock]


## Release 3.1.0

- SERVER: Added .POST (GH-192) TLD definition.

- SERVER: Updated .BN (GH-214), .SY (GH-196) TLD definitions.

- NEW: Added #domain and #registrar to whois.dns.be parser (GH-216). [Thanks @chuckadams]

- NEW: Added full whois.dotpostregistry.net parser (GH-192).

- NEW: Added full whois.tld.sy parser (GH-196).

- NEW: Added whois.bn parser (GH-214).

- CHANGED: Rescue all SystemCallError instead of a few Errno errors (GH-212). [Thanks @mat813]

- CHANGED: Removed deprecated method Whois::Client#query.

- CHANGED: Removed deprecated initialization of SuperStruct via Array.

- FIXED: whois.ua should support status `ok`.

- FIXED: whois.registry.net.za crashes when the registrant doesn't have a name.

- FIXED: whois.dns.pl crashes when expiration date is not defined.

- FIXED: Handle ReferralServer directive in ARIN whois queries (GH-204, GH-37). [Thanks @linrock]

- FIXED: Record#technical_contact raised a NoMethodError (GH-217). [Thanks @yspro]


## Release 3.0.0

- SERVER: Added .AX TLD definition.

- SERVER: Updated .AZ, .BA, .CO.ZA, .FM, .MC, .HN, .PH, .PW, .RW, .SA, .TD, .COM.UY, .VN TLD definitions.

- SERVER: Added .XN--MGBX4CD0AB (.مليسيا, Malaysia) IDN TLD definition.

- SERVER: Removed .XN--MGBA3A4F16A IDN TLD definition.

- NEW: ruby-whois learned the -h option to pass whois hostname on the fly

- NEW: Ability to pass a custom query_handler to the Server adapter (GH-189)

- NEW: Added full whois.nic.pw parser.

- NEW: Support for non-deep querying (GH-112)

- NEW: Added full whois.dns.pl parser.

- NEW: kero.yachay.pe parser now recognizes throttled responses.

- NEW: Added whois.ax parser.

- NEW: whois.eu parser now recognizes throttled responses.

- NEW: Added full whois.nic.us parser.

- NEW: Added full whois.nic.travel parser.

- NEW: Added full whois.nic.tel parser.

- CHANGED: Dropped support for Ruby 1.8

- CHANGED: Renamed Whois::Record::Scanners::Ast to Renamed Whois::Record::Scanners::Scannable

- CHANGED: Definitions are now stored as JSON.

- CHANGED: Updated whois.nic.af parser to the new response format.

- CHANGED: Updated whois.nic.cx parser to the new response format.

- CHANGED: Updated whois.nic.gs parser to the new response format.

- CHANGED: Updated whois.nic.ht parser to the new response format.

- CHANGED: Updated whois.nic.ki parser to the new response format.

- CHANGED: Updated whois.nic.mu parser to the new response format.

- CHANGED: Updated whois.nic.net.nf parser to the new response format.

- CHANGED: Updated whois.nic.net.sb parser to the new response format.

- CHANGED: Updated whois.nic.tl parser to the new response format.

- CHANGED: Updated whois.registry.gy parser to the new response format.

- CHANGED: Updated whois.cmc.iq parser to the new response format.

- CHANGED: Updated whois.na-nic.com.na parser to the new response format.

- CHANGED: Updated whois.nic.net.ng parser to the new response format.

- CHANGED: Whois::Server#query renamed to Whois::Server#lookup

- CHANGED: :referral_whois and :referral_url no longer exist as properties.

- CHANGED: Removed parser aliases.

- CHANGED: Removed deprecated options[:web] for :web adapter.

- CHANGED: Updated whois.nic.pr parser to the new response format.

- CHANGED: Updated whois.sx parser to the new response format.

- CHANGED: Updated whois.cnnic.cn parser to the new response format.

- CHANGED: Updated whois.thnic.co.th parser to the new response format (GH-194). [Thanks @ATimofeev]

- CHANGED: Updated whois.nic.ms parser to the new response format.

- CHANGED: whois.coza.net.za became whois.registry.net.za (GH-191). [Thanks @rorymckinley]

- CHANGED: Definitions are now stored as JSON.

- CHANGED: Deprecate Whois::Client#query in favor of Whois::Client#lookup

- CHANGED: Renamed Whois::Record#property_supported? and Whois::Record::Parser#property_supported? to #property_any_supported?

- CHANGED: Renamed Whois::PropertyNotSupported to Whois::AttributeNotSupported.

- CHANGED: Renamed Whois::PropertyNotImplemented to Whois::AttributeNotImplemented.

- FIXED: whois.domainregistry.ie should support status `Active - LOCKED`.

- FIXED: whois.nic.uk fails to parse registrars without URL (GH-188).

- FIXED: whois.nic.cz should support status `To be deleted`.

- FIXED: whois.nic.cz should support multiple status (GH-190).

- FIXED: whois.nic.lk crashes when the creation date is 'null'.

- FIXED: whois.domainregistry.ie may return a contact entry with no details.

- FIXED: whois.jprs.jp should support status `Deleted`.

- FIXED: whois.nic.kz crashes when last update date is blank.

- FIXED: whois.nic.cz crashes when keyset node is present in the whois response.

- FIXED: whois.nic.cz crashes when nsset node has the same ID of a contact.

- FIXED: whois.register.com fails to parse name servers in some cases (GH-207). [Thanks @stormsilver]

- FIXED: whois.nc crashes when the address is missing the state.

- FIXED: Whois::Record#respond_to? doesn't recognize property? of method? methods.


### Backward Incompatibilities

- Removed compatibility with Ruby 1.8

- Renamed Whois::Record::Scanners::Ast to Renamed Whois::Record::Scanners::Scannable

- Whois::Server#query has been renamed to Whois::Server#lookup

- :referral_whois and :referral_url no longer exist as properties.
  The parsers where the propertie was supported still supports the property
  by providing a corresponding method.

  However, you cannot call the method on the response anymore.
  Instead, you have to invoke the method directly on the parser instance.

- The exceptions raised in case of not supported property changed from -> to
  - Whois::PropertyNotSupported -> Whois::AttributeNotSupported
  - Whois::PropertyNotImplemented -> Whois::AttributeNotImplemented
  - Whois::PropertyNotAvailable -> Whois::AttributeNotImplemented


## Release 2.7.0

- SERVER: Added .IQ TLD server (GH-171).

- SERVER: Added .XN--MGB9AWBF (عمان, Oman) IDN TLD server.

- SERVER: Added .BI TLD server (GH-113).

- SERVER: Added .DM TLD server (GH-43).

- SERVER: Added .MO TLD server.

- NEW: Added full whois.register.com parser.

- NEW: whois.networksolutions.com parser now recognizes throttled responses (GH-182). [Thanks @JustinCampbell]

- NEW: Added full whois.cmc.iq parser (GH-171).

- NEW: Added full whois1.nic.bi parser (GH-113).

- NEW: Added full whois.nic.dm parser (GH-43).

- NEW: Added full whois.nic.co parser.

- NEW: Added full whois.monic.mo parser.

- FIXED: Fixed whois.register.com parser for enom formats (GH-181). [Thanks @JustinCampbell]

- FIXED: whois.jprs.js parser should support status `Suspended`.

- FIXED: whois.dk-hostmaster.dk parser should support status `Deactivated`.

- FIXED: whois.domain-registry.nl parser should support status `Inactive`.

- CHANGED: Changed .NAME to a formatted adapter to fetch additional properties.

- CHANGED: whois.dns.pl now supports expires_on (GH-185). [Thanks @y3ti]


## Release 2.6.4

- SERVER: Added .CW TLD server.

- SERVER: Updated .GR, .ORG (GH-176), .FO (GH-177) TLD server.

- SERVER: Added .XN--MGBA3A4F16A (ایران., Iran) IDN TLD server.

- NEW: Ability to specify a custom :adapter passing a Symbol instead of an instance of Class.

- NEW: Added full whois.nic.fo parser (GH-177).

- NEW: whois.nic.cz is now a full parser.

- NEW: whois.tld.ee is now a full parser.

- NEW: whois.tznic.or.tz is now a full parser.

- FIXED: whois.neworksolutions.com parser crashes when the contact name is blank.

- FIXED: whois.rnids.rs parser should support statuses Locked, Expired, and In Transfer.

- FIXED: whois.nic.gs parser should support status `Excluded - Pending Delete - Restorable` (GH-180). [Thanks @smith]

- CHANGED: Deprecated options[:web] for :web adapter in favor of options[:url].

- CHANGED: Removed Pir adaper, the registry is a thick whois server.

- CHANGED: Changed whois.publicinterestregistry.com to whois.pir.org (GH-176).

- CHANGED: whois.tcinet.ru parser learned how to parse contact URLs (GH-150).

- CHANGED: Removed support for .gemtest and removed /spec folder from the packaged gem.


## Release 2.6.3

- NEW: whois.registrypro.pro is now a full parser.

- FIXED: In some cases the parser class is not correctly detected from hostname (GH-173). [Thanks @JustinCampbell]

- FIXED: whois.ua parser raises ArgumentError when the created_on object invalid data.

- FIXED: Whois::Server may occasionally raise an error trying to resolve an IPv6 matching query object (GH-174). [Thanks @aeden].

- CHANGED: Updated whois.registrypro.pro parser to the new response format.


## Release 2.6.2

- SERVER: Added .SX TLD server (GH-170).

- NEW: Added full whois.networksolutions.com parser (GH-168). [Thanks @bramp]

- NEW: Added full whois.sx parser (GH-170).

- NEW: whois.ua parser is now a full parser (GH-169). [Thanks @Uko]


## Release 2.6.1

- Reverted partial commit about .SX definitions included in v2.6.0 by mistake.


## Release 2.6.0

- SERVER: Added .OM TLD server.

- SERVER: Added .TN TLD server.

- NEW: whois.srs.net.nz parser now recognizes throttled responses.

- NEW: Added full whois.registry.om parser.

- NEW: Added full whois.ati.tn parser.

- NEW: Added full whois.educause.edu parser.

- NEW: Implement registrar property for CoCCA (GH-165). [Thanks @sherwind]

- CHANGED: whois.nic.uk changed response format.

- CHANGED: whois.nic.gl now inherits from CoCCA and learns new properties (GH-166). [Thanks @sherwind]

- CHANGED: Deprecate SuperStruct initialization with list of params.

- FIXED: whois.hkirc.hk parser crashes when expiration date is "null".

- FIXED: whois.na-nic.com.na parser fails to support 'Delegate' status (GH-159). [Thanks @sherwind]

- FIXED: whois.rnids.rs parser crashes when domain is private (GH-163). [Thanks @sherwind]

- FIXED: whois.rnids.rs parser not to split nameserver name at the hypen (GH-164). [Thanks @sherwind]

- FIXED: whois.co.ug parser fails to support 'Unconfirmed' status.

- FIXED: whois.cctld.uz parser crashes when expiration date is dash (GH-161). [Thanks @sherwind]

- FIXED: whois.cctld.uz parser fails to support 'RESERVED' status (GH-162). [Thanks @sherwind]

- FIXED: whois.tznic.or.tz parser fails to support 'Expired' status (GH-160). [Thanks @sherwind]


## Release 2.5.1

- FIXED: whois.enom.com parser crashes when the contact has no name.

- FIXED: whois.domainregistry.ie parser crashes when there is a pending application token for the domain.

- FIXED: whois.domainregistry.ie parser should support multiple contacts.

- FIXED: whois.dns.be now uses "not available" and "available" statuses.

- FIXED: whois.cnnic.cn scanner fails to recognize some reserved domains.

- FIXED: whois.nic.uk fails to recognize "registered until expiry date" status.


## Release 2.5.0

- SERVER: Added .BY (GH-154) TLD server.

- NEW: Added full whois.audns.net.au parser.

- NEW: Added full whois.cctld.by parser (GH-154). [Thanks @kliuchnikau]

- NEW: Added full whois.domainregistry.ie parser.

- NEW: Added full whois.cira.ca parser.

- NEW: Added whois.enom.com parser.

- CHANGED: Moved scanners from Whois::Record::Parser::Scanners to Whois::Record::Scanners.

- FIXED: .IE availability checking returns incorrect results (GH-155)


## Release 2.4.0

- SERVER: Removed .KP (GH-52), .GP (GH-44) TLD servers.

- SERVER: Updated .CV, .FI (GH-133), .GF, .MQ, .UA (GH-153), .XN-MGBAYH7GPA, .XN--FZC2C9E2C, .XN--XKC2AL3HYE2A TLD servers.

- SERVER: Added the following new IDN TLD servers:
    - .XN--80AO21A (.ҚАЗ, Kazakhstan)

- SERVER: Updated ipv4 allocations.

- SERVER: Added .RS, .LK, .HR (GH-122), .NC (GH-109) TLD servers.

- NEW: Added full whois.dreamhost.com parser.

- NEW: Added ability to check for an unavailable response with Whois::Record#response_unavailable?.

- NEW: whois.nic.uk now understands reserved domains.

- NEW: Added full whois.rnids.rs parser.

- NEW: Added full whois.nic.lk parser.

- NEW: Added full whois.dns.hr parser (GH-122).

- NEW: Added full whois.nc parser (GH-109).

- CHANGED: Placed "core_ext" under "whois" namespace (GH-149).

- CHANGED: Whois::Client#query is no longer case sensitive (GH-151).

- FIXED: whois.nic.gl parser must support `Delegate' status.

- FIXED: whois.godaddy.com partially changed response format (GH-148).

- FIXED: whois.registry.qa parser crashes when the response doesn't contain nameserver IPs.

- FIXED: whois.nic.mg parser must support `Delegate' status.

- FIXED: whois.nic.it parser must support `pendingUpdate` status.

- FIXED: whois.nic.it parser must support `PENDING-DELETE' status.


## Release 2.3.0

- SERVER: .VA TLD no longer provides public WHOIS interface (GH-93).

- SERVER: Added Smallregistry FR TLDs (GH-144).

- NEW: whois.crsnic.net parser now recognizes unavailable responses.

- NEW: Added support for whois.educause.edu registrant contact field (GH-141).

- NEW: Added full whois.centralnic.com parser.

- NEW: Added full whois.nic.la parser.

- NEW: Added full whois.smallregistry.net parser (GH-144).

- NEW: whois.nic.net.nf now understands invalid responses.

- NEW: whois.nic.fr parser now recognizes throttled responses (GH-147).

- CHANGED: whois.nic.fr `frozen' status is now considered as :registered.

- CHANGED: Rewritten Whois::Record::Parser::Scanners::Base to use a modular approach.

- CHANGED: Renamed whois.domain-registry.nl :quarantine status to :redemption.

- FIXED: whois.nic.net.nt parser must support `Pending Purge' and `Pending Delete' status (GH-131).

- FIXED: whois.nic.fr crashes when contact is anonymous (GH-140).

- FIXED: whois.nic.fr parser must support `NOT_OPEN' status (GH-142).

- FIXED: whois.centralnic.com changed response format.

- FIXED: whois.jprs.jp parser must support `To be suspended' status.

- FIXED: whois.nic.fr parser raises 'struct size differs' trying to parse nameservers for some responses.

- FIXED: whois.nic.nu parser must support `NotRenewed' status.

- FIXED: whois.nic.lv changed response format (GH-145, GH-146).

- FIXED: whois.dns.be parser must support `quarantine' and `out of service' status (GH-147).


## Release 2.2.0

- NEW: Added base whois.nic.net.sb parser (GH-56).

- NEW: Added whois.nic.fr contact parsing.

- CHANGED: whois.nic.ve now returns `:inactive' instead of `:suspended'.

- CHANGED: whois.dns.pt now supports `expired_on` property.

- FIXED: whois.nic.ht parser must support `Delegated' status.

- FIXED: whois.nic.mu parser must support `Delegated' status.

- FIXED: whois.nic.ki parser must support `Delegated' status (GH-119).

- FIXED: whois.registry.gy parser must support `Delegated' status (GH-120).

- FIXED: whois.nic.cx parser must support `Delegated' status (GH-121).

- FIXED: With some .com.br domains, whois.registro.br parser returns invalid values for nameservers.

- FIXED: whois.nic.it parser should support `pendingTransfer / autoRenewPeriod' status (GH-124).

- FIXED: whois.nic.net.nf parser must support `Delegated' status (GH-125).

- FIXED: whois.nic.ms parser must support `Delegated' status (GH-126).

- FIXED: whois.nic.fr parser must support `BLOCKED' status (GH-127).

- FIXED: whois.nic.gs parser must support `Delegated' status (GH-128).

- FIXED: whois.nic.tl parser must support `Delegated' status.

- FIXED: whois.nic.net.ng parser must support `Delegated' status.

- FIXED: whois.na-nic.com.na parser must support `Suspended' status (GH-130).

- FIXED: whois.dns.pt parser must support `TECH-PRO' status (GH-132).

- FIXED: whois.nic.net.nf parser must support /pending delete/ status (GH-131).

- FIXED: whois.nic.cz IPv6 nameserver support (GH-135).

- FIXED: whois.je changed response format (GH-123).


## Release 2.1.1

- NEW: whois.nic.xxs parser now recognizes reserved domains.

- NEW: whois.nic.uk parser now recognizes throttled responses (GH-118). [Thanks @semaperepelitsa]

- NEW: whois.nic.uk parser now extracts registrant_contacts (GH-118). [Thanks @semaperepelitsa]

- FIXED: whois.nic.it parser doesn't correctly understand reserved domains.

- FIXED: Release 2.1.0 is not compatible with Rails 2.3 (GH-117).

- FIXED: whois.nic.coop should support multiple statuses (GH-115).

- FIXED: whois.nic.la should support multiple statuses (GH-116).


## Release 2.1.0

- SERVER: Added .COM.DE, .GR.COM, .US.ORG TLD definitions.

- SERVER: Updated .QA and .XN--WGBL6A TLD definitions.

- SERVER: Updated .SU, .RU and .XN--P1AI TLD definitions (GH-87).

- SERVER: Added the following new IDN TLDs:
    - .XN--LGBBAT1AD8J (.الجزائر, Algeria) (GH-95)
    - .XN--MGBC0A9AZCG (.المغرب, Morocco) (GH-96)

- NEW: Ability to define inheritable parsers

      class Whois::Record::Parser::Afilias < Whois::Record::Parser::Base
      end

      class Whois::Record::Parser::WhoisNicXxx < Whois::Record::Parser::Afilias
      end

  Parsers will inherits all the properties from their parents.

- NEW: Added the following full parsers:
    - whois.nic.asia
    - whois.meregistry.net
    - whois.dotmobiregistry.net
    - whois.publicinternetregistry.net
    - whois.registry.in
    - whis.nic.ag
    - whois.afilias-grs.info
    - whois.aero
    - whois.nic.xx
    - whois.afilias.info
    - whois.registry.qa (GH-114)
    - whois.godaddy.com (GH-105) [Thanks @pmyteh]

- CHANGED: use the first public .XXX domain to test the whois.nic.xx response format.

- CHANGED: whois.sgnic.sg changed nameservers response format (again).

- CHANGED: Extended core_ext section. Since all the extensions belong to ActiveSupport,
  the library attempts to use ActiveSupport if loaded.

- CHANGED: Renamed whois.ripn.net to whois.tcinet.ru (GH-87)

- FIXED: In a very rare situation the Whois::Client raises a
  `Errno::EINVAL: Invalid argument - bind(2)' error attempting to connect
  to a WHOIS server (see GH-40).

- FIXED: whois.nic.travel parser must support multiple statuses.

- FIXED: whois.nic.name parser must support multiple statuses.

- FIXED: whois.nic.af parser must support `Delegated' status.

- REMOVED: Removed deprecated Whois::Answer class.

- REMOVED: Removed deprecated Whois::Record### behavior.

- REMOVED: Removed deprecated Whois::Record::Parser::WhoisTonicTo#incomplete_response? method.


## Release 2.0.7

- CHANGED: whois.dns.pt changed nameservers response format.

- CHANGED: whois.sgnic.sg changed nameservers response format.

- FIXED: whois.markmonitor.com parser crashes when the contacts are empty.

- FIXED: whois.educause.edu parser crashes when the updated_on property is `unknown'.


## Release 2.0.6

- CHANGED: whois.gg changed response format.

- FIXED: whois.pnina.ps parser do not support `Active' status variants.

- FIXED: whois.sk-nic.sk parser must support `DOM_TA' status.

- FIXED: whois.srs.net.nz parser must support `210 PendingRelease' status.


## Release 2.0.5

- SERVER: Updated .BI TLD definition.

- SERVER: Added .XXX TLD definition.

- SERVER: Updated .SM TLD definition (GH-97).

- NEW: Ability to detect whois.dns.be throttled responses.

- NEW: Added base whois.nic.sm parser (GH-97).

- FIXED: whois.meregistry.net parser raises `no time information in ""'
  when updated_at property is blank.

- FIXED: whois.nic.it parser must support `NO-PROVIDER' status.

- FIXED: whois.nic.it parser must support `pendingDelete / pendingDelete' status.

- FIXED: whois.nic.asia parser must support `CLIENT' status.

- FIXED: whois.nic.cz parser must support `Update prohibited' status.

- FIXED: The Verisign WHOIS adapter crashes in some rare circumstances
  when the response from the Verisign database doesn't contain a
  referral (GH-103)

- FIXED: whois.eu parser changed the format of the nameserver property (GH-99). [Thanks @armins]

- FIXED: whois.nic.uk parser should return `:invalid' status when the domain is invalid.

- FIXED: whois.cira.ca parser must support `unavailable' status (GH-102).

- FIXED: whois.sk-nic.sk parser must support `DOM_EXP', `DOM_LNOT', `DOM_WARN' statuses.


## Release 2.0.4

- SERVER: Added the following new IDN TLDs:
    - .XN--90A3AC (.СРБ, Serbia) (GH-94)

- FIXED: whois.nic.it parser must support pendingUpdate and pendingTransfer statuses.

- FIXED: whois.nic-se.se crashes in some cases where the `modified:'
  attribute is an invalid date.


## Release 2.0.3

- SERVER: Sync definitions with Debian whois 5.0.11:
    - Added the remaining IPv4 allocations.
    - Updated the .gm TLD server.

- FIXED: Whois::Record::Parser::Base#validate! should raise
  a ResponseIsUnavailable error when response_unavailable?

- FIXED: whois.nic.it parser must support inactive / noRegistrar status.

- FIXED: whois.sk-nic.sk parser must support DOM_DAKT status.


## Release 2.0.2

- CHANGED: whois.ripn.net now returns an array of contacts, one for each email (GH-89). [Thanks @semaperepelitsa]

- FIXED: whois.nic.it parser must support UNASSIGNABLE status.


## Release 2.0.1

- FIXED: Removed invalid test files.


## Release 2.0.0

- SERVER: Added .AE.ORG, .AR.COM, .KR.COM TLD definitions (whois.centralnic.net).

- SERVER: Removed invalid .WEB.COM TLD definition (whois.centralnic.net).

- SERVER: Updated .EE TLD definition and corresponding parser (GH-64).

- SERVER: Sync definitions with Debian whois 5.0.10:
    - Added new IPv4 allocations.

- SERVER: Added the following 12 new IDN TLD:
    - .XN--WGBL6A (قطر, Qatar) (GH-63)
    - .XN--3E0B707E (한국, Korea, Republic of)
    - .XN--45BRJ9C (.ভারত, India)
    - .XN--FPCRJ9C3D (భారత్, India)
    - .XN--GECRJ9C (ભારત, India)
    - .XN--H2BRJ9C (भारत, India)
    - .XN--MGBBH1A71E (بھارت, India)
    - .XN--OGBPF8FL (سورية, Syrian Arab Republic)
    - .XN--S9BRJ9C (ਭਾਰਤ, India)
    - .XN--XKC2DL3A5EE0H (இந்தியா, India)
    - .XN--YFRO4I67O (新加坡, Singapore)
    - .XN--CLCHC0EA0B2G2A9GCD (சிங்கப்பூர், Singapore)

- SERVER: Changed .KR TLD definition to whois.kr.

- NEW: Added simple AE.ORG, AR.COM, BR.COM, CN.COM, DE.COM, EU.COM,
  GB.COM, GB.NET, HU.COM, JPN.COM, KR.COM, NO.COM, QC.COM, RU.COM,
  SA.COM, SE.COM, SE.NET, UK.COM, UK.NET, US.COM, UY.COM, WEB.COM,
  ZA.COM TLD parser (whois.centralnic.net).

- NEW: Added ability to bind a WHOIS query to a specific local address and port (GH-40).

- NEW: Added simple .SO TLD parser (whois.nic.so) (GH-57).

- NEW: Property memoization (GH-18)

- NEW: whois.ripn.net now supports #registrar and #admin_contact (GH-72).

- NEW: Added support for $ gem test and Gem Testers
  See http://www.engineyard.com/blog/2011/introducing-gem-testers/

- NEW: Whois::Answer::Nameserver#to_s returns the #name for BC with string-based nameservers.

- NEW: Added support for throttled response detection (GH-23, GH-54, GH-61)

- NEW: whois.registry.in now supports #registrar (GH-78).

- NEW: Added full whois.cnnic.cn parser (GH-77).

- NEW: Added full whois.cnnic.biz parser.

- NEW: Added full whois.afilias.info parser.

- NEW: Extracted Whois::Answer::Parser::Features and Extracted Whois::Answer::Parser::Scanners::Base.

- NEW: whois.nic.uk now supports #registrar (GH-81, GH-82). [Thanks @geoffgarside]

- NEW: Added simple whois.markmonitor.net parser (GH-83). [Thanks @semaperepelitsa]

- CHANGED: Renamed whois.centralnic.net to whois.centralnic.com (GH-28).

- CHANGED: Switched from RDoc to YARDoc (GH-3).

- CHANGED: Whois::Server::Adapter::Base### now returns false if other is not the same instance of self.

- CHANGED: Deprecated the comparison of Whois::Answer with String.

- CHANGED: Removed official support for Ruby 1.9.1.

- CHANGED: Renamed Whois::Server::Adapters::Base#append_to_buffer to buffer_append.

- CHANGED: Whois::Answer::Parser::Base#response_throttled? and Whois::Answer::Parser::Base#invalid?
  are not defined by default. Define the method in the implementation, 
  and Whois::Answer::Parser will automatically use it.

- CHANGED: Removed &block from method definition to avoid creating block objects when yield is used (GH-66)

- CHANGED: Renamed Whois::Answer::Parser::Base.register_property to Whois::Answer::Parser::Base.property_register.

- CHANGED: Whois::Answer::Parser creates a missing method the first time it is invoked to increase performance.

- CHANGED: whois.nic.it parser raises on invalid #status.

- CHANGED: Change #nameservers property to return an Array of Nameserver (GH-76, see GH-71, see GH-64).

- CHANGED: Whois#query no longer raises Errno or SocketError.
  The errors are now rescued and re-raised as Whois::ConnectionError.

- CHANGED: #admin_contact, #technical_contact and #registrant_contact
  have been renamed to #admin_contacts, #technical_contacts and #registrant_contacts
  and they now returns an array of Contact, instead of a single Contact.

- CHANGED: Migrated all tests to RSpec.

- CHANGED: Renamed Whois::Answer to Whois::Record and deprecate Whois::Answer class.

- FIXED: Converted #changed? and #unchanged? properties to methods
  and normalized their behavior.

- FIXED: Make sure a warning is issued when #registered? or #available? returns nil.

- FIXED: Fixed a bug with the whois.crsnic.net parser where the name server
  contains "no nameserver" instead of a valid host.

- FIXED: Fixed a bug which prevents a client to be created with nil timeout.

- FIXED: The very first time a Whois::Answer method/property question method is invoked,
  the corresponding method is called instead of the question one.

- FIXED: whois.cat parser must support multiple statuses.

- FIXED: whois.tld.ee parser must support :expired status.

- FIXED: whois.nic.fr parser must support :registered status.

- FIXED: whois.nic.cz parser must support :expired status.

- FIXED: With some .tr domains, whois.nic.tr parser returns invalid values for nameservers.

- FIXED: whois.isoc.org.il parser must support "transfer allowed" status.

- FIXED: Whois::Answer#respond_to? and Whois::Answer::Parser#respond_to?
  should keep METHODS and PROPERTIES into consideration.

- FIXED: whois.nic.fr parser must support "redemption" status.

- FIXED: whois.nic.it parser must support the following new statuses:
    - ok / *
    - client*
    - pendingDelete
    - GRACE-PERIOD

- FIXED: whois.nic.it parser doesn't set address state.

- FIXED: whois.cira.ca parser must support "to be released" status.

- FIXED: whois.sk-nic.sk parser must support "DOM_HELD" status.

### Backward Incompatibilities

- Whois::Server::Adapters::Base#append_to_buffer renamed to buffer_append.

- Whois#query no longer raises Errno::ECONNRESET, Errno::EHOSTUNREACH, Errno::ECONNREFUSED, SocketError.
  The errors are now rescued and re-raised as Whois::ConnectionError.

- #admin_contact, #technical_contact and #registrant_contact
  have been renamed to #admin_contacts, #technical_contacts and #registrant_contacts
  and they now returns an array of Contact, instead of a single Contact.
  #admin_contact, #technical_contact and #registrant_contact still exists
  in the Answer as a convenient shortcut.

- Renamed Whois::Answer::Parser::Base.register_property to
  Whois::Answer::Parser::Base.property_register.


## Release 1.6.6

- NEW: Backported whois.centralnic.net support from version 2.0.

- FIXED: whois.nic-se.se must support :inactive status.

- FIXED: whois.cira.ca must support "auto-renew grace" status.


## Release 1.6.5

- FIXED: whois.dns.pt must support :reserved status.

- FIXED: whois.cira.ca must support :redemption status as :registered.


## Release 1.6.4

- FIXED: With some .pl domains, whois.dns.pl parser returns invalid values for nameservers.

- FIXED: The whois.pnina.ps server injects a NODNS.NS string when a nameserver is not set.
  The parser should ignore it.

- FIXED: whois.nic.ve must support :suspended status.


## Release 1.6.3

- FIXED: whois.nic.kz doesn't recognize multiline status

- FIXED: jprs.jp domain parser bug with empty date fields (GH-60)


## Release 1.6.2

- SERVER: Updated the .sg TLD definition.

- SERVER: Updated the .th TLD definition.

- SERVER: Updated the .org.za TLD definition.

- NEW: Added simple .sg TLD parser (whois.sgnic.sg).

- NEW: Added .sh TLD parser (whois.nic.sh).

- NEW: Added simple .sk TLD parser (whois.sgnic.sg).

- NEW: Added simple .sl TLD parser (whois.nic.sl).

- NEW: Added simple .th TLD parser (whois.thnic.co.th).

- NEW: Added simple .tw TLD parser (whois.twnic.net.tw).

- NEW: Added simple .ac.uk, .gov.uk TLD parser (whois.ja.net).

- NEW: Added .org.za TLD parser (whois.org.za).

- NEW: Added simple .gov.za TLD parser (whois.gov.za).

- NEW: Added .co.za TLD parser (whois.coza.net.za).

- NEW: Added simple .ci TLD parser (whois.nic.ci). (GH-39)

- NEW: Added simple .gy TLD parser (whois.registry.gy). (GH-45)

- NEW: Added simple .hm TLD parser (whois.registry.hm). (GH-46)

- NEW: Added simple .pl TLD parser (whois.dns.pl).

- NEW: Added .co.pl TLD parser (whois.co.pl).

- NEW: Added simple .pr TLD parser (whois.nic.pr).

- FIXED: The CLI help message uses whois instead or ruby-whois.


## Release 1.6.1

- FIXED: Fixed unknown status `Inactive' for kero.yachay.pe.


## Release 1.6.0

- SERVER: Updated the .nc TLD definition.

- SERVER: Updated the .nf TLD definition.

- SERVER: Updated the .ng TLD definition.

- SERVER: Updated the .pe TLD definition.

- SERVER: Updated the .sb TLD definition.

- SERVER: Updated the .ki/.mu TLD definition.

- SERVER: Updated the .tf TLD definition.

- NEW: Added simple .mg TLD parser (whois.nic.mg).

- NEW: Added simple .ms TLD parser (whois.nic.ms).

- NEW: Added simple .ms TLD parser (whois.domainregistry.my).

- NEW: Added simple .na TLD parser (whois.na-nic.com.na).

- NEW: Added simple .nf TLD parser (whois.nic.net.nf).

- NEW: Added simple .ng TLD parser (whois.nic.net.ng).

- NEW: Added simple .pe TLD parser (kero.yachay.pe).

- NEW: Added simple .ps TLD parser (whois.pnina.ps).

- NEW: Added simple .ki TLD parser (whois.nic.ki).

- NEW: Added .tm TLD parser (whois.nic.tm).

- NEW: Added .tz TLD parser (whois.tznic.or.tz).

- CHANGED: Completed .md TLD parser (whois.nic.md).

- CHANGED: Completed .io TLD parser (whois.nic.io).

- FIXED: Fixed Unknown status `Registration request being processed.' for whois.nic.uk.

- FIXED: whois.nic.ve supports expires_on.

- FIXED: With some .uk domains, whois.nic.uk parser returns invalid values for nameservers.

- FIXED: whois.audns.net.au record can contain multiple statuses.


## Release 1.5.1

- NEW: Added simple .kg TLD parser (whois.domain.kg).

- NEW: Added .md TLD parser (whois.nic.md).

- FIXED: Fixed Unknown status `Renewal request being processed.' for whois.nic.uk.

- FIXED: With some .cz domains, whois.nic.cz parser returns invalid values for nameservers.


## Release 1.5.0

WARNING: Whois >= 1.5.0 requires Ruby 1.8.7 or newer.

- CHANGED: Ruby 1.8.7 or newer is required.

- FIXED: Fixed Unknown status `CLIENT DELETE PROHIBITED' for whois.registry.in.

- REMOVED: Remove deprecated Whois::Answer::Parser::Base methods:
  - #registrant
  - #admin
  - #technical

- REMOVED: Remove deprecated Whois::Answer::Part#response property.


## Release 1.3.10

- CHANGED: Standardized #status property for the following parsers (GH-5)
  - whois.aero
  - whois.aeda.net.ae
  - whois.audns.net.au
  - whois.cat
  - whois.cctld.uz
  - whois.co.ug
  - whois.denic.de
  - whois.dk-hostmaster.dk
  - whois.dns.be
  - whois.dns.lu
  - whois.dns.pt
  - whois.domainregistry.ie
  - whois.in.ua
  - whois.jprs.jp
  - whois.net.ua
  - whois.nic-se.se
  - whois.nic.am
  - whois.nic.asia
  - whois.nic.at
  - whois.nic.coop
  - whois.nic.fr
  - whois.nic.ht
  - whois.nic.kz
  - whois.nic.la
  - whois.nic.mu
  - whois.nic.nu
  - whois.nic.org.uy
  - whois.nic.travel
  - whois.nic.uk
  - whois.nic.ve
  - whois.norid.no
  - whois.register.bg
  - whois.registry.in
  - whois.rotld.ro
  - whois.srs.net.nz

- FIXED: Property cache is missing for some parsers (GH-18)

- FIXED: In some circumstances the whois.jprs.js parser may raise 
  an Argument out of range error trying to parse the #updated_on property.

- FIXED: The whois.nic.uk parser fails to parse #nameservers when
  the domain is suspended.


## Release 1.3.10

- SERVER: Removed the .fed.us TLD definition.

- NEW: Added simple .je TLD parser (whois.je).

- NEW: Added simple .ke TLD parser (whois.kenic.or.ke).

- NEW: Added simple .li TLD parser (whois.nic.li).

- CHANGED: Force whois.denic.de WHOIS output to be always UTF-8,
  otherwise some queries will fail (#51)

    $ ruby-whois hosteurope.de
    % Error: 55000000013 Invalid charset for response

- CHANGED: Standardized whois.nic.gov #status property.


## Release 1.3.9

- SERVER: Sync definitions with Debian whois 5.0.8:
    - Updated the .bb, .ps, and .lk TLD definitions.

- NEW: Added simple .dz TLD parser (whois.nic.dz).

- NEW: Added simple .fi TLD parser (whois.ficora.fi).

- NEW: Added simple .fj TLD parser (whois.usp.ac.fj).

- NEW: Added simple .gg TLD parser (whois.gg).

- NEW: Added simple .gs TLD parser (whois.nic.gs).

- NEW: Added simple .il TLD parser (whois.isoc.org.il).

- NEW: Added simple .ir TLD parser (whois.nic.ir).

- CHANGED: Standardized whois.pandi.or.id #status property,
  it now returns symbols instead of strings.

- FIXED: Compatibility with the new whois.cira.ca record schema.


## Release 1.3.8

- FIXED: The Verisign WHOIS adapter crashes in some rare circumstances 
  when the response from the Verisign database returns a "not defined" value
  for the Referral Whois Server (GH-42)


## Release 1.3.7

- SERVER: Updated the .ci TLD definition.

- SERVER: Removed the .co.uk TLD definition.

- NEW: Added simple .priv.at TLD parser (whois.nic.priv.at).

- NEW: Added simple .cx TLD parser (whois.nic.cx).

- NEW: Added simple .bo TLD parser (whois.nic.bo).

- NEW: Added simple .co.ca TLD parser (whois.co.ca).

- NEW: Added simple .ck TLD parser (whois.nic.ck).

- NEW: Added simple .cl TLD parser (whois.nic.cl).

- NEW: Added simple .cm TLD parser (whois.netcom.cm).

- NEW: Added simple .cz TLD parser (whois.nic.cz).

- CHANGED: Standardized whois.nic.af #status property,
  it now returns symbols instead of strings.

- CHANGED: Standardized whois.arnes.si #status property,
  it now returns symbols instead of strings.


## Release 1.3.6

- CHANGED: Deprecated Whois::Answer::Part#response.

- FIXED: whois.denic.de parser is not compatible with Denic response v 2.0.


## Release 1.3.5

- SERVER: Updated the .so TLD definition (GH-36).

- NEW: Added simple .ug TLD parser (whois.co.ug) (GH-35). [DerGuteMoritz]

- FIXED: ruby-whois executable is not installed when the Gem is installed.


## Release 1.3.4

- FIXED: With some .ie domains, whois.dns.be parser returns invalid values for nameservers.

- FIXED: With some .be domains, whois.dmainregistry.ie parser returns invalid values for nameservers.


## Release 1.3.3

- NEW: Ability to parse Registrar for .ca TLD parser. [aeden]

- FIXED: With some .nl domains, whois.domain-registry.nl parser returns invalid values for nameservers.

- FIXED: With some .mx domains, whois.nic.mx parser returns invalid values for nameservers.

- FIXED: With some .me domains, whois.meregistry.net parser returns invalid values for nameservers.


## Release 1.3.2

- FIXED: .nl TLD parser doesn't understand quarantine status (GH-34).

- CHANGED: Parser aliases are now created aliasing constants instead subclassing.

- CHANGED: Updated .hk parser to whois.hkirc.hk (GH-30).

- CHANGED: Updated .tw parser to whois.twnic.net.tw (GH-31).


## Release 1.3.1

- SERVER: Added the following 10 new IDN TLD:
    - .xn--fzc2c9e2c (.ලංකා, Sri Lanka)
    - .xn--j6w193g (.香港, Hong Kong)
    - .xn--kprw13d (.台灣, Taiwan)
    - .xn--kpry57d (.台湾, Taiwan)
    - .xn--mgbayh7gpa (.الاردن, Jordan)
    - .xn--o3cw4h (.ไทย, Thailand)
    - .xn--pgbs0dh (.تونس, Tunisia)
    - .xn--wgbh1c (.مصر, Egypt)
    - .xn--xkc2al3hye2a (.இலங்கை, Sri Lanka)
    - .xn--ygbi2ammx (.فلسطين, Palestinian Territory, Occupied)

- SERVER: Sync definitions with Debian whois 5.0.7:
    - Added new IPv4 allocations.
    - Updated the .bd, .bo, .cm, .cu, .dz, .gr, .lb, .ni, .rw, .tw, and .tz TLD servers.

- REMOVED: Deprecated Whois::Answer::Parser.properties method.


## Release 1.3.0

- NEW: Ability to query IANA for TLD WHOIS information. [aadlani]

    Whois.query(".com")
    # => IANA WHOIS response for .com TLD

    Whois.query(".invalid")
    # => IANA WHOIS response for unassigned TLD

- NEW: Ability to compare two Server adapters for equality.

    Whois::Server.factory(:ipv4, "192.168.1.0/10", "whois.foo") ## Whois::Server.factory(:ipv4, "192.168.1.0/10", "whois.foo")
    # => true

    Whois::Server.factory(:ipv4, "192.168.1.0", "whois.foo") ## Whois::Server.factory(:ipv4, "192.168.1.0/10", "whois.foo")
    # => false

- CHANGED: Renamed Scanners::VerisignScanner to Scanners::Verisign.

- CHANGED: Excluded test folder from the packaged .gem file to reduce the size of the final packaged library.


## Release 1.2.2

- SERVER: Sync definitions with Debian whois 5.0.6.

- SERVER: Added new IPv4, IPv6 allocations (whois 5.0.6).

- SERVER: Added/Updated the .priv.at, .dj, .ls TLD definition (whois 5.0.6).

- SERVER: Added xn--mgbaam7a8h (United Arabs Emirates), .xn--mgberp4a5d4ar (Saudi Arabia), .xn--p1ai (Russian Federation), .xn--fiqs8s (China), .xn--fiqz9s (China) and .xn--wgbh1c (Egypt) TLD servers. (whois 5.0.6).

- SERVER: Killed .yu TLD, phased out on 30 March 2009 (whois 5.0.6).

- NEW: Added .to TLD parser (whois.tonic.to).

- FIXED: whois.jprs.jp doesn't fully understand answers for .net.jp domains. [milk1000cc]

- CHANGED: The .co TLD now has a WHOIS interface (whois.nic.co). Added simple .co parser.

- CHANGED: Updated .sa TLD parser from saudinic.net.sa to whois.nic.net.sa (GH-29).

- CHANGED: Updated .au TLD parser from whois.ausregistry.net.au to whois.audns.net.au (GH-27).


## Release 1.2.1

- NEW: Added simple .ee TLD parser (whois.eenet.ee).

- NEW: Added simple .kz TLD parser (whois.nic.kz).

- NEW: Added simple .la TLD parser (whois.nic.la).

- NEW: Added simple .ec TLD parser (whois.nic.ec).

- NEW: Added simple .uz TLD parser (whois.nic.uz).

- NEW: Added simple .uy TLD parser (whois.nic.org.uy).


## Release 1.2.0

- NEW: Whois::Answer#throttle? returns true in case of throttle response (see whois.publicinternetregistry.com for a real example)

- FIXED: With some .tr domains, whois.nic.tr parser returns inconsistent values for nameservers.

- FIXED: Unexpected token error when trying to parse a .hu whois response. The whois.nic.hu has changed response format.

- FIXED: RuntimeError "Unexpected token: WHOIS LIMIT EXCEEDED - SEE WWW.PIR.ORG/WHOIS FOR DETAILS" for whois.publicinternetregistry.com

- CHANGED: Lazy-load adapters using Ruby autoload feature.


## Release 1.1.8

- NEW: Added simple .pt TLD parser (whois.dns.pt).

- NEW: Added simple .ht TLD parser (whois.nic.ht).

- NEW: Added simple .tr TLD parser (whois.nic.tr).


## Release 1.1.7

- FIXED: method `to_time' not defined in DateTime (NameError) when the library is used with Ruby 1.9.1 and Rails (GH-24)


## Release 1.1.6

- NEW: Added simple .in.ua TLD parser (whois.in.ua). It seems that .in.ua is handled separately from .ua.


## Release 1.1.5

- NEW: Added simple .ua TLD parser (whois.net.ua).

- FIXED: Occasionally the library raises a "superclass mismatch for class DateTime (TypeError)" error.

- CHANGED: Cleanup Whois::Adapter::Base @buffer after a successful request.


## Release 1.1.4

- NEW: Added registrar support to Verisign parsers

- FIXED: Usage of deprecated method Whois::Answer::Parser.properties

- FIXED: Verisign parsers don't return the correct Referral URL when there's more than one response entry in the answer

- FIXED: Whois::Answer::Parsers::WhoisDotTk is not compatible with Ruby 1.9


## Release 1.1.3

- NEW: Added simple .tk TLD parser (whois.dot.tk).

- NEW: Added .sn TLD parser (whois.nic.sn).

- CHANGED: Whois::Answer### and Whois::Answer#eql? should be able to compare Whois::Answer with subclasses.

- CHANGED: Deprecate Whois::Answer::Parser.properties. Use Whois::Answer::Parser::PROPERTIES instead.


## Release 1.1.2

- NEW: Whois::Answer::Contact#type property returns the type of the contact (ADMIN, TECHNICAL, ...).

- FIXED: Whois::Answer::Parser::Base#contacts decomposes each Contact property in a single contact.


## Release 1.1.1

- FIXED: Deprecated methods Whois::Answer::Parser::Base#(admin|technical|registrant) didn't figure as supported with Whois::Answer#property_supported?(:method)


## Release 1.1.0

- NEW: Added simple .am TLD parser (whois.nic.am).

- NEW: Added simple .as TLD parser (whois.nic.as).

- NEW: Added simple .au TLD parser (whois.ausregistry.net.au).

- NEW: Added simple .st TLD parser (whois.nic.st).

- NEW: New methods Whois::Answer#contacts, Whois::Answer::Parser#contacts, and Whois::Answer::Parser::Base#contacts returns all supported contacts.

- CHANGED: Renamed Whois::Answer::Parser::Base#(admin|technical|registrant) to Whois::Answer::Parser::Base#(admin|technical|registrant)_contact.


## Release 1.0.12

- NEW: Added simple .in TLD parser (whois.registry.in).

- NEW: Added simple .jp TLD parser (whois.jprs.jp).

- FIXED: With some .lu domains, whois.dns.lu parser returns invalid values for nameservers.


## Release 1.0.11

- NEW: Added simple .af TLD parser (whois.nic.af).

- NEW: Added simple .ag TLD parser (whois.nic.ag).

- NEW: Added simple .ai TLD parser (whois.ai).

- NEW: Added simple .hk TLD parser (whois.hkdnr.net.hk).

- NEW: Added simple .lu TLD parser (whois.dns.lu).

- NEW: Added simple .mx TLD parser (whois.nic.mx).

- FIXED: Fixed uninitialized constant error Whois::Answer::Parser::WhoisNicOrKr when trying to load the .kr parser.


## Release 1.0.10

- NEW: Added simple .kr TLD parser (whois.nic.or.kr).

- NEW: Added simple .be TLD parser (whois.dns.be).

- FIXED: .cn server was changed by mistake in commit:81b3e253785e59aca542b6165ab1b9769c6acdd7 from whois.cnnic.net.cn to whois.cnnic.cn. This caused the parser lookup to fail.

- FIXED: With some .lt domains, whois.domreg.lt parser returns invalid values for nameservers.

- FIXED: With some .bg domains, whois.register.bg parser returns invalid values for nameservers.


## Release 1.0.9

- NEW: Added simple .lt TLD parser (whois.domreg.lt).

- NEW: Added simple .at TLD parser (whois.nic.at).

- NEW: Added simple .cn TLD parser (whois.cnnic.net.cn).

- NEW: Added simple .lv TLD parser (whois.nic.lv).

- NEW: Added simple .si TLD parser (whois.arnes.si).

- NEW: Added simple .id TLD parser (whois.pandi.or.id).

- FIXED: With some .ru domains, whois.ripn.net parser returns invalid values for nameservers.


## Release 1.0.8

- NEW: Added simple .nz TLD parser (whois.srs.net.nz).

- FIXED: With some .ch domains, whois.nic.ch parser returns invalid or duplicate values for nameservers.


## Release 1.0.7

- FIXED: whois.nic.hu parser raises a NoMethodError when trying to access 'registrant' property for personal domains (GH-19).


## Release 1.0.6

- NEW: Added simple .ve TLD parser (whois.nic.ve).

- NEW: Added support for 'nameservers' property for all existing parsers.

- FIXED: With some .eu domains, whois.eu parser returns invalid values for nameservers.

- CHANGED: jobswhois.verisign-grs.com now correctly raises PropertyNotSupported when a property is not supported.

- CHANGED: whois.crsnic.net now correctly raises PropertyNotSupported when a property is not supported.

- CHANGED: whois.denic.de now correctly raises PropertyNotSupported when a property is not supported.

- CHANGED: whois.nic.cc now correctly raises PropertyNotSupported when a property is not supported.

- CHANGED: whois.nic.hu now correctly raises PropertyNotSupported when a property is not supported.

- CHANGED: whois.nic.it now correctly raises PropertyNotSupported when a property is not supported.

- CHANGED: whois.nic.tv now correctly raises PropertyNotSupported when a property is not supported.


## Release 1.0.5

- SERVER: Sync definitions with Debian whois 5.0.1.

- SERVER: Added new IPv4 allocations (whois 5.0.1).

- SERVER: Updated the .dj TLD definition (whois 5.0.1).

- NEW: Support for 'nameservers' property for the whois.afilias.info parser. (GH-15)

- NEW: Support for 'nameservers' property for the whois.nic.tel parser. (GH-17)

- NEW: Support for 'nameservers' property for the whois.eu parser. (GH-16)

- NEW: Support for 'nameservers' property for the whois.meregistry.net parser.

- FIXED: whois.crsnic.net server crashes trying to return nameservers with reserved IANA domains and Ruby 1.9.1.

- FIXED: With some .se domains, whois.nic-se.se parser returns invalid values for nameservers.


## Release 1.0.4

- NEW: Added Symbol.to_proc core extension to ensure compatibility with Ruby 1.8.6.

- FIXED: Normalize 'nameservers' property return value. Always return an Array even if there's no nameserver.

- CHANGED: Suppress Japanese output for the .js TLD [axic]


## Release 1.0.3

- SERVER: Added web address for the .eg TLD [axic]

- SERVER: Updated web address for the .gt TLD [axic]

- SERVER: Updated web address for the .co TLD (GH-13)

- NEW: Support for 'Contact#zip' property for the whois.nic.it parser [axic]

- NEW: Support for 'nameservers' property for the whois.adamsnames.tc parser.

- NEW: Compatibility with semver.org

- FIXED: The whois.nic.it parser extracts the wrong Contact country_code property [axic]

- FIXED: With some .de domains, whois.denic.de parser returns invalid values for nameservers (GH-14)

- FIXED: whois.crsnic.net crashes with reserved IANA domains (ex y.com)


## Release 1.0.2

- CHANGED: Changed Parsers to use a normalized content version called Whois::Parser::Base#content_for_scanner (Dho! I forgot to save some files on TextMate)


## Release 1.0.1

- CHANGED: Changed Parsers to use a normalized content version called Whois::Parser::Base#content_for_scanner


## Release 1.0.0

- SERVER: Changed .biz TLD server to whois.biz (see http://www.iana.org/domains/root/db/biz.html)

- SERVER: Changed .br TLD server to whois.registro.br (see http://www.iana.org/domains/root/db/rb.html)

- SERVER: Sync definitions with Debian whois 4.7.37.

- SERVER: Added new IPv4 allocations (whois 4.7.37).

- SERVER: Updated the .bd, .bi, .cm, .ge, .gf, .ki, .kn, .ls, .mq, .np and .tr TLD definitions (whois 4.7.37).

- SERVER: Sync definitions with Debian whois 5.0.0.

- SERVER: Updated the .id, .is, .mm, .my, .pw, .sb, .sr, .tj, .tp, .wf, .yt TLD definitions (whois 5.0.0).

- SERVER: .dk TLD server requires --show-handles option (closes REDMINE-426)

- NEW: Simple .at TLD parser.

- NEW: Simple .be TLD parser.

- NEW: Simple .bg TLD parser.

- NEW: Simple .ca TLD parser.

- NEW: Simple .ch TLD parser.

- NEW: Simple .eu TLD parser.

- NEW: Simple .gl TLD parser.

- NEW: Simple .im TLD parser.

- NEW: Simple .is TLD parser.

- NEW: Simple .ly TLD parser.

- NEW: Simple .me TLD parser.

- NEW: Simple .mu, .ki TLD parser (whois.nic.mu).

- NEW: Simple .nl TLD parser.

- NEW: Simple .no TLD parser.

- NEW: Simple .fo, .gm, .mc, .sm, .va TLD parsers (whois.ripe.net).

- NEW: Simple .tl TLD parser.

- NEW: Simple .tel TLD parser.

- NEW: Simple .us TLD parser.

- NEW: Simple .biz TLD parser.

- NEW: Simple .mobi TLD parser.

- NEW: Simple .museum TLD parser.

- NEW: Simple .io TLD parser.

- NEW: Simple .ro TLD parser.

- NEW: Simple .br TLD parser.

- NEW: Simple .travel TLD parser.

- NEW: Simple .wf, .yt TLD parser (whois.nic.fr).

- NEW: Simple .dk TLD parser [Thanks Mikkel Kristensen]

- NEW: Simple .uk TLD parser (whois.nic.uk).

- NEW: Simple .ws TLD parser (whois.samoanic.ws).

- NEW: Simple .gd, vg, tc TLD parser (whois.adamsnames.tc).

- NEW: Simple .su, .ru TLD parser (whois.ripn.net).

- NEW: Simple .cat TLD parser (whois.cat).

- NEW: Simple .cd TLD parser (whois.nic.cd).

- NEW: Simple .coop TLD parser (whois.nic.coop).

- NEW: Simple .pro TLD parser (whois.registrypro.pro).

- NEW: Simple .ae TLD parser (whois.aeda.net.ae).

- NEW: .cc, .jobs TLD parsers (verisign).

- NEW: .ac TLD parser (whois.nic.ac).

- NEW: Added ability to flag a property as :defined, :implemented and :supported. 
  Parsers now can mark a property as supported or not supported using 
  'property_supported' and 'property_not_supported' methods
  in order to distinguish between properties not supported by the answer
  and methods that still need to be implemented because the parser is incomplete.

- NEW: Whois#Answer.property? returns whether property has a value.

   a = Whois.query "google.it"
   a.created_on?
   # => true
   a.domain_id?
   # => false

- NEW: Whois::WebInterfaceError now exposes #url attribute.

- FIXED: Whois hosts containing a - are not correctly converted into a Ruby class, ex. whois.domain-registry.nl (closes REDMINE-389)

- FIXED: In case of exception, the CLI doesn't exit nicely (closes REDMINE-333)

- FIXED: Some tests are not compatible with Ruby 1.9

- FIXED: Flagged created_on and expires_on properties as not supported for .de TLD.

- CHANGED: All not supported properties now raise a PropertyNotSupported error instead of returning nil.

- CHANGED: Depending on where you ask for a property, the library now returns the most expected value according to property status.
  If you try to access a property from the answer object, Whois::Answer always returns the value if the property is defined,
  nil otherwise no matter if the property is not supported or undefined.

    a = Whois.query "google.ac"
    a.nameservers
    # => nil even if not supported

  If you want a more granular level of response, you can access the underling parser implementation.

    a = Whois.query "google.ac"
    a.parser.nameservers
    # => PropertyNotSupported

- CHANGED: Increased DEFAULT_TIMEOUT to 10 seconds

- REMOVED: Removed Deprecated #supported? method

- REMOVED: Removed Deprecated compatibility layer to Whois 0.4.2


## Release 0.9.0

- SERVER: .ec TLD has a whois server (closes REDMINE-322)

- SERVER: .gl TLD has a whois server (closes REDMINE-323)

- SERVER: .md TLD has a whois server (closes REDMINE-325)

- SERVER: Changed .edu TLD server to whois.educause.edu (see http://www.iana.org/domains/root/db/edu.html)

- FIXED: TLD definitions for whois.afilias-grs.info missing proper adapter (closes REDMINE-342)

- FIXED: ./bin/ruby-whois uses the Gem instead of current version (closes REDMINE-344)

- FIXED: Whois::Client doesn't cast query to_s (closes REDMINE-339)

- FIXED: Whois::Parser doesn't detect preloaded parsers. Improved performances skipping unnecessary 'require'. (closes REDMINE-340)

- NEW: Simple .fr TLD parser.

- NEW: Simple .name TLD parser.

- NEW: Simple .ie TLD parser.

- NEW: Simple .edu TLD parser.

- NEW: Simple .info TLD parser.

- NEW: Simple .gov TLD parser.

- NEW: Simple .za.net TLD parser.

- NEW: Simple .eu.org TLD parser.

- NEW: Simple .za.org TLD parser.

- NEW: Simple .int/.arpa TLD parser.

- NEW: Simple .aero TLD parser.

- NEW: Simple .asia TLD parser.

- NEW: Simple .bz, .gi, .hn, .lc, .mn, .sc and .vc TLD parser.

- NEW: .tv TLD parser.

- NEW: .hu TLD parser.

- NEW: Ability to pass timeout option to 'ruby-whois' (closes REDMINE-334)

- NEW: Whois::Answer#properties returns an Hash of :key => value

- CHANGED: Removed Whois::BUILD and Whois::STATUS constants. Added Whois::Version::ALPHA constant to be used when I need to package prereleases (see RubyGem --prerelease flag).

- CHANGED: Extracted Whois::Answer::Parser::Ast module from existing parsers.

- CHANGED: Normalized WhoisDenicDe parser.

- CHANGED: Renamed #supported to #property_supported?


## Release 0.8.1

- FIXED: Updated the whois.denic.de parser to the new format (REDMINE-314). [Thanks David Krentzlin]

- FIXED: In case of thin server the client should select the closest whois server match (closes REDMINE-264)

- NEW: ability to check whether a property is supported via answer.supported? or parser.supported?


## Release 0.8.0

- FIXED: Server definition with :format doesn't use the Formatted adapter (closes REDMINE-305)

- NEW: whois.denic.de (.de TLD) parser [Aaron Mueller]

- NEW: introduced support for multipart answers and Parser proxy class. This is useful in case of thin servers such as .com or .net because the parser needs to know all different responses in order to load all single scanners.

- NEW: whois.crsnic.net (.com, .net, ... TLDs) parser.

- CHANGED: extracted all scanners into separated classes in order to make easier extract shared features.

- CHANGED: renamed Whois::Response to Whois::Answer. This change is required to avoid confusion between query-answer and server request-response. A Whois::Answer is composed by one or more parts, corresponding to single server answers.

- REMOVED: Whois::Answer#i_am_feeling_lucky (formerly Whois::Answer#i_am_feeling_lucky) become obsolete since the introduction of Answer parsers.


## Release 0.6.0

- NEW: new more convenient method to query a whois server in addition to the existing Whois::whois method.

    Whois::query("domain.com")
    # same as Whois::whois but added to normalize application interfaces.

    Whois::available?("domain.com")
    # returns true if the domain is available.

    Whois::registered?("domain.com")
    # returns true if the domain is registered.

- NEW: Experimental support for whois response parsing. This release is shipped with two parsers for the .it and .net TLD.

    r = Whois::query("google.it")
    r.available?
    # => false
    r.created_on
    # => Time.parse("1999-12-10 00:00:00")
    r.Nameservers
    # => ["ns1.google.com", "ns2.google.com", ...]

- CHANGED: A whois query now returns a custom Whois::Response object instead of a simple string.
  The previous interface is still supported, so you can continue to compare the response with Strings
  but this behavior will be deprecated in a future release.
  
    r = Whois::query("domain.com")
    # supported but deprecated in a future version
    r ## "NOT FOUND"
    # explicitly cast the object to string instead
    r.to_s ## "NOT FOUND"
    # or use one of the other Whois::Response methods.

Note. This is an experimental version (EAP) and it should not be considered production-ready.
API might change at any time without previous notice.


## Release 0.5.3

- FIXED: self.valid_ipv6?(addr) references valid_v4? instead of valid_ipv4? (closes REDMINE-300)

- FIXED: In some rare circumstances the server guessing fails to return the right server but returns an other server instead (closes REDMINE-260).


## Release 0.5.2

- SERVER: Sync definitions with Debian whois 4.7.36.

- SERVER: Added new IPv4 allocations (whois 4.7.36).

- SERVER: Added .ls, .mg, .mk, .tz and .uy TLD definitions (whois 4.7.36).

- SERVER: Updated .jobs, .ms and .ph TLD definitions (whois 4.7.36).

- SERVER: Removed .td TLD definition (whois 4.7.36).

- NEW: Whois::Client.new now accepts a block and yields self.

    client = Whois::Client.new do |c|
      c.timeout = nil
    end
    client.query("google.com")

- FIXED: DeprecatedWhoisTest are flagged with need_connectivity method because they require connectivity.


## Release 0.5.1

- NEW: Whois binary (closes REDMINE-271).

- FIXED: 'rake coverage' task crashes.

- FIXED: In case of thin server the client should concatenate all responses (closes REDMINE-259).


## Release 0.5.0

- NEW: Support for IPv4 and IPv6 (closes REDMINE-265).

- NEW: Compatibility with existing GEM Whois 0.4.2 (closes REDMINE-266).

- NEW: Deprecation warning for all the features that will be removed in Whois 0.6.0 (closes REDMINE-266).

- NEW: Default timeout for any Whois query run from the client interface (closes REDMINE-269).

- FIXED: Whois#whois defined as instance method but modules can't have instances!

- FIXED: Whois::Server::Adapters::Verisign adapter always use "whois.crsnic.net" regardless the adapter set in the server definition.


- SERVER: Updated .tv TLD definition (closes REDMINE-261).

- SERVER: Updated .ae TLD definition (closes REDMINE-270).


## Release 0.1.1

- FIXED: Server#guess should raise ServerNotFound when query is not recognized.

- FIXED: ServerError should inherits from Error and not StandardError.

- CHANGED: Removed the Kernel#whois method because fights with many implementations of missing_method. Moved the method under the Whois namespace.


## Release 0.1.0

- First release
