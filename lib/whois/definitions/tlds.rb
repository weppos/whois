Whois::Server.define :tld, ".ae.org", "whois.centralnic.com"
Whois::Server.define :tld, ".ar.com", "whois.centralnic.com"
Whois::Server.define :tld, ".br.com", "whois.centralnic.com"
Whois::Server.define :tld, ".cn.com", "whois.centralnic.com"
Whois::Server.define :tld, ".com.de", "whois.centralnic.com"
Whois::Server.define :tld, ".de.com", "whois.centralnic.com"
Whois::Server.define :tld, ".eu.com", "whois.centralnic.com"
Whois::Server.define :tld, ".gb.com", "whois.centralnic.com"
Whois::Server.define :tld, ".gb.net", "whois.centralnic.com"
Whois::Server.define :tld, ".gr.com", "whois.centralnic.com"
Whois::Server.define :tld, ".hu.com", "whois.centralnic.com"
Whois::Server.define :tld, ".jpn.com", "whois.centralnic.com"
Whois::Server.define :tld, ".kr.com", "whois.centralnic.com"
Whois::Server.define :tld, ".no.com", "whois.centralnic.com"
Whois::Server.define :tld, ".qc.com", "whois.centralnic.com"
Whois::Server.define :tld, ".ru.com", "whois.centralnic.com"
Whois::Server.define :tld, ".sa.com", "whois.centralnic.com"
Whois::Server.define :tld, ".se.com", "whois.centralnic.com"
Whois::Server.define :tld, ".se.net", "whois.centralnic.com"
Whois::Server.define :tld, ".uk.com", "whois.centralnic.com"
Whois::Server.define :tld, ".uk.net", "whois.centralnic.com"
Whois::Server.define :tld, ".us.com", "whois.centralnic.com"
Whois::Server.define :tld, ".us.org", "whois.centralnic.com"
Whois::Server.define :tld, ".uy.com", "whois.centralnic.com"
Whois::Server.define :tld, ".za.com", "whois.centralnic.com"
Whois::Server.define :tld, ".com", "whois.crsnic.net", { :adapter => :verisign }
Whois::Server.define :tld, ".za.net", "whois.za.net"
Whois::Server.define :tld, ".net", "whois.crsnic.net", { :adapter => :verisign }
Whois::Server.define :tld, ".eu.org", "whois.eu.org"
Whois::Server.define :tld, ".za.org", "whois.za.org"
Whois::Server.define :tld, ".org", "whois.pir.org"
Whois::Server.define :tld, ".edu", "whois.educause.edu"
Whois::Server.define :tld, ".gov", "whois.nic.gov"
Whois::Server.define :tld, ".int", "whois.iana.org"
Whois::Server.define :tld, ".mil", nil, { :adapter => :none }
Whois::Server.define :tld, ".e164.arpa", "whois.ripe.net"
Whois::Server.define :tld, ".in-addr.arpa", nil, { :adapter => :arpa }
Whois::Server.define :tld, ".arpa", "whois.iana.org"
Whois::Server.define :tld, ".aero", "whois.aero"
Whois::Server.define :tld, ".asia", "whois.nic.asia"
Whois::Server.define :tld, ".biz", "whois.biz"
Whois::Server.define :tld, ".cat", "whois.cat", { :adapter => :formatted, :format => "-C US-ASCII ace %s" }
Whois::Server.define :tld, ".coop", "whois.nic.coop"
Whois::Server.define :tld, ".info", "whois.afilias.info"
Whois::Server.define :tld, ".jobs", "jobswhois.verisign-grs.com", { :adapter => :verisign }
Whois::Server.define :tld, ".mobi", "whois.dotmobiregistry.net"
Whois::Server.define :tld, ".museum", "whois.museum"
Whois::Server.define :tld, ".name", "whois.nic.name", { :adapter => :formatted, :format => "domain=%s" }
Whois::Server.define :tld, ".pro", "whois.registrypro.pro"
Whois::Server.define :tld, ".tel", "whois.nic.tel"
Whois::Server.define :tld, ".travel", "whois.nic.travel"
Whois::Server.define :tld, ".ac", "whois.nic.ac"
Whois::Server.define :tld, ".ad", nil, { :adapter => :none }
Whois::Server.define :tld, ".ae", "whois.aeda.net.ae"
Whois::Server.define :tld, ".af", "whois.nic.af"
Whois::Server.define :tld, ".ag", "whois.nic.ag"
Whois::Server.define :tld, ".ai", "whois.ai"
Whois::Server.define :tld, ".al", nil, { :adapter => :none }
Whois::Server.define :tld, ".am", "whois.nic.am"
Whois::Server.define :tld, ".an", nil, { :adapter => :none }
Whois::Server.define :tld, ".ao", nil, { :adapter => :none }
Whois::Server.define :tld, ".aq", nil, { :adapter => :none }
Whois::Server.define :tld, ".ar", nil, { :adapter => :web, :url => "http://www.nic.ar/" }
Whois::Server.define :tld, ".as", "whois.nic.as"
Whois::Server.define :tld, ".priv.at", "whois.nic.priv.at"
Whois::Server.define :tld, ".at", "whois.nic.at"
Whois::Server.define :tld, ".au", "whois.audns.net.au"
Whois::Server.define :tld, ".aw", nil, { :adapter => :none }
Whois::Server.define :tld, ".ax", nil, { :adapter => :none }
Whois::Server.define :tld, ".az", nil, { :adapter => :web, :url => "http://www.nic.az/AzCheck.htm" }
Whois::Server.define :tld, ".ba", nil, { :adapter => :web, :url => "http://www.nic.ba/stream/whois/" }
Whois::Server.define :tld, ".bb", nil, { :adapter => :web, :url => "http://whois.telecoms.gov.bb/search_domain.php" }
Whois::Server.define :tld, ".bd", nil, { :adapter => :web, :url => "http://whois.btcl.net.bd/"}
Whois::Server.define :tld, ".be", "whois.dns.be"
Whois::Server.define :tld, ".bf", nil, { :adapter => :none }
Whois::Server.define :tld, ".bg", "whois.register.bg"
Whois::Server.define :tld, ".bh", nil, { :adapter => :none }
Whois::Server.define :tld, ".bi", "whois1.nic.bi"
Whois::Server.define :tld, ".bj", "whois.nic.bj"
Whois::Server.define :tld, ".bm", nil, { :adapter => :web, :url => "http://207.228.133.14/cgi-bin/lansaweb?procfun+BMWHO+BMWHO2+WHO" }
Whois::Server.define :tld, ".bn", nil, { :adapter => :none }
Whois::Server.define :tld, ".bo", "whois.nic.bo"
Whois::Server.define :tld, ".br", "whois.registro.br"
Whois::Server.define :tld, ".bs", nil, { :adapter => :web, :url => "http://www.nic.bs/cgi-bin/search.pl" }
Whois::Server.define :tld, ".bt", nil, { :adapter => :web, :url => "http://www.nic.bt/" }
Whois::Server.define :tld, ".bv", nil, { :adapter => :none }
Whois::Server.define :tld, ".by", 'whois.cctld.by'
Whois::Server.define :tld, ".bw", nil, { :adapter => :none }
Whois::Server.define :tld, ".bz", "whois.afilias-grs.info", { :adapter => :afilias }
Whois::Server.define :tld, ".co.ca", "whois.co.ca"
Whois::Server.define :tld, ".ca", "whois.cira.ca"
Whois::Server.define :tld, ".cc", "whois.nic.cc", { :adapter => :verisign }
Whois::Server.define :tld, ".cd", "whois.nic.cd"
Whois::Server.define :tld, ".cf", nil, { :adapter => :none }
Whois::Server.define :tld, ".cg", nil, { :adapter => :web, :url => "http://www.nic.cg/cgi-bin/whois.pl" }
Whois::Server.define :tld, ".ch", "whois.nic.ch"
Whois::Server.define :tld, ".ci", "whois.nic.ci"
Whois::Server.define :tld, ".ck", "whois.nic.ck"
Whois::Server.define :tld, ".cl", "whois.nic.cl"
Whois::Server.define :tld, ".cm", "whois.netcom.cm"
Whois::Server.define :tld, ".edu.cn", "whois.edu.cn"
Whois::Server.define :tld, ".cn", "whois.cnnic.cn"
Whois::Server.define :tld, ".co", "whois.nic.co"
Whois::Server.define :tld, ".cr", nil, { :adapter => :web, :url => "http://www.nic.cr/niccr_publico/showRegistroDominiosScreen.do" }
Whois::Server.define :tld, ".cu", nil, { :adapter => :web, :url => "http://www.nic.cu/" }
Whois::Server.define :tld, ".cv", nil, { :adapter => :web, :url => "http://www.dns.cv/" }
Whois::Server.define :tld, ".cw", nil, { :adapter => :none }
Whois::Server.define :tld, ".cx", "whois.nic.cx"
Whois::Server.define :tld, ".cy", nil, { :adapter => :web, :url => "http://www.nic.cy/nslookup/online_database.php" }
Whois::Server.define :tld, ".cz", "whois.nic.cz"
Whois::Server.define :tld, ".de", "whois.denic.de", { :adapter => :formatted, :format => "-T dn,ace %s" }
Whois::Server.define :tld, ".dj", nil, { :adapter => :web, :url => "http://www.nic.dj/whois.php" }
Whois::Server.define :tld, ".dk", "whois.dk-hostmaster.dk", { :adapter => :formatted, :format => "--show-handles %s" }
Whois::Server.define :tld, ".dm", "whois.nic.dm"
Whois::Server.define :tld, ".do", nil, { :adapter => :web, :url => "http://www.nic.do/whois-h.php3" }
Whois::Server.define :tld, ".dz", "whois.nic.dz"
Whois::Server.define :tld, ".ec", "whois.nic.ec"
Whois::Server.define :tld, ".ee", "whois.tld.ee"
Whois::Server.define :tld, ".eg", nil, { :adapter => :web, :url => "http://lookup.egregistry.eg/english.aspx" }
Whois::Server.define :tld, ".er", nil, { :adapter => :none }
Whois::Server.define :tld, ".es", nil, { :adapter => :web, :url => "https://www.nic.es/" }
Whois::Server.define :tld, ".et", nil, { :adapter => :none }
Whois::Server.define :tld, ".eu", "whois.eu"
Whois::Server.define :tld, ".fi", "whois.fi"
Whois::Server.define :tld, ".fj", "whois.usp.ac.fj"
Whois::Server.define :tld, ".fk", nil, { :adapter => :none }
Whois::Server.define :tld, ".fm", nil, { :adapter => :web, :url => "http://www.dot.fm/whois.html" }
Whois::Server.define :tld, ".fo", "whois.nic.fo"
Whois::Server.define :tld, ".aeroport.fr", "whois.smallregistry.net"
Whois::Server.define :tld, ".avocat.fr", "whois.smallregistry.net"
Whois::Server.define :tld, ".chambagri.fr", "whois.smallregistry.net"
Whois::Server.define :tld, ".chirurgiens-dentistes.fr", "whois.smallregistry.net"
Whois::Server.define :tld, ".experts-comptables.fr", "whois.smallregistry.net"
Whois::Server.define :tld, ".geometre-expert.fr", "whois.smallregistry.net"
Whois::Server.define :tld, ".medecin.fr", "whois.smallregistry.net"
Whois::Server.define :tld, ".notaires.fr", "whois.smallregistry.net"
Whois::Server.define :tld, ".pharmacien.fr", "whois.smallregistry.net"
Whois::Server.define :tld, ".port.fr", "whois.smallregistry.net"
Whois::Server.define :tld, ".veterinaire.fr", "whois.smallregistry.net"
Whois::Server.define :tld, ".fr", "whois.nic.fr"
Whois::Server.define :tld, ".ga", nil, { :adapter => :none }
Whois::Server.define :tld, ".gb", nil, { :adapter => :none }
Whois::Server.define :tld, ".gd", "whois.adamsnames.tc"
Whois::Server.define :tld, ".ge", nil, { :adapter => :web, :url => "http://www.registration.ge/" }
Whois::Server.define :tld, ".gf", nil, { :adapter => :web, :url => "https://www.dom-enic.com/whois.html" }
Whois::Server.define :tld, ".gg", "whois.gg"
Whois::Server.define :tld, ".gh", nil, { :adapter => :web, :url => "http://www.nic.gh/customer/search_c.htm" }
Whois::Server.define :tld, ".gi", "whois.afilias-grs.info", { :adapter => :afilias }
Whois::Server.define :tld, ".gl", "whois.nic.gl"
Whois::Server.define :tld, ".gm", nil, { :adapter => :web, :url => "http://www.nic.gm/htmlpages/whois.htm" }
Whois::Server.define :tld, ".gn", nil, { :adapter => :none }
Whois::Server.define :tld, ".gp", nil, { :adapter => :none }
Whois::Server.define :tld, ".gq", nil, { :adapter => :none }
Whois::Server.define :tld, ".gr", nil, { :adapter => :web, :url => "https://grweb.ics.forth.gr/Whois?lang=en" }
Whois::Server.define :tld, ".gs", "whois.nic.gs"
Whois::Server.define :tld, ".gt", nil, { :adapter => :web, :url => "http://www.gt/whois.html" }
Whois::Server.define :tld, ".gu", nil, { :adapter => :web, :url => "http://gadao.gov.gu/domainsearch.htm" }
Whois::Server.define :tld, ".gw", nil, { :adapter => :none }
Whois::Server.define :tld, ".gy", "whois.registry.gy"
Whois::Server.define :tld, ".hk", "whois.hkirc.hk"
Whois::Server.define :tld, ".hm", "whois.registry.hm"
Whois::Server.define :tld, ".hn", "whois.nic.hn"
Whois::Server.define :tld, ".hr", "whois.dns.hr"
Whois::Server.define :tld, ".ht", "whois.nic.ht"
Whois::Server.define :tld, ".hu", "whois.nic.hu"
Whois::Server.define :tld, ".id", "whois.pandi.or.id"
Whois::Server.define :tld, ".ie", "whois.domainregistry.ie"
Whois::Server.define :tld, ".il", "whois.isoc.org.il"
Whois::Server.define :tld, ".im", "whois.nic.im"
Whois::Server.define :tld, ".in", "whois.registry.in"
Whois::Server.define :tld, ".io", "whois.nic.io"
Whois::Server.define :tld, ".iq", "whois.cmc.iq"
Whois::Server.define :tld, ".ir", "whois.nic.ir"
Whois::Server.define :tld, ".is", "whois.isnic.is"
Whois::Server.define :tld, ".it", "whois.nic.it"
Whois::Server.define :tld, ".je", "whois.je"
Whois::Server.define :tld, ".jm", nil, { :adapter => :none }
Whois::Server.define :tld, ".jo", nil, { :adapter => :web, :url => "http://www.dns.jo/Whois.aspx" }
Whois::Server.define :tld, ".jp", "whois.jprs.jp", { :adapter => :formatted, :format => "%s/e" }
Whois::Server.define :tld, ".ke", "whois.kenic.or.ke"
Whois::Server.define :tld, ".kg", "whois.domain.kg"
Whois::Server.define :tld, ".kh", nil, { :adapter => :none }
Whois::Server.define :tld, ".ki", "whois.nic.ki"
Whois::Server.define :tld, ".km", nil, { :adapter => :none }
Whois::Server.define :tld, ".kn", nil, { :adapter => :web, :url => "http://www.nic.kn/" }
Whois::Server.define :tld, ".kp", nil, { :adapter => :none }
Whois::Server.define :tld, ".kr", "whois.nic.or.kr"
Whois::Server.define :tld, ".kw", nil, { :adapter => :web, :url => "http://www.kw/" }
Whois::Server.define :tld, ".ky", nil, { :adapter => :web, :url => "http://kynseweb.messagesecure.com/kywebadmin/" }
Whois::Server.define :tld, ".kz", "whois.nic.kz"
Whois::Server.define :tld, ".la", "whois.nic.la"
Whois::Server.define :tld, ".lb", nil, { :adapter => :web, :url => "http://www.aub.edu.lb/lbdr/"}
Whois::Server.define :tld, ".lc", "whois.afilias-grs.info", { :adapter => :afilias }
Whois::Server.define :tld, ".li", "whois.nic.li"
Whois::Server.define :tld, ".lk", "whois.nic.lk"
Whois::Server.define :tld, ".lr", nil, { :adapter => :none }
Whois::Server.define :tld, ".ls", nil, { :adapter => :web, :url => "http://www.co.ls/co.asp"}
Whois::Server.define :tld, ".lt", "whois.domreg.lt"
Whois::Server.define :tld, ".lu", "whois.dns.lu"
Whois::Server.define :tld, ".lv", "whois.nic.lv"
Whois::Server.define :tld, ".ly", "whois.nic.ly"
Whois::Server.define :tld, ".ma", "whois.iam.net.ma"
Whois::Server.define :tld, ".mc", "whois.ripe.net"
Whois::Server.define :tld, ".md", "whois.nic.md"
Whois::Server.define :tld, ".me", "whois.meregistry.net"
Whois::Server.define :tld, ".mg", "whois.nic.mg"
Whois::Server.define :tld, ".mh", nil, { :adapter => :none }
Whois::Server.define :tld, ".mk", nil, { :adapter => :web, :url => "http://dns.marnet.net.mk/registar.php" }
Whois::Server.define :tld, ".ml", nil, { :adapter => :none }
Whois::Server.define :tld, ".mm", nil, { :adapter => :none }
Whois::Server.define :tld, ".mn", "whois.afilias-grs.info", { :adapter => :afilias }
Whois::Server.define :tld, ".mo", "whois.monic.mo"
Whois::Server.define :tld, ".mp", nil, { :adapter => :none }
Whois::Server.define :tld, ".mq", nil, { :adapter => :web, :url => "https://www.dom-enic.com/whois.html" }
Whois::Server.define :tld, ".mr", nil, { :adapter => :none }
Whois::Server.define :tld, ".ms", "whois.nic.ms"
Whois::Server.define :tld, ".mt", nil, { :adapter => :web, :url => "https://www.nic.org.mt/dotmt/" }
Whois::Server.define :tld, ".mu", "whois.nic.mu"
Whois::Server.define :tld, ".mv", nil, { :adapter => :none }
Whois::Server.define :tld, ".mw", nil, { :adapter => :web, :url => "http://www.registrar.mw/" }
Whois::Server.define :tld, ".mx", "whois.nic.mx"
Whois::Server.define :tld, ".my", "whois.domainregistry.my"
Whois::Server.define :tld, ".mz", nil, { :adapter => :none }
Whois::Server.define :tld, ".na", "whois.na-nic.com.na"
Whois::Server.define :tld, ".nc", "whois.nc"
Whois::Server.define :tld, ".ne", nil, { :adapter => :none }
Whois::Server.define :tld, ".nf", "whois.nic.net.nf"
Whois::Server.define :tld, ".ng", "whois.nic.net.ng"
Whois::Server.define :tld, ".ni", nil, { :adapter => :web, :url => "http://www.nic.ni/"}
Whois::Server.define :tld, ".nl", "whois.domain-registry.nl"
Whois::Server.define :tld, ".no", "whois.norid.no"
Whois::Server.define :tld, ".np", nil, { :adapter => :web, :url => "http://register.mos.com.np/userSearchInc.asp" }
Whois::Server.define :tld, ".nr", nil, { :adapter => :web, :url => "http://www.cenpac.net.nr/dns/whois.html" }
Whois::Server.define :tld, ".nu", "whois.nic.nu"
Whois::Server.define :tld, ".nz", "whois.srs.net.nz"
Whois::Server.define :tld, ".om", "whois.registry.om"
Whois::Server.define :tld, ".pa", nil, { :adapter => :web, :url => "http://www.nic.pa/" }
Whois::Server.define :tld, ".pe", "kero.yachay.pe"
Whois::Server.define :tld, ".pf", nil, { :adapter => :none }
Whois::Server.define :tld, ".pg", nil, { :adapter => :none }
Whois::Server.define :tld, ".ph", nil, { :adapter => :web, :url => "http://www.dot.ph/" }
Whois::Server.define :tld, ".pk", nil, { :adapter => :web, :url => "http://www.pknic.net.pk/" }
Whois::Server.define :tld, ".co.pl", "whois.co.pl"
Whois::Server.define :tld, ".pl", "whois.dns.pl"
Whois::Server.define :tld, ".pm", "whois.nic.fr"
Whois::Server.define :tld, ".pn", nil, { :adapter => :web, :url => "http://www.pitcairn.pn/PnRegistry/" }
Whois::Server.define :tld, ".pr", "whois.nic.pr"
Whois::Server.define :tld, ".ps", "whois.pnina.ps"
Whois::Server.define :tld, ".pt", "whois.dns.pt"
Whois::Server.define :tld, ".pw", nil, { :adapter => :none }
Whois::Server.define :tld, ".py", nil, { :adapter => :web, :url => "http://www.nic.py/consultas.html" }
Whois::Server.define :tld, ".qa", "whois.registry.qa"
Whois::Server.define :tld, ".re", "whois.nic.fr"
Whois::Server.define :tld, ".ro", "whois.rotld.ro"
Whois::Server.define :tld, ".rs", "whois.rnids.rs"
Whois::Server.define :tld, ".edu.ru", "whois.informika.ru"
Whois::Server.define :tld, ".ru", "whois.tcinet.ru"
Whois::Server.define :tld, ".rw", nil, { :adapter => :web, :url => "http://www.nic.rw/cgi-bin/whois.pl"}
Whois::Server.define :tld, ".sa", "saudinic.net.sa"
Whois::Server.define :tld, ".sb", "whois.nic.net.sb"
Whois::Server.define :tld, ".sc", "whois.afilias-grs.info", { :adapter => :afilias }
Whois::Server.define :tld, ".sd", nil, { :adapter => :none }
Whois::Server.define :tld, ".se", "whois.nic-se.se"
Whois::Server.define :tld, ".sg", "whois.sgnic.sg"
Whois::Server.define :tld, ".sh", "whois.nic.sh"
Whois::Server.define :tld, ".si", "whois.arnes.si"
Whois::Server.define :tld, ".sj", nil, { :adapter => :none }
Whois::Server.define :tld, ".sk", "whois.sk-nic.sk"
Whois::Server.define :tld, ".sl", "whois.nic.sl"
Whois::Server.define :tld, ".sm", "whois.nic.sm"
Whois::Server.define :tld, ".sn", "whois.nic.sn"
Whois::Server.define :tld, ".so", "whois.nic.so"
Whois::Server.define :tld, ".sr", nil, { :adapter => :none }
Whois::Server.define :tld, ".st", "whois.nic.st"
Whois::Server.define :tld, ".su", "whois.tcinet.ru"
Whois::Server.define :tld, ".sv", nil, { :adapter => :web, :url => "http://www.uca.edu.sv/dns/" }
Whois::Server.define :tld, ".sx", "whois.sx"
Whois::Server.define :tld, ".sy", nil, { :adapter => :none }
Whois::Server.define :tld, ".sz", nil, { :adapter => :none }
Whois::Server.define :tld, ".tc", "whois.adamsnames.tc"
Whois::Server.define :tld, ".td", nil, { :adapter => :none }
Whois::Server.define :tld, ".tf", "whois.nic.fr"
Whois::Server.define :tld, ".tg", nil, { :adapter => :web, :url => "http://www.nic.tg/" }
Whois::Server.define :tld, ".th", "whois.thnic.co.th"
Whois::Server.define :tld, ".tj", nil, { :adapter => :web, :url => "http://www.nic.tj/whois.html" }
Whois::Server.define :tld, ".tk", "whois.dot.tk"
Whois::Server.define :tld, ".tl", "whois.nic.tl"
Whois::Server.define :tld, ".tm", "whois.nic.tm"
Whois::Server.define :tld, ".tn", "whois.ati.tn"
Whois::Server.define :tld, ".to", "whois.tonic.to"
Whois::Server.define :tld, ".tp", nil, { :adapter => :none }
Whois::Server.define :tld, ".tr", "whois.nic.tr"
Whois::Server.define :tld, ".tt", nil, { :adapter => :web, :url => "http://www.nic.tt/cgi-bin/search.pl" }
Whois::Server.define :tld, ".tv", "whois.nic.tv", { :adapter => :verisign }
Whois::Server.define :tld, ".tw", "whois.twnic.net.tw"
Whois::Server.define :tld, ".tz", "whois.tznic.or.tz"
Whois::Server.define :tld, ".in.ua", "whois.in.ua"
Whois::Server.define :tld, ".ua", "whois.ua"
Whois::Server.define :tld, ".ug", "whois.co.ug"
Whois::Server.define :tld, ".ac.uk", "whois.ja.net"
Whois::Server.define :tld, ".bl.uk", nil, { :adapter => :none }
Whois::Server.define :tld, ".british-library.uk", nil, { :adapter => :none }
Whois::Server.define :tld, ".gov.uk", "whois.ja.net"
Whois::Server.define :tld, ".icnet.uk", nil, { :adapter => :none }
Whois::Server.define :tld, ".jet.uk", nil, { :adapter => :none }
Whois::Server.define :tld, ".mod.uk", nil, { :adapter => :none }
Whois::Server.define :tld, ".nhs.uk", nil, { :adapter => :none }
Whois::Server.define :tld, ".nls.uk", nil, { :adapter => :none }
Whois::Server.define :tld, ".parliament.uk", nil, { :adapter => :none }
Whois::Server.define :tld, ".police.uk", nil, { :adapter => :none }
Whois::Server.define :tld, ".uk", "whois.nic.uk"
Whois::Server.define :tld, ".us", "whois.nic.us"
Whois::Server.define :tld, ".com.uy", nil, { :adapter => :web, :url => "https://nic.anteldata.com.uy/dns/" }
Whois::Server.define :tld, ".uy", "whois.nic.org.uy"
Whois::Server.define :tld, ".uz", "whois.cctld.uz"
Whois::Server.define :tld, ".va", nil, { :adapter => :none }
Whois::Server.define :tld, ".vc", "whois.afilias-grs.info", { :adapter => :afilias }
Whois::Server.define :tld, ".ve", "whois.nic.ve"
Whois::Server.define :tld, ".vg", "whois.adamsnames.tc"
Whois::Server.define :tld, ".vi", nil, { :adapter => :web, :url => "http://www.nic.vi/whoisform.htm" }
Whois::Server.define :tld, ".vn", nil, { :adapter => :web, :url => "http://www.vnnic.vn/english/" }
Whois::Server.define :tld, ".vu", nil, { :adapter => :web, :url => "http://www.vunic.vu/whois.html" }
Whois::Server.define :tld, ".wf", "whois.nic.fr"
Whois::Server.define :tld, ".ws", "whois.samoanic.ws"
Whois::Server.define :tld, ".ye", nil, { :adapter => :none }
Whois::Server.define :tld, ".yt", "whois.nic.fr"
Whois::Server.define :tld, ".ac.za", "whois.ac.za"
Whois::Server.define :tld, ".co.za", "whois.registry.net.za"
Whois::Server.define :tld, ".gov.za", "whois.gov.za"
Whois::Server.define :tld, ".org.za", "whois.org.za"
Whois::Server.define :tld, ".za", nil, { :adapter => :none }
Whois::Server.define :tld, ".zm", nil, { :adapter => :none }
Whois::Server.define :tld, ".zw", nil, { :adapter => :none }
Whois::Server.define :tld, ".xxx", "whois.nic.xxx"
Whois::Server.define :tld, ".xn--3e0b707e", "whois.kr"
Whois::Server.define :tld, ".xn--45brj9c", nil, { :adapter => :none }
Whois::Server.define :tld, ".xn--80ao21a", "whois.nic.kz"
Whois::Server.define :tld, ".xn--90a3ac", nil, { :adapter => :none }
Whois::Server.define :tld, ".xn--clchc0ea0b2g2a9gcd", "whois.sgnic.sg"
Whois::Server.define :tld, ".xn--fiqs8s", "cwhois.cnnic.cn"
Whois::Server.define :tld, ".xn--fiqz9s", "cwhois.cnnic.cn"
Whois::Server.define :tld, ".xn--fpcrj9c3d", nil, { :adapter => :none }
Whois::Server.define :tld, ".xn--fzc2c9e2c", "whois.nic.lk"
Whois::Server.define :tld, ".xn--gecrj9c", nil, { :adapter => :none }
Whois::Server.define :tld, ".xn--h2brj9c", nil, { :adapter => :none }
Whois::Server.define :tld, ".xn--j6w193g", "whois.hkirc.hk"
Whois::Server.define :tld, ".xn--kprw13d", "whois.twnic.net.tw"
Whois::Server.define :tld, ".xn--kpry57d", "whois.twnic.net.tw"
Whois::Server.define :tld, ".xn--lgbbat1ad8j", "whois.nic.dz"
Whois::Server.define :tld, ".xn--mgb9awbf", "whois.registry.om"
Whois::Server.define :tld, ".xn--mgba3a4f16a", "whois.nic.ir"
Whois::Server.define :tld, ".xn--mgbaam7a8h", "whois.aeda.net.ae"
Whois::Server.define :tld, ".xn--mgbayh7gpa", nil, { :adapter => :web, :url => "http://idn.jo/whois_a.aspx" }
Whois::Server.define :tld, ".xn--mgbbh1a71e", nil, { :adapter => :none }
Whois::Server.define :tld, ".xn--mgbc0a9azcg", nil, { :adapter => :none }
Whois::Server.define :tld, ".xn--mgberp4a5d4ar", "whois.nic.net.sa"
Whois::Server.define :tld, ".xn--o3cw4h", "whois.thnic.co.th"
Whois::Server.define :tld, ".xn--ogbpf8fl", nil, { :adapter => :none }
Whois::Server.define :tld, ".xn--p1ai", "whois.tcinet.ru"
Whois::Server.define :tld, ".xn--pgbs0dh", nil, { :adapter => :none }
Whois::Server.define :tld, ".xn--s9brj9c", nil, { :adapter => :none }
Whois::Server.define :tld, ".xn--wgbh1c", "whois.dotmasr.eg"
Whois::Server.define :tld, ".xn--wgbl6a", "whois.registry.qa"
Whois::Server.define :tld, ".xn--xkc2al3hye2a", "whois.nic.lk"
Whois::Server.define :tld, ".xn--xkc2dl3a5ee0h", nil, { :adapter => :none }
Whois::Server.define :tld, ".xn--yfro4i67o", "whois.sgnic.sg"
Whois::Server.define :tld, ".xn--ygbi2ammx", "whois.pnina.ps"
