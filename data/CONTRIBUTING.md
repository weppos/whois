# Contributing

We love pull requests from everyone. By participating in this project, you agree to abide by the contribution [code of conduct](http://contributor-covenant.org/version/1/2/0/).

## Workflow

Fork, then clone the repo:

    $ git clone git@github.com:your-username/whois.git

Set up your machine:

    $ bundle

Make sure the tests pass:

    $ bundle exec rake

To propose a change/feature/patch, create your feature branch:

    $ git checkout -b my-new-feature

Make your change. Add tests for your change. Make the tests pass:

    $ bundle exec rake

Commit your changes:

    $ git commit -am 'Add some feature'

Push to your fork and [submit a pull request](https://github.com/weppos/whois/compare/).


## Tests

To increase the chance that your pull request is accepted please **make sure to write tests**. Changes without corresponding tests will likely not be included as they will produce fragile code that can easily break whenever the registry changes the response format.
