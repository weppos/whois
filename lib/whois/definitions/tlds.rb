Whois::Server.define :tld, ".br.com", "whois.centralnic.net"
Whois::Server.define :tld, ".cn.com", "whois.centralnic.net"
Whois::Server.define :tld, ".de.com", "whois.centralnic.net"
Whois::Server.define :tld, ".eu.com", "whois.centralnic.net"
Whois::Server.define :tld, ".gb.com", "whois.centralnic.net"
Whois::Server.define :tld, ".gb.net", "whois.centralnic.net"
Whois::Server.define :tld, ".hu.com", "whois.centralnic.net"
Whois::Server.define :tld, ".no.com", "whois.centralnic.net"
Whois::Server.define :tld, ".qc.com", "whois.centralnic.net"
Whois::Server.define :tld, ".ru.com", "whois.centralnic.net"
Whois::Server.define :tld, ".sa.com", "whois.centralnic.net"
Whois::Server.define :tld, ".se.com", "whois.centralnic.net"
Whois::Server.define :tld, ".se.net", "whois.centralnic.net"
Whois::Server.define :tld, ".uk.com", "whois.centralnic.net"
Whois::Server.define :tld, ".uk.net", "whois.centralnic.net"
Whois::Server.define :tld, ".us.com", "whois.centralnic.net"
Whois::Server.define :tld, ".uy.com", "whois.centralnic.net"
Whois::Server.define :tld, ".za.com", "whois.centralnic.net"
Whois::Server.define :tld, ".jpn.com", "whois.centralnic.net"
Whois::Server.define :tld, ".web.com", "whois.centralnic.net"
Whois::Server.define :tld, ".com", "whois.crsnic.net", {:adapter=>Whois::Server::Adapters::Verisign}
Whois::Server.define :tld, ".za.net", "whois.za.net"
Whois::Server.define :tld, ".net", "whois.crsnic.net", {:adapter=>Whois::Server::Adapters::Verisign}
Whois::Server.define :tld, ".eu.org", "whois.eu.org"
Whois::Server.define :tld, ".za.org", "whois.za.org"
Whois::Server.define :tld, ".org", "whois.publicinterestregistry.net", {:adapter=>Whois::Server::Adapters::Pir}
Whois::Server.define :tld, ".edu", "whois.educause.edu"
Whois::Server.define :tld, ".gov", "whois.nic.gov"
Whois::Server.define :tld, ".int", "whois.iana.org"
Whois::Server.define :tld, ".mil", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".e164.arpa", "whois.ripe.net"
Whois::Server.define :tld, ".in-addr.arpa", nil, {:adapter=>Whois::Server::Adapters::Arpa}
Whois::Server.define :tld, ".arpa", "whois.iana.org"
Whois::Server.define :tld, ".aero", "whois.aero"
Whois::Server.define :tld, ".asia", "whois.nic.asia"
Whois::Server.define :tld, ".biz", "whois.biz"
Whois::Server.define :tld, ".cat", "whois.cat", {:adapter=>Whois::Server::Adapters::Formatted, :format => "-C US-ASCII ace %s"}
Whois::Server.define :tld, ".coop", "whois.nic.coop"
Whois::Server.define :tld, ".info", "whois.afilias.info"
Whois::Server.define :tld, ".jobs", "jobswhois.verisign-grs.com", {:adapter=>Whois::Server::Adapters::Verisign}
Whois::Server.define :tld, ".mobi", "whois.dotmobiregistry.net"
Whois::Server.define :tld, ".museum", "whois.museum"
Whois::Server.define :tld, ".name", "whois.nic.name"
Whois::Server.define :tld, ".pro", "whois.registrypro.pro"
Whois::Server.define :tld, ".tel", "whois.nic.tel"
Whois::Server.define :tld, ".travel", "whois.nic.travel"
Whois::Server.define :tld, ".ac", "whois.nic.ac"
Whois::Server.define :tld, ".ad", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".ae", "whois.aeda.net.ae"
Whois::Server.define :tld, ".af", "whois.nic.af"
Whois::Server.define :tld, ".ag", "whois.nic.ag"
Whois::Server.define :tld, ".ai", "whois.ai"
Whois::Server.define :tld, ".al", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".am", "whois.nic.am"
Whois::Server.define :tld, ".an", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".ao", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".aq", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".ar", nil, {:web=>"http://www.nic.ar/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".as", "whois.nic.as"
Whois::Server.define :tld, ".priv.at", "whois.nic.priv.at"
Whois::Server.define :tld, ".at", "whois.nic.at"
Whois::Server.define :tld, ".au", "whois.ausregistry.net.au"
Whois::Server.define :tld, ".aw", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".ax", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".az", nil, {:web=>"http://www.nic.az/AzCheck.htm", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".ba", nil, {:web=>"http://www.nic.ba/stream/whois/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".bb", nil, {:web=>"http://www.barbadosdomains.net/search_domain.php", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".bd", nil, {:web=>"http://www.whois.com.bd/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".be", "whois.dns.be"
Whois::Server.define :tld, ".bf", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".bg", "whois.register.bg"
Whois::Server.define :tld, ".bh", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".bi", nil, {:web=>"http://whois.nic.bi/register/whois.hei", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".bj", "whois.nic.bj"
Whois::Server.define :tld, ".bm", nil, {:web=>"http://207.228.133.14/cgi-bin/lansaweb?procfun+BMWHO+BMWHO2+WHO", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".bn", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".bo", nil, {:web=>"http://www.nic.bo/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".br", "whois.registro.br"
Whois::Server.define :tld, ".bs", nil, {:web=>"http://www.nic.bs/cgi-bin/search.pl", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".bt", nil, {:web=>"http://www.nic.bt/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".bv", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".by", nil, {:web=>"http://www.tld.by/indexeng.html", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".bw", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".bz", "whois.afilias-grs.info", {:adapter=>Whois::Server::Adapters::Afilias}
Whois::Server.define :tld, ".co.ca", "whois.co.ca"
Whois::Server.define :tld, ".ca", "whois.cira.ca"
Whois::Server.define :tld, ".cc", "whois.nic.cc", {:adapter=>Whois::Server::Adapters::Verisign}
Whois::Server.define :tld, ".cd", "whois.nic.cd"
Whois::Server.define :tld, ".cf", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".cg", nil, {:web=>"http://www.nic.cg/cgi-bin/whois.pl", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".ch", "whois.nic.ch"
Whois::Server.define :tld, ".ci", "www.nic.ci"
Whois::Server.define :tld, ".ck", "whois.nic.ck"
Whois::Server.define :tld, ".cl", "whois.nic.cl"
Whois::Server.define :tld, ".cm", nil, {:web=>"http://netcom.cm/whois.php", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".edu.cn", "whois.edu.cn"
Whois::Server.define :tld, ".cn", "whois.cnnic.cn"
Whois::Server.define :tld, ".uk.co", "whois.uk.co"
Whois::Server.define :tld, ".co", "whois.nic.co"
Whois::Server.define :tld, ".cr", nil, {:web=>"http://www.nic.cr/niccr_publico/showRegistroDominiosScreen.do", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".cu", nil, {:web=>"http://www.nic.cu/consult.html", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".cv", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".cx", "whois.nic.cx"
Whois::Server.define :tld, ".cy", nil, {:web=>"http://www.nic.cy/nslookup/online_database.php", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".cz", "whois.nic.cz"
Whois::Server.define :tld, ".de", "whois.denic.de", {:adapter=>Whois::Server::Adapters::Formatted, :format => "-T dn,ace -C US-ASCII %s"}
Whois::Server.define :tld, ".dj", nil, {:adapter=>Whois::Server::Adapters::Web, :web=>"http://www.nic.dj/whois.php"}
Whois::Server.define :tld, ".dk", "whois.dk-hostmaster.dk", {:adapter=>Whois::Server::Adapters::Formatted, :format => "--show-handles %s"}
Whois::Server.define :tld, ".dm", "whois.nic.dm"
Whois::Server.define :tld, ".do", nil, {:web=>"http://www.nic.do/whois-h.php3", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".dz", nil, {:web=>"https://www.nic.dz/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".ec", "whois.nic.ec"
Whois::Server.define :tld, ".ee", "whois.eenet.ee"
Whois::Server.define :tld, ".eg", nil, {:web=>"http://lookup.egregistry.eg/english.aspx", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".er", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".es", nil, {:web=>"https://www.nic.es/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".et", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".eu", "whois.eu"
Whois::Server.define :tld, ".fi", "whois.ficora.fi"
Whois::Server.define :tld, ".fj", "whois.usp.ac.fj"
Whois::Server.define :tld, ".fk", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".fm", nil, {:web=>"http://www.dot.fm/whois.html", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".fo", "whois.ripe.net"
Whois::Server.define :tld, ".fr", "whois.nic.fr"
Whois::Server.define :tld, ".ga", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".gb", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".gd", "whois.adamsnames.tc"
Whois::Server.define :tld, ".ge", nil, {:web=>"http://www.registration.ge/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".gf", nil, {:web=>"http://www.nic.gf/?id=whois", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".gg", "whois.gg"
Whois::Server.define :tld, ".gh", nil, {:web=>"http://www.nic.gh/customer/search_c.htm", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".gi", "whois.afilias-grs.info", {:adapter=>Whois::Server::Adapters::Afilias}
Whois::Server.define :tld, ".gl", "whois.nic.gl"
Whois::Server.define :tld, ".gm", "whois.ripe.net"
Whois::Server.define :tld, ".gn", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".gp", "whois.nic.gp"
Whois::Server.define :tld, ".gq", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".gr", nil, {:web=>"https://grweb.ics.forth.gr/Whois?lang=en", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".gs", "whois.nic.gs"
Whois::Server.define :tld, ".gt", nil, {:adapter=>Whois::Server::Adapters::Web, :web=>"http://www.gt/whois.html"}
Whois::Server.define :tld, ".gu", nil, {:adapter=>Whois::Server::Adapters::Web, :web=>"http://gadao.gov.gu/domainsearch.htm"}
Whois::Server.define :tld, ".gw", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".gy", "whois.registry.gy"
Whois::Server.define :tld, ".hk", "whois.hkdnr.net.hk"
Whois::Server.define :tld, ".hm", "whois.registry.hm"
Whois::Server.define :tld, ".hn", "whois.afilias-grs.info", {:adapter=>Whois::Server::Adapters::Afilias}
Whois::Server.define :tld, ".hr", nil, {:web=>"http://www.dns.hr/pretrazivanje.html", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".ht", "whois.nic.ht"
Whois::Server.define :tld, ".hu", "whois.nic.hu"
Whois::Server.define :tld, ".id", "whois.pandi.or.id"
Whois::Server.define :tld, ".ie", "whois.domainregistry.ie"
Whois::Server.define :tld, ".il", "whois.isoc.org.il"
Whois::Server.define :tld, ".im", "whois.nic.im"
Whois::Server.define :tld, ".in", "whois.registry.in"
Whois::Server.define :tld, ".io", "whois.nic.io"
Whois::Server.define :tld, ".iq", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".ir", "whois.nic.ir"
Whois::Server.define :tld, ".is", "whois.isnic.is"
Whois::Server.define :tld, ".it", "whois.nic.it"
Whois::Server.define :tld, ".je", "whois.je"
Whois::Server.define :tld, ".jm", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".jo", nil, {:web=>"http://www.dns.jo/Whois.aspx", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".jp", "whois.jprs.jp", {:adapter=>Whois::Server::Adapters::Formatted, :format => "%s/e"}
Whois::Server.define :tld, ".ke", "whois.kenic.or.ke"
Whois::Server.define :tld, ".kg", "whois.domain.kg"
Whois::Server.define :tld, ".kh", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".ki", "whois.nic.mu"
Whois::Server.define :tld, ".km", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".kn", nil, {:web=>"http://www.nic.kn/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".kp", "whois.kcce.kp"
Whois::Server.define :tld, ".kr", "whois.nic.or.kr"
Whois::Server.define :tld, ".kw", nil, {:web=>"http://www.kw/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".ky", nil, {:web=>"http://kynseweb.messagesecure.com/kywebadmin/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".kz", "whois.nic.kz"
Whois::Server.define :tld, ".la", "whois.nic.la"
Whois::Server.define :tld, ".lb", nil, {:web=>"http://www.aub.edu.lb/lbdr/search.html", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".lc", "whois.afilias-grs.info", {:adapter=>Whois::Server::Adapters::Afilias}
Whois::Server.define :tld, ".li", "whois.nic.li"
Whois::Server.define :tld, ".lk", "whois.nic.lk"
Whois::Server.define :tld, ".lr", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".ls", nil, {:adapter=>Whois::Server::Adapters::Web, :web=>"http://www.co.ls/co.asp"}
Whois::Server.define :tld, ".lt", "whois.domreg.lt"
Whois::Server.define :tld, ".lu", "whois.dns.lu"
Whois::Server.define :tld, ".lv", "whois.nic.lv"
Whois::Server.define :tld, ".ly", "whois.nic.ly"
Whois::Server.define :tld, ".ma", "whois.iam.net.ma"
Whois::Server.define :tld, ".mc", "whois.ripe.net"
Whois::Server.define :tld, ".md", "whois.nic.md"
Whois::Server.define :tld, ".me", "whois.meregistry.net"
Whois::Server.define :tld, ".mg", "whois.nic.mg"
Whois::Server.define :tld, ".mh", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".mk", nil, {:web=>"http://dns.marnet.net.mk/registar.php", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".ml", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".mm", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".mn", "whois.afilias-grs.info", {:adapter=>Whois::Server::Adapters::Afilias}
Whois::Server.define :tld, ".mo", nil, {:web=>"http://www.monic.net.mo/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".mp", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".mq", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".mr", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".ms", "whois.nic.ms"
Whois::Server.define :tld, ".mt", nil, {:web=>"https://www.nic.org.mt/dotmt/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".mu", "whois.nic.mu"
Whois::Server.define :tld, ".mv", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".mw", nil, {:web=>"http://www.registrar.mw/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".mx", "whois.nic.mx"
Whois::Server.define :tld, ".my", "whois.domainregistry.my"
Whois::Server.define :tld, ".mz", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".na", "whois.na-nic.com.na"
Whois::Server.define :tld, ".nc", "whois.cctld.nc"
Whois::Server.define :tld, ".ne", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".nf", "whois.nic.nf"
Whois::Server.define :tld, ".ng", "whois.register.net.ng"
Whois::Server.define :tld, ".ni", nil, {:web=>"http://www.nic.ni/consulta.htm", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".nl", "whois.domain-registry.nl"
Whois::Server.define :tld, ".no", "whois.norid.no"
Whois::Server.define :tld, ".np", nil, {:web=>"http://register.mos.com.np/userSearchInc.asp", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".nr", nil, {:web=>"http://www.cenpac.net.nr/dns/whois.html", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".nu", "whois.nic.nu"
Whois::Server.define :tld, ".nz", "whois.srs.net.nz"
Whois::Server.define :tld, ".om", nil, {:web=>"http://www.omnic.om/onlineUser/WHOISLookup.jsp", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".pa", nil, {:web=>"http://www.nic.pa/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".pe", "whois.nic.pe"
Whois::Server.define :tld, ".pf", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".pg", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".ph", nil, {:web=>"http://www.dot.ph/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".pk", nil, {:web=>"http://www.pknic.net.pk/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".co.pl", "whois.co.pl"
Whois::Server.define :tld, ".pl", "whois.dns.pl"
Whois::Server.define :tld, ".pm", "whois.nic.fr"
Whois::Server.define :tld, ".pn", nil, {:web=>"http://www.pitcairn.pn/PnRegistry/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".pr", "whois.nic.pr"
Whois::Server.define :tld, ".ps", nil, {:web=>"http://www.nic.ps/whois/whois.html", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".pt", "whois.dns.pt"
Whois::Server.define :tld, ".pw", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".py", nil, {:web=>"http://www.nic.py/consultas.html", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".qa", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".re", "whois.nic.fr"
Whois::Server.define :tld, ".ro", "whois.rotld.ro"
Whois::Server.define :tld, ".rs", nil, {:web=>"http://www.nic.rs/en/whois", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".edu.ru", "whois.informika.ru"
Whois::Server.define :tld, ".ru", "whois.ripn.net"
Whois::Server.define :tld, ".rw", nil, {:web=>"http://www.nic.rw/cgi-bin/whoisrw.pl", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".sa", "saudinic.net.sa"
Whois::Server.define :tld, ".sb", "whois.coccaregistry.net"
Whois::Server.define :tld, ".sc", "whois.afilias-grs.info", {:adapter=>Whois::Server::Adapters::Afilias}
Whois::Server.define :tld, ".sd", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".se", "whois.nic-se.se"
Whois::Server.define :tld, ".sg", "whois.nic.net.sg"
Whois::Server.define :tld, ".sh", "whois.nic.sh"
Whois::Server.define :tld, ".si", "whois.arnes.si"
Whois::Server.define :tld, ".sj", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".sk", "whois.sk-nic.sk"
Whois::Server.define :tld, ".sl", "whois.nic.sl"
Whois::Server.define :tld, ".sm", "whois.ripe.net"
Whois::Server.define :tld, ".sn", "whois.nic.sn"
Whois::Server.define :tld, ".so", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".sr", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".st", "whois.nic.st"
Whois::Server.define :tld, ".su", "whois.ripn.net"
Whois::Server.define :tld, ".sv", nil, {:web=>"http://www.uca.edu.sv/dns/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".sy", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".sz", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".tc", "whois.adamsnames.tc"
Whois::Server.define :tld, ".td", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".tf", "whois.nic.tf"
Whois::Server.define :tld, ".tg", nil, {:web=>"http://www.nic.tg/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".th", "whois.thnic.net"
Whois::Server.define :tld, ".tj", nil, {:web=>"http://www.nic.tj/whois.html", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".tk", "whois.dot.tk"
Whois::Server.define :tld, ".tl", "whois.nic.tl"
Whois::Server.define :tld, ".tm", "whois.nic.tm"
Whois::Server.define :tld, ".tn", nil, {:web=>"http://whois.ati.tn/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".to", "whois.tonic.to"
Whois::Server.define :tld, ".tp", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".tr", "whois.nic.tr"
Whois::Server.define :tld, ".tt", nil, {:web=>"http://www.nic.tt/cgi-bin/search.pl", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".tv", "whois.nic.tv", {:adapter=>Whois::Server::Adapters::Verisign}
Whois::Server.define :tld, ".tw", "whois.twnic.net"
Whois::Server.define :tld, ".tz", nil, {:web=>"http://whois.tznic.or.tz/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".in.ua", "whois.in.ua"
Whois::Server.define :tld, ".ua", "whois.net.ua"
Whois::Server.define :tld, ".ug", "www.registry.co.ug"
Whois::Server.define :tld, ".ac.uk", "whois.ja.net"
Whois::Server.define :tld, ".bl.uk", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".british-library.uk", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".gov.uk", "whois.ja.net"
Whois::Server.define :tld, ".icnet.uk", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".jet.uk", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".mod.uk", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".nhs.uk", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".nls.uk", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".parliament.uk", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".police.uk", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".uk", "whois.nic.uk"
Whois::Server.define :tld, ".fed.us", "whois.nic.gov"
Whois::Server.define :tld, ".us", "whois.nic.us"
Whois::Server.define :tld, ".com.uy", nil, {:web=>"https://nic.anteldata.com.uy/dns/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".uy", "whois.nic.org.uy"
Whois::Server.define :tld, ".uz", "whois.cctld.uz"
Whois::Server.define :tld, ".va", "whois.ripe.net"
Whois::Server.define :tld, ".vc", "whois.afilias-grs.info", {:adapter=>Whois::Server::Adapters::Afilias}
Whois::Server.define :tld, ".ve", "whois.nic.ve"
Whois::Server.define :tld, ".vg", "whois.adamsnames.tc"
Whois::Server.define :tld, ".vi", nil, {:web=>"http://www.nic.vi/whoisform.htm", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".vn", nil, {:web=>"http://www.vnnic.vn/english/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".vu", nil, {:web=>"http://www.vunic.vu/whois.html", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".wf", "whois.nic.fr"
Whois::Server.define :tld, ".ws", "whois.samoanic.ws"
Whois::Server.define :tld, ".ye", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".yt", "whois.nic.fr"
Whois::Server.define :tld, ".ac.za", "whois.ac.za"
Whois::Server.define :tld, ".co.za", "whois.coza.net.za"
Whois::Server.define :tld, ".gov.za", "whois.gov.za"
Whois::Server.define :tld, ".org.za", nil, {:web=>"http://www.org.za/", :adapter=>Whois::Server::Adapters::Web}
Whois::Server.define :tld, ".za", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".zm", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".zw", nil, {:adapter=>Whois::Server::Adapters::None}
Whois::Server.define :tld, ".xn--fiqs8s", "cwhois.cnnic.cn"
Whois::Server.define :tld, ".xn--fiqz9s", "cwhois.cnnic.cn"
Whois::Server.define :tld, ".xn--mgbaam7a8h", "whois.aeda.net.ae"
Whois::Server.define :tld, ".xn--mgberp4a5d4ar", "whois.nic.net.sa"
Whois::Server.define :tld, ".xn--wgbh1c", "whois.dotmasr.eg"
Whois::Server.define :tld, ".xn--p1ai", "whois.ripn.net"
