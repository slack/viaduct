# Viaduct

* Source: [https://github.com/slack/viaduct](https://github.com/slack/viaduct)

Use the middleware pattern in your application.

Extracted from the very excellent [Vagrant](http://vagrantup.com) by Mitchell Hashimoto and John Bender

Mitchell also created the [middlware](https://github.com/mitchellh/middleware) gem, but it did not contain the warden code which is what interested me the most. Thus, viaduct.

## Installation

Add this line to your application's Gemfile:

    gem 'viaduct'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install viaduct

## Tests

  $ bundle exec rake

Or automatically run tests with guard

  $ bundle exec guard

## Releasing

    $ gem install gem-release
    $ gem bump -trv patch

## Usage

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
