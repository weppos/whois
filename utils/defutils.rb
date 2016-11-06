#!/usr/bin/env ruby

args = ARGV
case command = args.shift

# Command retag-newgtld
when "retag-newgtld"
  require 'open-uri'

  tlds = []
  count = 0
  open("https://newgtlds.icann.org/newgtlds.csv").each_line do |line|
    count += 1
    next if count < 3
    tlds << line.split(",", 2).first
  end

  puts "Updating #{tlds.size} newGTLDs..."
  puts "utils/deftld.rb update #{tlds.join(" ")} --type newgtld"
  puts `utils/deftld.rb update #{tlds.join(" ")} --type newgtld`

else
  puts "Unknown command `#{command}`"
  exit 1
end

