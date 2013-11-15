#!/usr/bin/env ruby -w

ROOT = File.expand_path("../..", __FILE__)
LIB  = File.join(ROOT, "lib")

$:.unshift(LIB)

def pretty_state(state)
  case state
  when :supported       then 'Y'
  when :not_supported   then 'N'
  when :not_implemented then '.'
  end
end

def matrix(hosts)
  hosts.map do |host|
    klass = P.parser_klass(host)
    props = klass._properties
    PROPERTIES.inject([host]) { |all, property| all << pretty_state(props[property]) }
  end
end

def markdown_matrix(matrix, header: nil, formatter: ->(columns) { "| #{columns.join(" | ")} |" })
  matrix = matrix.dup
  length = matrix.inject(0) { |l, row| l = row[0].size > l ? row[0].size : l }
  matrix.each { |row| row[0] = row[0].ljust(length) }

  output  = matrix.map(&formatter)
  if header
    string = formatter.(header)
    output.unshift [string, string.gsub(/([^\|])/, "-")]
  end
  output.join("\n")
end


require 'whois'

P = Whois::Record::Parser
PROPERTIES = [:disclaimer, :domain, :domain_id, :status, :available?, :registered?, :created_on, :updated_on, :expires_on, :registrar, :registrant_contacts, :admin_contacts, :technical_contacts, :nameservers]

hosts = Dir.glob(File.join(LIB, "whois/record/parser/*.rb"))
           .reject { |f| f =~ /\/(base|blank|example)/ }
           .map { |f| File.basename(f, ".rb") }

pthin = %w(
  whois.1und1.info
  whois.ascio.com
  whois.comlaude.com
  whois.dreamhost.com
  whois.enom.com
  whois.gandi.net
  whois.godaddy.com
  whois.markmonitor.com
  whois.networksolutions.com
  whois.pairnic.com
  whois.register.com
  whois.rrpproxy.net
  whois.schlund.info
  whois.tucows.com
  whois.udag.net
  whois.yoursrs.com
)
ptlds = hosts - pthin

puts markdown_matrix(matrix(ptlds), header: ["parser"] + PROPERTIES)
puts markdown_matrix(matrix(pthin), header: ["parser"] + PROPERTIES)
