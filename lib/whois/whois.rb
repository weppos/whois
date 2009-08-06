#
# = Ruby Whois
#
# A pure Ruby WHOIS client.
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


require 'resolv'


module Whois

  class WhoisException < Exception # :nodoc
  end

  class WhoisExceptionError < WhoisException # :nodoc
    def initialize (i)
      super("Report a bug with error #{i} to http://rubyforge.org/projects/whois/")
    end
  end


  # This class exists to ensure this GEM is compatible
  # with the original Ruby Whois release 0.4.2
  # developed by Cyril Mougel.
  #
  # It exposes the same Ruby WHOIS 0.4.2 interface
  # and echoes deprecation warning for all those features
  # that are going to be removed in a next version.
  #
  # Here's a standard Ruby WHOIS 0.4.2 example usage.
  #
  #   w = Whois::Whois.new '72.14.207.99'
  #   w.search_whois
  #
  #   # All return of request
  #   w.all
  #
  #   # The ip return with object IPAddr
  #   w.ip
  #
  #   # The server where the request has send
  #   w.server
  #
  #   # The host of this IPv4
  #   w.host
  #
  #
  class Whois # :nodoc

    attr_reader   :all
    attr_reader   :ip
    attr_reader   :host
    attr_accessor :host_search

    def initialize(request, host_search = false)
      @host_search = host_search
      @host        = nil
      @client      = Client.new

      @ip = if request.instance_of? IPAddr
        request
      elsif Resolv::IPv4::Regex =~ request
        IPAddr.new(request)
      elsif Resolv::IPv6::Regex =~ request
        IPAddr.new(request)
      else
        begin
          @ip   = IPAddr.new(Resolv.getaddress(request))
          @host = request
        rescue Resolv::ResolvError
          raise WhoisException.new("host #{request} has no DNS result")
        end
      end

      @host || search_host
    rescue ServerNotFound => e
      raise WhoisException.new("no server found for #{request}")
    end

    def search_whois
      @all = @client.query(@ip.to_s)
    end

    def search_host
      @host = if @host_search
        Resolv.getname(@ip.to_s)
      else
        nil
      end
    rescue Resolv::ResolvError
      @host = nil
    end

    def server
      if server = @client.instance_variable_get(:"@server")
        Server::Server.lookup(server.host)
      end
    end

  end

  class Server # :nodoc

    class Server
      @@definitions = [
        ['whois.afrinic.net'  , 'Afrinic'     ],
        ['whois.ripe.net'     , 'Ripe'        ],
        ['whois.apnic.net'    , 'Apnic'       ],
        ['whois.arin.net'     , 'Arin'        ],
        ['whois.lacnic.net'   , 'Lacnic'      ],
        ['whois.nic.or.kr'    , 'Nicor'       ],
        ['whois.nic.ad.jp'    , 'Nicad'       ],
        ['whois.nic.br'       , 'Nicbr'       ],
        [nil                  , 'Teredo'      ],
        [nil                  , 'Ipv6ToIpv4'  ],
        ['whois.v6nic.net'    , 'V6nic'       ],
        ['whois.twnic.net'    , 'Twnic'       ],
        ['whois.6bone.net'    , 'Ipv6Bone'    ],
        ['rwhois.gin.ntt.net' , 'Ginntt'      ],
      ]

      attr_reader :server

      def initialize(server)
        @server = server
      end

      def self.lookup(host)
        @@definitions.each do |server, klassname|
          if !server.nil? && server == host
            klass = ::Whois::Server.const_get(klassname)
            return klass.new(server)
          end
        end
        nil
      end
    end

    class Afrinic < Server;     end
    class Ripe < Server;        end
    class Apnic < Server;       end
    class Arin < Server;        end
    class Lacnic < Server;      end
    class Nicor < Server;       end
    class Nicad < Server;       end
    class Nicbr < Server;       end
    class Teredo < Server;      end
    class Ipv6ToIpv4 < Server;  end
    class V6nic < Server;       end
    class Twnic < Server;       end
    class Verio < Server;       end
    class Ipv6Bone < Server;    end
    class Ginntt < Server;      end

  end

end