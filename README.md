# Whois

*Whois* is an intelligent pure Ruby WHOIS client and parser.

[![Build Status](https://secure.travis-ci.org/weppos/whois.png)](http://travis-ci.org/weppos/whois)

*Whois* is a OS-independent library and doesn't require any external binaries or C libraries: it is a 100% Ruby software.

This library was developed to power [RoboDomain](https://www.robodomain.com) and, since July 2009, it ran more than thousands requests.

An extensive test suite is available to verify the library correctness but you must be aware that registrant might change WHOIS interfaces without notice and at any time causing queries to specific hosts to stop working.


## Features

* Ability to query registry data for [IPv4, IPv6, TLDs, and domain names](http://www.ruby-whois.org/manual/usage.html#usage-objects)
* Ability to [parse WHOIS responses](http://www.ruby-whois.org/manual/parser.html)
* Flexible and extensible interface (e.g. You can define [custom servers](http://www.ruby-whois.org/manual/server.html) on the fly)
* Object oriented design, featuring 10 different design patterns
* Pure Ruby library, without any external dependency other than Ruby itself
* Compatible with [Ruby 1.8.7 and greater](http://www.ruby-whois.org/manual/installing.html#installation-requirements), including Ruby 1.9 branch
* Successfully tested against several [Ruby implementations](http://www.ruby-whois.org/manual/interpreters.html)


## Requirements

* Ruby >= 1.8.7

*Whois* >= 1.5 requires Ruby 1.8.7 or newer.
For older versions of Ruby, see the CHANGELOG.rdoc file.

In addition to the standard Ruby interpreter (MRI),
Whois has been successfully tested against several
[Ruby implementations](http://www.ruby-whois.org/manual/interpreters.html).


## Installation

The best way to install *Whois* is via [RubyGems](https://rubygems.org/).

    $ gem install whois

You might need administrator privileges on your system to install the gem.


## Upgrade

Install the newer version via RubyGems.

    $ gem install whois

Minor and bugfix releases normally won't break backwards-compatibility. You can read the CHANGELOG.rdoc file to learn about the changes in each release.

Read the [Upgrading](http://www.ruby-whois.org/manual/upgrading.html) documentation page for detailed information about incompatible changes and further instructions.


## Getting Started

Note. This section covers only the essentials for getting started with the Whois library. The [documentation](http://www.ruby-whois.org/documentation.html) provides a more accurate explanation including tutorials, more examples and technical details about the client/server/record/parser architecture.

### Querying the Server

Whois provides the ability to get WHOIS information for TLD, domain names, IPv4 and IPv6 addresses. The client is smart enough to guess the best WHOIS server according to given query, send the request and return the response.

Check out the following examples:

    # Domain WHOIS
    w = Whois::Client.new
    w.query("google.com")
    # => #<Whois::Record>

    # TLD WHOIS
    w = Whois::Client.new
    w.query(".com")
    # => #<Whois::Record>

    # IPv4 WHOIS
    w = Whois::Client.new
    w.query("74.125.67.100")
    # => #<Whois::Record>

    # IPv6 WHOIS
    w = Whois::Client.new
    w.query("2001:db8::1428:57ab")
    # => #<Whois::Record>

The query method is stateless. For this reason, you can safely re-use the same client instance for multiple queries.

    w = Whois::Client.new
    w.query("google.com")
    w.query(".com")
    w.query("74.125.67.100")
    w.query("2001:db8::1428:57ab")
    w.query("google.it")

If you just need a WHOIS response and you don't care about a full control of the WHOIS client, the {Whois} module provides an all-in-one method called {Whois.whois}. This is the simplest way to send a WHOIS request.

    Whois.whois("google.com")
    # => #<Whois::Record>

Did I mention you can even use blocks?

    Whois::Client.new do |w|
      w.query("google.com")
      w.query(".com")
      w.query("74.125.67.100")
      w.query("2001:db8::1428:57ab")
      w.query("google.it")
    end

### Consuming the Record

Any WHOIS query returns a {Whois::Record}. This object looks like a String, but it's way more powerful.

{Whois::Record} encapsulates a WHOIS record and provides the ability to parse the WHOIS response programmatically, by using an object oriented syntax.

    r = Whois.whois("google.it")
    # => #<Whois::Record>
  
    r.available?
    # => false
    r.registered?
    # => true
  
    r.created_on
    # => Fri Dec 10 00:00:00 +0100 1999
  
    t = r.technical_contact
    # => #<Whois::Record::Contact>
    t.id
    # => "TS7016-ITNIC"
    t.name
    # => "Technical Services"
  
    r.nameservers.each do |nameserver|
      puts nameserver
    end

This feature is made possible by the *Whois* record parsers. Unfortunately, due to the lack of a global standard, each WHOIS server requires a specific parser. For this reason, the library doesn't support all existing WHOIS servers.

If you create a new parser, please consider releasing it to the public so that it can be included in a next version.

### Timeout

By default, each query run though the client has a timeout value of 5 seconds. If the execution exceeds timeout limit, the client raises a {Timeout::Error} exception.

Off course, you can customize the timeout value setting a different value. If timeout is `nil`, the client will until the response is sent back from the server or the process is killed. Don't disable the timeout unless you really know you are doing!

    w = Whois::Client.new(:timeout => 10)
    w.timeout # => 10
    w.timeout = 5
    w.timeout # => 5
  
    w.query("google.com")


## Acknowledgments

First of all, I would like to express my most sincere thanks to Cyril Mougel, the author of the first Ruby Whois gem that has been available since 2007. Cyril has been kind enough to yield me the privilege of using the RubyForge Whois project and the Whois package name to publish this library. To express all my gratitude, the release 0.5.0 and all sub sequential versions of the new Whois up to 0.9.x are 100% compatible with Cyril's Whois.

Whois is largely inspired by other notable Whois projects, most of all the Debian Whois library written and maintained by Marco D'Itri. Other good ideas and design decisions come from the PERL `Net::DRI` package.

I would lie if I say I'm completely unaware of the other Ruby Whois projects. Before starting this Ruby Whois library I deeply investigated the available resources and, despite none of them was a good candidate for a refactoring, some of them expose a really cool API.
They didn't directly influence this library or any design decision, but they have been a really interesting code-reading.

The parser architecture has been inspired by the [PHPWhois](http://phpwhois.sourceforge.net/) project. The authors puts lot of effort to create whois-specific parsers normalizing the different responses in a single tree-based structure. So far, this is the only one open source project that offers such this feature in all the programming language ecosystem.

Despite I spent weeks reading source code from the available whois libraries, Ruby *Whois* has been built from scratch trying to focus on long-term maintainability and flexibility and cannot be considered a Ruby port of any of other existing Whois libraries.


## Author

Author: [Simone Carletti](http://www.simonecarletti.com/) <weppos@weppos.net>


## Thanks to

Everyone [in this list](https://github.com/weppos/whois/contributors).


## Contribute

Direct questions and discussions to the [mailing list](http://groups.google.com/group/ruby-whois).

Pull requests are very welcome! Please include spec and/or feature coverage for every patch, and create a topic branch for every separate change you make.

Report issues or feature requests to [GitHub Issues](https://github.com/weppos/whois/issues).


## More

* [Homepage](http://www.ruby-whois.org/)
* [Repository](https://github.com/weppos/whois)
* [Documentation](http://www.ruby-whois.org/documentation.html) - The official documentation, see also the [API Documentation](/api).
* [Discussion Group](http://groups.google.com/group/ruby-whois)


## Changelog

See the CHANGELOG.rdoc file for details.


## License

Copyright (c) 2009-2012 Simone Carletti.

This is Free Software distributed under the MIT license.
