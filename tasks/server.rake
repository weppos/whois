namespace :server do
  
  desc "server:convert_file_tld"
  task :convert_file_tld do
    servers = File.readlines("data/tld_serv_list").map do |line|
      line.chomp!
      line.gsub!(/^\s*(.*)\s*$/, '\1')
      line.gsub!(/\s*#.*$/, '')
      if line =~ /^([\w\d\.-]+)\s+([\w\d\.:-]+|[A-Z]+\s+.*)$/
        extension, server = $1, $2
        [extension, server]
      end
    end.reject { |value| value == '' || value.nil? }
    
    File.open("lib/whois/servers.yml", "w+") { |f| f.write(YAML.dump(servers)) }
    puts "Created file with #{servers.size} servers."
  end
  
end