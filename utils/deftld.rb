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

        type: :_type,
        group: :_group,
        note: :_note,
    }


    # Normalizes the TLD name by appending the dot, if missing.
    #
    # @return [String] the normalized TLD name
    def self.name(string)
      string = string.to_str
      string.start_with?(".") ? string : ".#{string}"
    end

    def initialize(name, attributes = {})
      @name = self.class.name(name)
      @attributes = {}

      update(attributes)
    end

    # Updates the definition attributes.
    #
    # @param  attributes [Hash]
    # @return [void]
    def update(attributes = {})
      validate(attributes)

      attributes.each do |key, value|
        @attributes[ATTRIBUTES[key.to_sym]] = value
      end
    end

    # Validates the definitions to make sure there are no unknown attributes.
    #
    # @param  attributes [Hash]
    # @return [void]
    # @raise  [ArgumentError] when a definition attribute is unknown
    def validate(attributes)
      keys = ATTRIBUTES.keys
      attributes.each do |key, _|
        keys.include?(key.to_sym) or
            raise ArgumentError, "Invalid attribute `#{key}`"
      end
    end

    # Dump the definition object into a serializable Hash.
    #
    # @return [Hash] the serializable hash
    def dump
      @attributes.reject { |_, value| value.nil? }
    end
  end

  def initialize(file_path)
    @path = Pathname.new(file_path)
  end

  def read
    JSON.load(@path)
  end

  def write(data)
    data[KEY_SCHEMA] = schema_attributes
    data = Hash[data.sort_by { |tld, _| tld.split(".").reverse.join(".") }]
    JSON.pretty_generate(data)
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
        tlddef = TldDef.new(tld, defs[tld]).update(attributes)
        defs[tld] = tlddef.dump
      end
    end
  end

  def update
    data = read
    puts "#{data.count} definitions read"
    yield data
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

args = ARGV
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: deftld command [options]"
  opts.separator <<~EOS

Commands:
\tadd
\tupdate

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

defs = TldDefs.new(File.expand_path("../../data/tld.json", __FILE__))

case command = args.shift
when "add"
  defs.tlds_add(*args, options)
when "update"
  defs.tlds_update(*args, options)
else
  puts "Unknown command `#{command}`"
  exit 1
end
