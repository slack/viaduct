require 'middleware'
require 'pp'

class BasicMiddleware
  def initialize(app, env)
    @app = app
    @env = env
  end

  def call(env)
    raise "call not implemented"
  end
end

class SimpleThing < BasicMiddleware
  def call(env)
    puts "Hi"
    pp env
    @app.call(env)
  end
end

class InstanceProvisioner < BasicMiddleware
  def call(env)
    raise unless instance = env[:instance]
    instance.provisioned_id = 'fooooooooo'

    @app.call(env)
  end

  def recover(env)
    puts "recover called!"
    pp env
  end
end

class Raiser < BasicMiddleware
  def call(env)
    raise "set to explode in env" if env.has_key?(:raise_up)
    @app.call(env)
  end
end

class Instance
  def initialize(id)
    @id = id
  end
  attr_reader :id
  attr_accessor :provisioned_id
end

app = Middleware::Builder.new do
  use SimpleThing
  use InstanceProvisioner
  use Raiser
end

instance = Instance.new(1)

Middleware::Runner.new.run(app, instance: instance, raise_up: true)

pp instance
