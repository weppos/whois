#!/usr/bin/env ruby

require 'optparse'
require 'pathname'
require 'json'

class TldDefs

  KEY_SCHEMA = "_".freeze

  # The current schema version for the definition file
  #
  # @return [String] version
  SCHEMA_VERSION = "2".freeze


  class ChangeError < StandardError
  end

  class TldDef
    attr_accessor :name

    attr_accessor :host
    attr_accessor :adapter
    attr_accessor :format
    attr_accessor :url

    attr_accessor :type
    attr_accessor :group
    attr_accessor :note

    ATTRIBUTES = {
        host: :host,
        adapter: :adapter,
        format: :format,
        url: :url,

        note: :_note,
        type: :_type,
    }


    # Normalizes the TLD name by appending the dot, if missing.
    #
    # @return [String] the normalized TLD name
    def self.name(string)
      string = string.to_str.downcase
      string.start_with?(".") ? string[1..-1] : string
    end

    def initialize(name, attributes = {})
      @name = self.class.name(name)
      @attributes = {}

      update(attributes)
    end

    def load(attributes = {})
      validate(ATTRIBUTES.values, attributes)

      attributes.each do |key, value|
        @attributes[key.to_sym] = value
      end

      self
    end

    # Updates the definition attributes.
    #
    # @param  attributes [Hash]
    # @return [void]
    def update(attributes = {})
      validate(ATTRIBUTES.keys, attributes)

      attributes.each do |key, value|
        @attributes[ATTRIBUTES[key.to_sym]] = value
      end

      self
    end

    # Validates the definitions to make sure there are no unknown attributes.
    #
    # @param  allowed [Array]
    # @param  attributes [Hash]
    # @return [void]
    # @raise  [ArgumentError] when a definition attribute is unknown
    def validate(allowed, attributes)
      attributes.each do |key, _|
        allowed.include?(key.to_sym) or
            raise ArgumentError, "Invalid attribute `#{key}`"
      end
    end

    # Dump the definition object into a serializable Hash.
    #
    # Private attributes (starting by _) are added on top.
    # Keys are sorted alphabetically.
    #
    # @return [Hash] the serializable hash
    def dump
      Hash[@attributes.reject { |_, value| value.nil? }.sort]
    end
  end


  # @param  file_path [String] path to the TLD definition file
  # @param  ignore_missing [Boolean] set to true to silently skip missing TLDs on update.
  #         When set to false, an error will be raised.
  def initialize(file_path, ignore_missing: true)
    @path = Pathname.new(file_path)
    @settings = {
        ignore_missing: ignore_missing
    }
  end

  def read
    JSON.load(@path)
  end

  def write(data)
    data[KEY_SCHEMA] = schema_attributes
    data = Hash[data.sort_by { |tld, _| tld.split(".").reverse.join(".") }]
    File.write(@path, JSON.pretty_generate(data))
  end

  def count
    read.count
  end

  def tlds_add(*tlds, **attributes)
    update do |defs|
      tlds.each do |tld|
        tld = TldDef.name(tld)
        tlddef = TldDef.new(tld, attributes)
        defs[tld] = tlddef.dump
      end
    end
  end

  def tlds_update(*tlds, **attributes)
    update do |defs|
      tlds.each do |tld|
        tld = TldDef.name(tld)
        # puts(tld) if !defs.key?(tld)
        next if !defs.key?(tld) && @settings[:ignore_missing]
        raise ChangeError, "error updating `#{tld}`, tld is missing" if !defs.key?(tld) && !@settings[:ignore_missing]

        tlddef = TldDef.new(tld).load(defs[tld]).update(attributes)
        defs[tld] = tlddef.dump
      end
    end
  end

  def update
    data = read
    puts "#{data.count} definitions read"
    yield data if block_given?
    write(data)
    puts "#{data.count} definitions written"
    data
  end

  def validate
    read.each do |tld, data|
      TldDef.new(tld, data)
    end; nil
  end

  private

  def schema_attributes
    {
        "schema" => SCHEMA_VERSION,
        "updated" => Time.now.utc,
    }
  end

end


defs = TldDefs.new(File.expand_path("../../data/tld.json", __FILE__))

args = ARGV
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: deftld command [options]"
  opts.separator <<~EOS

Commands:
\tadd
\tupdate
\tvalidate
\tfmt

Options:
  EOS

  TldDefs::TldDef::ATTRIBUTES.each do |key, _|
    opts.on("--#{key} [VALUE]", String, "set the #{key}") do |value|
      options[key] = value
    end
  end

  begin
    opts.parse!
  rescue OptionParser::ParseError
    puts opts
    exit 1
  end

  if args.size.zero?
    puts opts
    exit 1
  end
end

case command = args.shift
when "validate"
  defs.validate
when "fmt"
  defs.update
when "add"
  defs.tlds_add(*args, options)
when "update"
  defs.tlds_update(*args, options)
else
  puts "Unknown command `#{command}`"
  exit 1
end
