# Viaduct

Use middleware in your application. Catch exceptions and walk back up the stack!

Mitchell also created the [middlware](https://github.com/mitchellh/middleware) gem, but it did not contain the warden code which is what interested me the most. Thus, viaduct.

* Source: [https://github.com/slack/viaduct](https://github.com/slack/viaduct)

Extracted from Mitchell Hashimoto and John Bender's very excellent [Vagrant](http://vagrantup.com).

## Installation

Add this line to your application's Gemfile:

    gem 'viaduct'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install viaduct

## Usage

If you've spent any time using [rack](http://rack.github.io/) Viaduct will be very familiar.

Simply:

1. Define middlware classes that respond to `new` and `call`
2. Create your middleware stack with `Viaduct::Builder`
3. Run your stack with `Viaduct::Runner`

For a few examples see the [integration example spec](spec/integration_spec.rb).

Let's define two middlewares, one that appends text to the environment and one that removes an element.

```ruby
class Add
  def initialize(app, env)
    @app, @env = app, env
  end

  def call(env)
    env[:data] << "adding"
    @app.call(env)
  end
end

class Remove
  def initialize(app, env)
    @app, @env = app, env
  end

  def call(env)
    env[:data].shift
    @app.call(env)
  end
end
```

Organize these into a sequence:

```ruby
stack = Viaduct::Builder.new do
  use Add
  use Remove
  use Add
end
```

Then execute that sequence by calling `Viaduct::Runner.run`:

```ruby
env = { data: [] }
result = Viaduct::Runner.run(stack, env})
#=> { data: ['adding'] }
```

### Handling exceptions

`Viaduct::Runner` is responsible for the execution of your sequence. The first argument to `run` should be either a sequence from `Viaduct::Builder` or a ruby class that responds to `call`.

Runner will hand the `env` hash to each of your middlwares, handling any excpetions. In the event that any down-stream middlware raises, Viaduct will walk back up the stack calling `recover` on each middleware see [handling exceptions example](spec/integration_spec.rb).

### Debugging

If you pass in an instance of `Logger` to `Viaduct::Runner` (or something that looks like a logger) Viaduct will add happily log execution information:

```ruby
sequence = Viaduct::Builder.new do
  use Robust
  use Flaky
end

Viaduct::Runner.run(sequence, logger: Logger.new($stderr))
#I, [2013-04-19T22:28:29.931249 #847]  INFO -- : Calling action: #<Robust:0x007fb20255bf98>
#I, [2013-04-19T22:28:29.931329 #847]  INFO -- : Calling action: #<Flaky:0x007fb20255bf48>
#E, [2013-04-19T22:28:29.931404 #847] ERROR -- : Error occurred: I'm having trouble
#I, [2013-04-19T22:28:29.931441 #847]  INFO -- : Calling recover: #<Robust:0x007fb20255bf98>
#E, [2013-04-19T22:28:29.931488 #847] ERROR -- : Error occurred: I'm having trouble
```

## Tests

    $ bundle exec rake

Or automatically run tests with guard

    $ bundle exec guard

## Releasing

    $ gem install gem-release
    $ gem bump -trv patch

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
