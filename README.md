# Whois

<tt>Whois</tt> is an intelligent pure Ruby WHOIS client and parser.

[![Build Status](https://secure.travis-ci.org/weppos/whois.png)](http://travis-ci.org/weppos/whois)

<tt>Whois</tt> is a OS-independent library and doesn't require any external binaries or C libraries: it is a 100% Ruby software.

This library was created to power [RoboWhois](https://www.robowhois.com/) and [RoboDomain](https://www.robodomain.com/). It has been performing queries in production since July 2009.


## Donate a coffee

<p id="pledgie" class="alignright"><a href="https://pledgie.com/campaigns/11383"><img alt="Click here to lend your support to: whois and make a donation at pledgie.com !" src="https://pledgie.com/campaigns/11383.png?skin_name=chrome" border="0" style="max-width:100%;"></a></p>

<tt>Whois</tt> is free software, but it requires a lot of coffee to write, test, and distribute it. You can support the development by [donating a coffee](https://pledgie.com/campaigns/11383).


## Features

- Ability to query registry data for [IPv4, IPv6, TLDs, and domain names](http://www.ruby-whois.org/manual/usage/#usage-objects)
- Ability to [parse WHOIS responses](http://www.ruby-whois.org/manual/parser/)
- Flexible and extensible interface (e.g. You can define [custom servers](http://www.ruby-whois.org/manual/server/) on the fly)
- Object oriented design, featuring 10 different design patterns
- Pure Ruby library, without any external dependency other than Ruby itself
- Successfully tested against several [Ruby implementations](http://www.ruby-whois.org/manual/interpreters/)


## Requirements

* Ruby >= 1.9.2

For older versions of Ruby, see the [CHANGELOG](CHANGELOG.md).


## Installation

The best way to install <tt>Whois</tt> is via [RubyGems](https://rubygems.org/) - [Learn more](http://www.ruby-whois.org/manual/installing/).

    $ gem install whois


## Getting Started

Note. This section covers only the essentials for getting started with the Whois library. The [documentation](http://www.ruby-whois.org/documentation/) provides a more accurate explanation including tutorials, more examples and technical details about the client/server/record/parser architecture.

### Querying a WHOIS

<tt>Whois</tt> provides the ability to get WHOIS information for TLD, domain names, IPv4 and IPv6 addresses. The client is smart enough to guess the best WHOIS server according to given query, send the request and return the response.

Check out the following examples:

```ruby
# Domain WHOIS
w = Whois::Client.new
w.lookup("google.com")
# => #<Whois::Record>

# TLD WHOIS
w = Whois::Client.new
w.lookup(".com")
# => #<Whois::Record>

# IPv4 WHOIS
w = Whois::Client.new
w.lookup("74.125.67.100")
# => #<Whois::Record>

# IPv6 WHOIS
w = Whois::Client.new
w.lookup("2001:db8::1428:57ab")
# => #<Whois::Record>
```

The query method is stateless. For this reason, you can safely re-use the same client instance for multiple queries.

```ruby
w = Whois::Client.new
w.lookup("google.com")
w.lookup(".com")
w.lookup("74.125.67.100")
w.lookup("2001:db8::1428:57ab")
w.lookup("google.it")
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

`Whois::Record` encapsulates a WHOIS record and provides the ability to parse the WHOIS response programmatically, by using an object oriented syntax.

```ruby
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
```

This feature is made possible by the <tt>Whois</tt> record parsers. Unfortunately, due to the lack of a global standard, each WHOIS server requires a specific parser. For this reason, the library doesn't support all existing WHOIS servers.

If you create a new parser, please consider releasing it to the public so that it can be included in a next version.

### Timeout

By default, each query run though the client has a timeout value of 5 seconds. If the execution exceeds timeout limit, the client raises a `Timeout::Error` exception.

Off course, you can customize the timeout value setting a different value. If timeout is `nil`, the client will until the response is sent back from the server or the process is killed. Don't disable the timeout unless you really know you are doing!

```ruby
w = Whois::Client.new(:timeout => 10)
w.timeout # => 10
w.timeout = 5
w.timeout # => 5

w.lookup("google.com")
```


## Credits

<tt>Whois</tt> was created and is maintained by [Simone Carletti](http://www.simonecarletti.com/). Many improvements and bugfixes were contributed by the [open source community](https://github.com/weppos/whois/graphs/contributors).


## Contributing

Direct questions and discussions to [Stack Overflow](http://stackoverflow.com/questions/tagged/whois-ruby).

[Pull requests](https://github.com/weppos/whois/pulls) are very welcome! Please include spec and/or feature coverage for every patch, and create a topic branch for every separate change you make.

Report issues or feature requests to [GitHub Issues](https://github.com/weppos/whois/issues).


## More Information

- [Homepage](http://www.ruby-whois.org/)
- [RubyGems](https://rubygems.org/gems/whois)
- [Issues](https://github.com/weppos/whois)
- [Stack Overflow](http://stackoverflow.com/questions/tagged/whois-ruby)


## License

Copyright (c) 2009-2014 Simone Carletti. This is Free Software distributed under the MIT license.
