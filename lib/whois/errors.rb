module Whois
  
  class Error < StandardError
  end
  
  
  # Generic Server exception class.
  class ServerError < StandardError
  end
  
  class UnexpectedServerResponse < ServerError
    attr_reader :response
    def initialize(message, response = nil)
      @response = response
      super(message)
    end
  end
  
  
  # Definition not found
  
  # Raised when the class hasn't been able to select a valid server
  # probably because definitions are outdated.
  class ServerNotFound < ServerError
  end
  
  
  # Definition found
  
  class InterfaceNotSupported < ServerError
  end
  
  # Raised when a server is known to not be available for this kind of object
  # or because this specific object doesn't support whois. (\x03)
  class NoInterfaceError < InterfaceNotSupported
  end
  
  # Raised when the class has found a server but it doesn't support the
  # standard whois interface via port 43. This is the case of some
  # specific domains that only provide a web–based whois interface. (\x01)
  class WebInterfaceError < InterfaceNotSupported
  end
  
  
  # Raised when no whois server is known for this kind of object. (\x05)
  class ServerNotSupported < ServerError
  end
  
  # Raised when unknown AS numer of IP network. (\x06)
  class UnknownServer < ServerError
  end

end