require 'spec_helper'

describe "a simple set of middlwares" do
  class Add
    def initialize(app, env); @app, @env = app, env; end

    def call(env)
      env[:data] << "adding"
      @app.call(env)
    end
  end

  class Remove
    def initialize(app, env); @app, @env = app, env; end

    def call(env)
      env[:data].shift
      @app.call(env)
    end
  end

  it "works" do
    stack = Viaduct::Builder.new do
      use Add
      use Remove
      use Add
    end

    env = Viaduct::Runner.run(stack, {data: []})
    env[:data].should == ['adding']
  end
end

describe "handling exceptions" do
  class Robust
    def initialize(app, env); @app, @env = app, env; end

    def call(env)
      @app.call(env)
    end

    def recover(env)
      env[:logger].error "I got this!"
    end
  end

  class Flaky
    class OMG < StandardError; end

    def initialize(app, env); @app, @env = app, env; end

    def call(env)
      raise OMG.new("I'm having trouble")
    end
  end

  let(:sequence) { Viaduct::Builder.new { use Robust; use Flaky } }

  it "has a chance to handle exceptions" do
    expect {
      Viaduct::Runner.run(sequence, { logger: Logger.new(nil) })
    }.to raise_error Flaky::OMG
  end
end
