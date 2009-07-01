module Whois
  
  class Error < StandardError
  end
  
  
  # Generic Server exception class.
  class ServerError < StandardError
  end
  
  # Raised when the class hasn't been able to select a valid server
  # probably because definitions are outdated.
  class ServerNotFound < ServerError
  end
  
  # Raised when a server is known to not be available for this kind of object
  # or because this specific object doesn't support whois.
  # This is the case of some specific domains that only provides
  # a web–based whois interface. (\x03)
  class ServerNotAvailable < ServerError
  end
  
  # Raised when no whois server is known for this kind of object. (\x05)
  class ServerNotSupported < ServerError
  end
  
  # Raised when unknown AS numer of IP network. (\x06)
  class ServerUnknown < ServerError
  end

end