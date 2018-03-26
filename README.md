# [Whois](https://whoisrb.org/)

<tt>Whois</tt> is an intelligent — pure Ruby — WHOIS client and parser.

This library was extracted from [RoboWhois](https://robowhois.com/) and [RoboDomain](https://robodomain.com/), and it's now in use at [DNSimple](https://dnsimple.com/). It has been performing queries in production since July 2009.

[![Build Status](https://travis-ci.org/weppos/whois.svg?branch=master)](https://travis-ci.org/weppos/whois)


## Donate a coffee

<tt>Whois</tt> is free software, but it requires a lot of coffee to write, test, and distribute it. You can support the development by [donating a coffee](https://whoisrb.org/contribute/#donate).

Any amount is greatly appreciated.


## Features

- Ability to lookup WHOIS record for [IPv4, IPv6, TLDs, and ICANN new gTLDs](http://whoisrb.org/manual/usage/#usage-objects)
- Ability to [parse WHOIS responses](http://whoisrb.org/manual/parser/) (via the `whois-parser` library)
- Flexible and extensible interface (e.g. You can define [custom servers](http://whoisrb.org/manual/server/) on the fly)
- Object oriented design, featuring 10 different design patterns
- Pure Ruby library, without any external dependency other than Ruby itself
- Successfully tested against different Ruby implementations, including Ruby and JRuby


## Whois and Whois parser

Starting from version 4, WHOIS parser component is available in a separate repository called [whois-parser](https://github.com/weppos/whois-parser), and released as a separate gem called `whois-parser`.

This repository contains the core whois library, that includes the WHOIS client, the server definitions and all the features required to perform WHOIS queries and obtain the WHOIS record.


## Requirements

* Ruby >= 2.0.0

For older versions of Ruby, see the [CHANGELOG](CHANGELOG.md).


## Installation

You can install the gem manually:

```shell
gem install whois
```

Or use [Bundler](http://bundler.io/) and define it as a dependency in your `Gemfile`:

```ruby
gem 'whois'
```

To use the WHOIS parser component you need to install the `whois-parser` gem:

```shell
gem install whois-parser
```

```ruby
gem 'whois-parser'
```

The `whois-parser` gem already depends on the `whois` gem. If you install `whois-parser`, `whois` will be installed as well and it will also be automatically required when you `require 'whois-parser'`.

If you are upgrading to 4.0, see [4.0-Upgrade.md](4.0-Upgrade.md).


## Getting Started

Note. This section covers only the essentials for getting started with the Whois library. The [documentation](https://whoisrb.org/docs/) provides a more accurate explanation including tutorials, more examples and technical details about the client/server/record/parser architecture.

### Querying a WHOIS

<tt>Whois</tt> provides the ability to get WHOIS information for TLD, domain names, IPv4 and IPv6 addresses. The client is smart enough to guess the best WHOIS server according to given query, send the request and return the response.

Check out the following examples:

```ruby
# Domain WHOIS
whois = Whois::Client.new
whois.lookup("google.com")
# => #<Whois::Record>

# TLD WHOIS
whois = Whois::Client.new
whois.lookup(".com")
# => #<Whois::Record>

# IPv4 WHOIS
whois = Whois::Client.new
whois.lookup("74.125.67.100")
# => #<Whois::Record>

# IPv6 WHOIS
whois = Whois::Client.new
whois.lookup("2001:db8::1428:57ab")
# => #<Whois::Record>
```

The query method is stateless. For this reason, you can safely re-use the same client instance for multiple queries.

```ruby
whois = Whois::Client.new
whois.lookup("google.com")
whois.lookup(".com")
whois.lookup("74.125.67.100")
whois.lookup("2001:db8::1428:57ab")
whois.lookup("google.it")
```

If you just need a WHOIS response and you don't care about a full control of the WHOIS client, the `Whois` module provides an all-in-one method called `Whois.whois`. This is the simplest way to send a WHOIS request.

```ruby
Whois.whois("google.com")
# => #<Whois::Record>
```

Did I mention you can even use blocks?

```ruby
Whois::Client.new do |w|
  w.lookup("google.com")
  w.lookup(".com")
  w.lookup("74.125.67.100")
  w.lookup("2001:db8::1428:57ab")
  w.lookup("google.it")
end
```

### Consuming the Record

Any WHOIS query returns a `Whois::Record`. This object looks like a String, but it's way more powerful.

`Whois::Record` encapsulates a WHOIS record and provides the ability to parse the WHOIS response programmatically, when the `whois-parser` gem is installed and loaded.

```ruby
require 'whois-parser'

record = Whois.whois("google.it")
# => #<Whois::Record>

parser = record.parser
# => #<Whois::Parser>

parser.available?
# => false
parser.registered?
# => true

parser.created_on
# => Fri Dec 10 00:00:00 +0100 1999

tech = parser.technical_contacts.first
# => #<Whois::Record::Contact>
tech.id
# => "TS7016-ITNIC"
tech.name
# => "Technical Services"

parser.nameservers.each do |nameserver|
  puts nameserver
end
```

This feature is made possible by the <tt>Whois</tt> record parsers. Unfortunately, due to the lack of a global standard, each WHOIS server requires a specific parser. For this reason, the library doesn't support all existing WHOIS servers.

If you create a new parser, please consider releasing it to the public so that it can be included in a next version.

### Timeout

By default, each query run though the client has a timeout value of 5 seconds. If the execution exceeds the timeout limit, the client raises a `Timeout::Error` exception.

Of course, you can customize the timeout value setting a different value. If timeout is `nil`, the client will wait until the response is sent back from the server or the process is killed. Don't disable the timeout unless you really know what you are doing!

```ruby
whois = Whois::Client.new(:timeout => 10)
whois.timeout # => 10
whois.timeout = 5
whois.timeout # => 5

whois.lookup("google.com")
```


## Credits

<tt>Whois</tt> was created and is maintained by [Simone Carletti](https://simonecarletti.com/). Many improvements and bugfixes were contributed by the [open source community](https://github.com/weppos/whois/graphs/contributors).


## Contributing

Direct questions and discussions to [Stack Overflow](https://stackoverflow.com/questions/tagged/whois-ruby).

[Pull requests](https://github.com/weppos/whois/pulls) are very welcome! Please include spec and/or feature coverage for every patch, and create a topic branch for every separate change you make.

Report issues or feature requests to [GitHub Issues](https://github.com/weppos/whois/issues).


## More Information

- [Homepage](http://whoisrb.org/)
- RubyGems: [`whois`](https://rubygems.org/gems/whois) and [`whois-parser`](https://rubygems.org/gems/whois-parser)
- Issues: [`whois`](https://github.com/weppos/whois) and [`whois-parser`](https://github.com/weppos/whois-parser)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/whois-ruby)


## Versioning

<tt>Whois</tt> uses [Semantic Versioning 2.0.0](http://semver.org)


## License

Copyright (c) 2009-2018 [Simone Carletti](https://simonecarletti.com/). This is Free Software distributed under the MIT license.
