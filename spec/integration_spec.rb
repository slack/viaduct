require 'spec_helper'

describe "integration" do
  class AddOne
    def initialize(app, env); @app, @env = app, env; end

    def call(env)
      env[:sum] += 1
      @app.call(env)
    end
  end

  class Noop
    def initialize(app, env); @app, @env = app, env; end

    def call(env)
      @app.call(env)
    end
  end

  it "works" do
    stack = Viaduct::Builder.new do
      use AddOne
      use AddOne
      use Noop
    end

    env = Viaduct::Runner.run(stack, sum: 0)
    env[:sum].should == 2
  end

  it "runs simple classes" do
    env = Viaduct::Runner.run(Noop, sum: 0)
    env[:sum].should == 0
  end
end
