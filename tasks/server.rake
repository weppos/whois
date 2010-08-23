namespace :server do

  desc "server:convert_file_tlds"
  task :convert_file_tlds do
    list = parse_list_tld
    File.open("data/c/tlds.txt", "w+") do |f| 
      f.write(list)
    end
    puts "Created file with #{list.size} servers."
  end

  desc "server:convert_file_ipv4"
  task :convert_file_ipv4 do
    list = parse_list_ipv4
    File.open("data/c/ipv4.txt", "w+") do |f|
      f.write(list)
    end
    puts "Created file with #{list.size} servers."
  end

  desc "server:convert_file_ipv6"
  task :convert_file_ipv6 do
    list = parse_list_ipv6
    File.open("data/c/ipv6.txt", "w+") do |f|
      f.write(list)
    end
    puts "Created file with #{list.size} servers."
  end


  def parse_list_tld
    File.readlines("data/c/tld_serv_list").map do |line|
      line.chomp!
      line.gsub!(/^\s*(.*)\s*$/, '\1')
      line.gsub!(/\s*#.*$/, '')
      next if line =~ /^$/;
      abort("format error #{line}") unless line =~ /^([\w\d\.-]+)\s+([\w\d\.:-]+|[A-Z]+\s+.*)$/

      extension, instructions = $1, $2
      server, options = case instructions
        when "NONE"             then [nil, { :adapter => Whois::Server::Adapters::None }]
        when "ARPA"             then [nil, { :adapter => Whois::Server::Adapters::Arpa }]
        when /^WEB (.*)$/       then [nil, { :adapter => Whois::Server::Adapters::Web, :web => $1 }]
        when "CRSNIC"           then ["whois.crsnic.net", { :adapter => Whois::Server::Adapters::Verisign }]
        when /^VERISIGN (.*)$/  then [$1, { :adapter => Whois::Server::Adapters::Verisign }]
        when "PIR"              then ["whois.publicinterestregistry.net", { :adapter => Whois::Server::Adapters::Pir }]
        when "AFILIAS"          then ["whois.afilias-grs.info", { :adapter => Whois::Server::Adapters::Afilias }]
        when "NICCC"            then ["whois.nic.cc", { :adapter => Whois::Server::Adapters::Verisign }]
        else                    [instructions]
      end

      %Q{Whois::Server.define :tld, #{value_to_string(extension)}, #{value_to_string(server)}#{options.nil? ? "" : ", " + options_to_string(options)}\n}
    end
  end

  def parse_list_ipv4
    File.readlines("data/c/ip_del_list").map do |line|
      line.chomp!
      line.gsub!(/^\s*(.*)\s*$/, '\1')
      line.gsub!(/\s*#.*$/, '')
      next if line =~ /^$/;
      abort("format error #{line}") unless line =~ /^([\d\.]+)\/(\d+)\s+([\w\.]+)$/

      range, server = line.split(/[ \t]/)
      server, options = case server
        when /\./           then [server]
        when "UNALLOCATED"  then [nil, { :adapter => Whois::Server::Adapters::None }]
        when "UNKNOWN"      then [nil, { :adapter => Whois::Server::Adapters::None }]
        else                     ["whois.#{server}.net"]
      end

      %Q{Whois::Server.define :ipv4, #{value_to_string(range)}, #{value_to_string(server)}#{options.nil? ? "" : ", " + options_to_string(options)}\n}
    end
  end

  def parse_list_ipv6
    File.readlines("data/c/ip6_del_list").map do |line|
      line.chomp!
      line.gsub!(/^\s*(.*)\s*$/, '\1')
      line.gsub!(/\s*#.*$/, '')
      next if line =~ /^$/;
      abort("format error #{line}") unless line =~ %r{^([\da-fA-F]{4}):([\da-fA-F]{1,4})::/(\d+)\s+([\w\.]+)$}

      range  = "#{$1}:#{$2}::/#{$3}"
      server = $4
      server, options = case server
        when /\./           then [server]
        when "UNALLOCATED"  then [nil, { :adapter => Whois::Server::Adapters::None }]
        when "6to4"         then ["6to4", { :adapter => Whois::Server::Adapters::NotImplemented }]
        when "teredo"       then ["teredo", { :adapter => Whois::Server::Adapters::NotImplemented }]
        else                     ["whois.#{server}.net"]
      end

      %Q{Whois::Server.define :ipv6, #{value_to_string(range)}, #{value_to_string(server)}#{options.nil? ? "" : ", " + options_to_string(options)}\n}
    end
  end

  def options_to_string(options)
    options.is_a?(Hash) ? options.map do |k, v|
      ":#{k} => " + (v.is_a?(Hash) ? ('{ ' + options_to_string(v) + ' }') : "#{value_to_string(v)}")
    end.join(", ") : options.to_s
  end

  def value_to_string(value)
    case value
      when NilClass then "nil"
      when String   then '"' + value.to_s + '"'
      else value.to_s
    end
  end

end