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


require 'resolv'


module Whois

  class WhoisException < Exception # :nodoc
    def initialize(message)
      ::Whois.deprecate "WhoisException is deprecated as of 0.5.0 and will be removed in a future release along with Whois::Whois class."
      super
    end
  end

  class WhoisExceptionError < WhoisException # :nodoc
    def initialize(message)
      super("Report a bug with error #{message} to http://rubyforge.org/projects/whois/")
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
  # WARNING: The Whois::Whois class will be removed in a future release.
  # You should update your code to the new interface offered by <tt>Whois::Client</tt>.
  # If you want to save keystrokes, you can even use the handy <tt>Whois.query</tt> method.
  #
  #   Whois.query '72.14.207.99'
  #   # => whois answer
  #
  class Whois # :nodoc

    attr_reader   :ip
    attr_reader   :host
    attr_accessor :host_search

    def initialize(request, host_search = false)
      ::Whois.deprecate "Whois::Whois class is deprecated as of 0.5.0 and will be removed in a future release. Use Whois.query('#{request.to_s}') instead."

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
      ::Whois.deprecate "#search_host will be removed in a future release. Use Resolv.getname(#{@ip.to_s}) in your application to get the same feature."
      @host = if @host_search
        Resolv.getname(@ip.to_s)
      else
        nil
      end
    rescue Resolv::ResolvError
      @host = nil
    end

    def all
      ::Whois.deprecate "#all will be removed in a future release. You are responsible for storing the whois answer in a custom variable."
      @all
    end

    def server
      ::Whois.deprecate "#server will be removed in a future release. No replacement has been planned for the immediate future."
      if server = @client.instance_variable_get(:"@server")
        Server::Server.lookup(server.host)
      end
    end

  end

  class Server # :nodoc

    class Server # :nodoc
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

    Afrinic     = Class.new(Server)
    Ripe        = Class.new(Server)
    Apnic       = Class.new(Server)
    Arin        = Class.new(Server)
    Lacnic      = Class.new(Server)
    Nicor       = Class.new(Server)
    Nicad       = Class.new(Server)
    Nicbr       = Class.new(Server)
    Teredo      = Class.new(Server)
    Ipv6ToIpv4  = Class.new(Server)
    V6nic       = Class.new(Server)
    Twnic       = Class.new(Server)
    Verio       = Class.new(Server)
    Ipv6Bone    = Class.new(Server)
    Ginntt      = Class.new(Server)

  end

end